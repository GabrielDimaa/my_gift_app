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
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection(constantWishlistsReference).doc(id).get();

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
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(constantWishlistsReference).where("userId", isEqualTo: userId).get();
      final List<Map<String, dynamic>> jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
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
      final WriteBatch batch = firestore.batch();
      final docWishlist = firestore.collection(constantWishlistsReference).doc();

      batch.set(docWishlist, model.toJson()..remove('id'));

      Map<String, dynamic> response = model.toJson();
      response.containsKey('id') ? response['id'] = docWishlist.id : response.addAll({'id': docWishlist.id});

      List<Map<String, dynamic>> wishes = [];
      for (var wish in model.wishes) {
        final docWish = docWishlist.collection(constantWishesReference).doc();
        batch.set(docWish, wish.toJson()..remove('id'));

        Map<String, dynamic> wishJson = wish.toJson();
        wishJson.containsKey('id') ? wishJson['id'] = docWish.id : wishJson.addAll({'id': docWish.id});

        wishes.add(wishJson);
      }

      await batch.commit();

      response.addAll({'wishes': wishes});
      return WishlistModel.fromJson(response);
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
      if (model.id == null) throw NotFoundExternalError();

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
      await firestore.collection(constantWishlistsReference).doc(id).delete();
    } on FirebaseException catch (e) {
      throw e.getExternalError;
    } on ExternalError {
      rethrow;
    } catch (e) {
      throw UnexpectedExternalError();
    }
  }
}
