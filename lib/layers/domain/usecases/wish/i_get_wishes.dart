import '../../entities/wish_entity.dart';

abstract class IGetWishesByWishlist {
  Future<List<WishEntity>> get(String wishlistId);
}