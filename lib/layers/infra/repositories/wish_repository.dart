import '../../domain/entities/wish_entity.dart';
import '../../domain/repositories/i_wish_repository.dart';
import '../datasources/i_wish_datasource.dart';
import '../models/wish_model.dart';

class WishRepository implements IWishRepository {
  final IWishDataSource wishDataSource;

  WishRepository({required this.wishDataSource});

  @override
  Future<WishEntity> getById(String id) async {
    final WishModel wishModel = await wishDataSource.getById(id);
    return wishModel.toEntity();
  }

  @override
  Future<List<WishEntity>> getByWishlist(String wishlistId) async {
    final List<WishModel> wishesModel = await wishDataSource.getByWishlist(wishlistId);
    return wishesModel.map((e) => e.toEntity()).toList();
  }

  @override
  Future<WishEntity> create(WishEntity entity) async {
    final WishModel wishModel = await wishDataSource.create(WishModel.fromEntity(entity));
    return wishModel.toEntity();
  }

  @override
  Future<WishEntity> update(WishEntity entity) async {
    final WishModel wishModel = await wishDataSource.update(WishModel.fromEntity(entity));
    return wishModel.toEntity();
  }

  @override
  Future<void> delete(String id) async {
    await wishDataSource.delete(id);
  }
}
