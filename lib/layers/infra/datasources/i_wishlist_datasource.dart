import '../models/wishlist_model.dart';

abstract class IWishlistDataSource {
  Future<WishlistModel> getById(String id);
  Future<List<WishlistModel>> getAll(String userId);
}