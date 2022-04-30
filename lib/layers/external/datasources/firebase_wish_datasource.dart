import 'package:cloud_firestore/cloud_firestore.dart';

import '../../external/constants/collection_reference.dart';
import '../../infra/datasources/i_wish_datasource.dart';
import '../../infra/models/wish_model.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';

class FirebaseWishDataSource implements IWishDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishDataSource({required this.firestore});

  @override
  Future<WishModel> getById(String id) async {
    try {
      final snapshot = await firestore.collection(constantWishesReference).doc(id).get();

      final Map<String, dynamic>? json = snapshot.data();
      json?.addAll({'id': snapshot.id});

      if (!WishModel.validateJson(json)) throw NotFoundExternalError();

      return WishModel.fromJson(json!);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<List<WishModel>> getByWishlist(String wishlistId) async {
    try {
      final snapshot = await firestore.collection(constantWishesReference).where("wishlist_id", isEqualTo: wishlistId).get();
      final jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) {
          return json;
        }
        return json..addAll({'id': e.id});
      }).toList();

      List<WishModel> wishesModel = [];

      for (var json in jsonList) {
        if (WishModel.validateJson(json)) {
          wishesModel.add(WishModel.fromJson(json));
        }
      }

      return wishesModel;
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<WishModel> create(WishModel model) async {
    try {
      final Map<String, dynamic> json = model.toJson();

      final doc = await firestore.collection(constantWishesReference).add(json);
      json.addAll({'id': doc.id});

      if (!WishModel.validateJson(json)) throw UnexpectedExternalError();

      return WishModel.fromJson(json);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<WishModel> update(WishModel model) async {
    try {
      final doc = firestore.collection(constantWishesReference).doc(model.id);
      await doc.update(model.toJson());

      return model;
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final doc = firestore.collection(constantWishesReference).doc(id);
      await doc.delete();
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }
}
