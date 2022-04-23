import '../../entities/wishlist_entity.dart';

abstract class IGetWishlists {
  Future<List<WishlistEntity>> get(String userId);
}