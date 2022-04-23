import '../../domain/entities/wishlist_entity.dart';

abstract class IWishlistRepository {
  Future<WishlistEntity> getById(String id);
}