import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infra/datasources/i_wishlist_datasource.dart';
import '../../infra/models/wishlist_model.dart';
import '../constants/collection_reference.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';

class FirebaseWishlistDataSource implements IWishlistDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishlistDataSource({required this.firestore});

  @override
  Future<WishlistModel> getById(String id) async {
    try {
      final snapshot = await firestore.collection(constantWishlistsReference).doc(id).get();

      final Map<String, dynamic>? json = snapshot.data();
      json?.addAll({'id': snapshot.id});

      if (!WishlistModel.validateJson(json)) throw NotFoundExternalError();

      return WishlistModel.fromJson(json!);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<List<WishlistModel>> getAll(String userId) async {
    try {
      final snapshot = await firestore.collection(constantWishlistsReference).where("user_id", isEqualTo: userId).get();
      final jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) {
          return json;
        }
        return json..addAll({'id': e.id});
      }).toList();

      List<WishlistModel> wishlistsModel = [];

      for (var json in jsonList) {
        if (WishlistModel.validateJson(json)) {
          wishlistsModel.add(WishlistModel.fromJson(json));
        }
      }

      return wishlistsModel;
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<WishlistModel> create(WishlistModel model) async {
    try {
      final Map<String, dynamic> json = model.toJson();

      final col = firestore.collection(constantWishlistsReference);
      final doc = await col.add(json);
      json.addAll({'id': doc.id});

      if (!WishlistModel.validateJson(json)) throw UnexpectedExternalError();

      return WishlistModel.fromJson(json);
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }

  @override
  Future<WishlistModel> update(WishlistModel model) async {
    try {
      final doc = firestore.collection(constantWishlistsReference).doc(model.id);
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
      final doc = firestore.collection(constantWishlistsReference).doc(id);
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
