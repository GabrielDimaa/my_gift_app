import '../../entities/wishlist_entity.dart';

abstract class IGetWishlistById {
  Future<WishlistEntity> get(String id);
}