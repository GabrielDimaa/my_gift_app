import '../../entities/wishlist_entity.dart';

abstract class ISaveWishlists {
  Future<WishlistEntity> save(WishlistEntity entity);
}