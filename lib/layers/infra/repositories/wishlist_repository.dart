import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/i_wishlist_repository.dart';
import '../../infra/models/wishlist_model.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../datasources/i_wishlist_datasource.dart';
import '../helpers/errors/infra_error.dart';
import '../models/tag_model.dart';

class WishlistRepository implements IWishlistRepository {
  final IWishlistDataSource wishlistDataSource;

  WishlistRepository({required this.wishlistDataSource});

  @override
  Future<WishlistEntity> getById(String id) async {
    try {
      final WishlistModel wishlistModel = await wishlistDataSource.getById(id);
      return wishlistModel.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<List<WishlistEntity>> getAll(String userId) async {
    try {
      final List<WishlistModel> wishlistsModel = await wishlistDataSource.getAll(userId);
      return wishlistsModel.map((e) => e.toEntity()).toList();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<List<WishlistEntity>> getByTag(TagEntity tag) async {
    try {
      final List<WishlistModel> wishlistsModels = await wishlistDataSource.getByTag(TagModel.fromEntity(tag));
      return wishlistsModels.map((e) => e.toEntity()).toList();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<WishlistEntity> create(WishlistEntity entity) async {
    try {
      final WishlistModel wishlistModel = await wishlistDataSource.create(WishlistModel.fromEntity(entity));
      return wishlistModel.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<WishlistEntity> update(WishlistEntity entity) async {
    try {
      final WishlistModel wishlistModel = await wishlistDataSource.update(WishlistModel.fromEntity(entity));
      return wishlistModel.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await wishlistDataSource.delete(id);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }
}