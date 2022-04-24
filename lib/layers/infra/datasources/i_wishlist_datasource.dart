import '../models/wishlist_model.dart';

abstract class IWishlistDataSource {
  Future<WishlistModel> getById(String id);
  Future<List<WishlistModel>> getAll(String userId);
  Future<WishlistModel> create(WishlistModel model);
  Future<WishlistModel> update(WishlistModel model);
}