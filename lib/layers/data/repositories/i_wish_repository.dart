import '../../domain/entities/wish_entity.dart';

abstract class IWishRepository {
  Future<WishEntity> getById(String id);
  Future<List<WishEntity>> getByWishlist(String wishlistId);
  Future<WishEntity> create(WishEntity entity);
  Future<WishEntity> update(WishEntity entity);
  Future<void> delete(String id);
}