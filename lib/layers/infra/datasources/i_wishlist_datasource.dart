import '../models/tag_model.dart';
import '../models/wishlist_model.dart';

abstract class IWishlistDataSource {
  Future<WishlistModel> getById(String id);
  Future<List<WishlistModel>> getAll(String userId);
  Future<List<WishlistModel>> getByTag(TagModel tag);
  Future<WishlistModel> create(WishlistModel model);
  Future<WishlistModel> update(WishlistModel model);
  Future<void> delete(String id);
}