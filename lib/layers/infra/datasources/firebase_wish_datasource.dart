import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/extensions/firebase_exception_extension.dart';
import './constants/collection_reference.dart';
import '../helpers/errors/infra_error.dart';
import 'i_wish_datasource.dart';
import '../models/wish_model.dart';

class FirebaseWishDataSource implements IWishDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishDataSource({required this.firestore});

  @override
  Future<WishModel> getById(String id) async {
    try {
      final snapshot = await firestore.collection(constantWishesReference).doc(id).get();

      final Map<String, dynamic>? json = snapshot.data();
      json?.addAll({'id': snapshot.id});

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

      //Busca o usuário
      final snapshotUser = await firestore.collection(constantUsersReference).where(FieldPath.documentId, isEqualTo: jsonList.first['user_id']).get();
      final Map<String, dynamic> jsonUser = snapshotUser.docs.first.data()..addAll({'id': jsonList.first['user_id']});

      List<WishModel> wishesModel = [];

      for (var json in  jsonList) {
        json.addAll({'user': jsonUser});

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
      // TODO: implementar upload de imagens nos datasources
      // if (model.image?.isNotEmpty ?? false) {
      //   try {
      //     final path = "/wishes/${DateTime.now().millisecondsSinceEpoch}_${model.image}";
      //     final String urlImage = await storage.upload(path, File(model.image!));
      //
      //     model.image = urlImage;
      //   } catch (_) {}
      // }

      final doc = await firestore.collection(constantWishesReference).add(model.toJson());
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
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }
}
