import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/i_wishlist_repository.dart';
import '../../infra/models/wishlist_model.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../datasources/i_wishlist_datasource.dart';
import '../models/tag_model.dart';

class WishlistRepository implements IWishlistRepository {
  final IWishlistDataSource wishlistDataSource;

  WishlistRepository({required this.wishlistDataSource});

  @override
  Future<WishlistEntity> getById(String id) async {
    final WishlistModel wishlistModel = await wishlistDataSource.getById(id);
    return wishlistModel.toEntity();
  }

  @override
  Future<List<WishlistEntity>> getAll(String userId) async {
    final List<WishlistModel> wishlistsModel = await wishlistDataSource.getAll(userId);
    return wishlistsModel.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<WishlistEntity>> getByTag(TagEntity tag) async {
    final List<WishlistModel> wishlistsModels = await wishlistDataSource.getByTag(TagModel.fromEntity(tag));
    return wishlistsModels.map((e) => e.toEntity()).toList();
  }

  @override
  Future<WishlistEntity> create(WishlistEntity entity) async {
    final WishlistModel wishlistModel = await wishlistDataSource.create(WishlistModel.fromEntity(entity));
    return wishlistModel.toEntity();
  }

  @override
  Future<WishlistEntity> update(WishlistEntity entity) async {
    final WishlistModel wishlistModel = await wishlistDataSource.update(WishlistModel.fromEntity(entity));
    return wishlistModel.toEntity();
  }

  @override
  Future<void> delete(String id) async {
    await wishlistDataSource.delete(id);
  }
}