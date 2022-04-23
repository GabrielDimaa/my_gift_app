import 'package:cloud_firestore/cloud_firestore.dart';

import '../../infra/datasources/i_wishlist_datasource.dart';
import '../../infra/models/wishlist_model.dart';
import '../helpers/errors/external_error.dart';
import '../helpers/extensions/firebase_exception_extension.dart';

class FirebaseWishlistDataSource implements IWishlistDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishlistDataSource({required this.firestore});

  static const String _collectionPath = "wishlists";

  @override
  Future<WishlistModel> getById(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_collectionPath).doc(id).get();

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
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection(_collectionPath).where("userId", isEqualTo: userId).get();
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
}
