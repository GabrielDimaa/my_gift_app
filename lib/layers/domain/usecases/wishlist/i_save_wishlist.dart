import '../../entities/wishlist_entity.dart';

abstract class ISaveWishlist {
  Future<WishlistEntity> save(WishlistEntity entity);
}