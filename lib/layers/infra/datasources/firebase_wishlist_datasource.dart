import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/extensions/firebase_exception_extension.dart';
import '../constants/collection_reference.dart';
import '../errors/infra_error.dart';
import 'i_wishlist_datasource.dart';
import '../models/tag_model.dart';
import '../models/wishlist_model.dart';

class FirebaseWishlistDataSource implements IWishlistDataSource {
  final FirebaseFirestore firestore;

  FirebaseWishlistDataSource({required this.firestore});

  @override
  Future<WishlistModel> getById(String id) async {
    try {
      //region wishlists

      final snapshotWishlist = await firestore.collection(constantWishlistsReference).doc(id).get();

      final Map<String, dynamic>? jsonWishlist = snapshotWishlist.data()?..addAll({'id': snapshotWishlist.id});
      if (jsonWishlist == null) throw NotFoundInfraError();

      //endregion

      //region wishes

      final List<Map<String, dynamic>?> jsonWishes = await _getWishes(jsonWishlist['id']);

      //endregion

      //region tag

      final Map<String, dynamic>? jsonTag = await _getTag(jsonWishlist['tag_id']);
      if (!TagModel.validateJson(jsonTag)) throw NotFoundInfraError();

      //endregion

      //Forma o Json completo para a WishlistModel
      jsonWishlist.addAll({
        'wishes': jsonWishes,
        'tag': jsonTag,
      });

      if (!WishlistModel.validateJson(jsonWishlist)) throw UnexpectedInfraError();

      return WishlistModel.fromJson(jsonWishlist);
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<List<WishlistModel>> getAll(String userId) async {
    try {
      //region wishlists

      final snapshotWishlist = await firestore.collection(constantWishlistsReference).where("user_id", isEqualTo: userId).get();

      final jsonListWishlist = snapshotWishlist.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) return json;
        return json..addAll({'id': e.id});
      }).toList();

      if (jsonListWishlist.isEmpty) return [];

      //endregion

      //region tags

      final List<String> tagsId = [];
      for (var json in jsonListWishlist) {
        if (!tagsId.contains(json['tag_id'])) {
          tagsId.add(json['tag_id']);
        }
      }

      final snapshotTags = await firestore.collection(constantTagsReference).where(FieldPath.documentId, whereIn: tagsId).get();

      final jsonListTags = snapshotTags.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) return json;
        return json..addAll({'id': e.id});
      }).toList();

      //endregion

      //region WishlistModel

      List<WishlistModel> wishlistsModel = [];
      for (var json in jsonListWishlist) {
        //Busca em jsonListTags a tag correspondente.
        var tag = jsonListTags.firstWhere((e) => e['id'] == json['tag_id'], orElse: () => throw UnexpectedInfraError());
        json.addAll({'tag': tag});

        if (WishlistModel.validateJson(json)) {
          wishlistsModel.add(WishlistModel.fromJson(json));
        }
      }

      return wishlistsModel;

      //endregion
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<List<WishlistModel>> getByTag(TagModel tag) async {
    try {
      final snapshot = await firestore.collection(constantWishlistsReference).where("tag_id", isEqualTo: tag.id).get();
      final jsonList = snapshot.docs.map<Map<String, dynamic>>((e) {
        var json = e.data();
        if (json.isEmpty) return json;
        return json..addAll({
            'id': e.id,
            'tag': tag.toJson()..addAll({'id': tag.id}),
          });
      }).toList();

      List<WishlistModel> wishlistsModel = [];

      for (var json in jsonList) {
        if (WishlistModel.validateJson(json)) {
          wishlistsModel.add(WishlistModel.fromJson(json));
        }
      }

      return wishlistsModel;
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  @override
  Future<WishlistModel> create(WishlistModel model) async {
    try {
      final Map<String, dynamic> json = model.toJson();
      final doc = await firestore.collection(constantWishlistsReference).add(json);

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
  Future<WishlistModel> update(WishlistModel model) async {
    try {
      final doc = firestore.collection(constantWishlistsReference).doc(model.id);
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
      final doc = firestore.collection(constantWishlistsReference).doc(id);
      await doc.delete();
    } on FirebaseException catch (e) {
      throw e.getInfraError;
    } on InfraError {
      rethrow;
    } catch (e) {
      throw UnexpectedInfraError();
    }
  }

  Future<List<Map<String, dynamic>?>> _getWishes(String wishlistId) async {
    final snapshot = await firestore.collection(constantWishesReference).where("wishlist_id", isEqualTo: wishlistId).get();

    final json = snapshot.docs.map<Map<String, dynamic>>((e) {
      var json = e.data();
      if (json.isEmpty) return json;
      return json..addAll({'id': e.id});
    }).toList();

    return json;
  }

  Future<Map<String, dynamic>?> _getTag(String tagId) async {
    final snapshot = await firestore.collection(constantTagsReference).doc(tagId).get();

    final Map<String, dynamic>? jsonTag = snapshot.data();
    return jsonTag?..addAll({'id': snapshot.id});
  }
}
