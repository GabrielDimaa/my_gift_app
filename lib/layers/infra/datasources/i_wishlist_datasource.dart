import '../models/wishlist_model.dart';

abstract class IWishlistDataSource {
  Future<WishlistModel> getById(String id);
}