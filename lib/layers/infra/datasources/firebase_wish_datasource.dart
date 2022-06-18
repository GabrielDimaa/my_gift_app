import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/extensions/firebase_exception_extension.dart';
import '../models/user_model.dart';
import './constants/collection_reference.dart';
import '../helpers/errors/infra_error.dart';
import 'i_user_account_datasource.dart';
import 'i_wish_datasource.dart';
import '../models/wish_model.dart';
import 'storage/i_storage_datasource.dart';

class FirebaseWishDataSource implements IWishDataSource {
  final FirebaseFirestore firestore;
  final IUserAccountDataSource userDataSource;
  final IStorageDataSource storageDataSource;

  FirebaseWishDataSource({
    required this.firestore,
    required this.userDataSource,
    required this.storageDataSource,
  });

  @override
  Future<WishModel> getById(String id) async {
    try {
      final snapshot = await firestore.collection(constantWishesReference).doc(id).get();

      final Map<String, dynamic>? json = snapshot.data();
      json?.addAll({'id': snapshot.id});

      if (json?['user_id'] == null) throw NotFoundInfraError();

      //Busca o usuário
      final UserModel user = await userDataSource.getById(json?['user_id']);
      json?.addAll({
        'user': user.toJson()..addAll({'id': user.id})
      });

      if (!WishModel.validateJson(json)) throw NotFoundInfraError();

      return WishModel.fromJson(json!);
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<List<WishModel>> getByWishlist(String wishlistId) async {
    try {
      final snapshot = await firestore.collection(constantWishesReference).where("wishlist_id", isEqualTo: wishlistId).get();
      final jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) return json;
        return json..addAll({'id': e.id});
      }).toList();

      if (jsonList.isEmpty) return [];

      //Busca o usuário
      final UserModel user = await userDataSource.getById(jsonList.first['user_id']);

      List<WishModel> wishesModel = [];

      for (var json in jsonList) {
        json.addAll({
          'user': user.toJson()..addAll({'id': user.id})
        });

        if (WishModel.validateJson(json)) {
          wishesModel.add(WishModel.fromJson(json));
        }
      }

      return wishesModel;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<WishModel> create(WishModel model) async {
    try {
      final doc = firestore.collection(constantWishesReference).doc();

      if (model.image != null) {
        final String urlImage = await storageDataSource.upload("wishes/${doc.id}", File(model.image!));
        model.image = urlImage;
      }
      await doc.set(model.toJson());

      return model.clone(id: doc.id);
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<WishModel> update(WishModel model) async {
    try {
      final doc = firestore.collection(constantWishesReference).doc(model.id);

      final snapshot = await doc.get();
      final Map<String, dynamic>? jsonOld = snapshot.data()?..addAll({'id': snapshot.id});
      if (jsonOld == null) throw NotFoundInfraError();

      if (jsonOld['image'] != model.image) {
        //Se jsonOld tiver imagem salva, deve ser removida, tanto para fazer upload, como para manter um wish sem imagem.
        if (jsonOld['image'] != null) {
          await storageDataSource.delete("wishes/${model.id}");
        }
        //Se model tiver imagem setada, deve fazer upload.
        if (model.image != null) {
          final String imageUrl = await storageDataSource.upload("wishes/${model.id}", File(model.image!));
          model.image = imageUrl;
        }
      }

      await doc.update(model.toJson());

      return model;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final doc = firestore.collection(constantWishesReference).doc(id);
      await doc.delete();

      try {
        await storageDataSource.delete("wishes/$id");
      } catch (e) {
        //Não faz nada no catch, apenas um "tratamento" para não retornar exceção ao remover imagem.
      }
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
