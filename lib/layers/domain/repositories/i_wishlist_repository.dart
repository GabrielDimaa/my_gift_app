import '../../domain/entities/tag_entity.dart';
import '../../domain/entities/wishlist_entity.dart';

abstract class IWishlistRepository {
  Future<WishlistEntity> getById(String id);
  Future<List<WishlistEntity>> getAll(String userId);
  Future<List<WishlistEntity>> getByTag(TagEntity tag);
  Future<WishlistEntity> create(WishlistEntity entity);
  Future<WishlistEntity> update(WishlistEntity entity);
  Future<void> delete(String id);
}