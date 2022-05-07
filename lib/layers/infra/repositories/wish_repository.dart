import '../../domain/entities/wish_entity.dart';
import '../../domain/repositories/i_wish_repository.dart';
import '../datasources/i_wish_datasource.dart';
import '../errors/infra_error.dart';
import '../models/wish_model.dart';

class WishRepository implements IWishRepository {
  final IWishDataSource wishDataSource;

  WishRepository({required this.wishDataSource});

  @override
  Future<WishEntity> getById(String id) async {
    try {
      final WishModel wishModel = await wishDataSource.getById(id);
      return wishModel.toEntity();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<List<WishEntity>> getByWishlist(String wishlistId) async {
    try {
      final List<WishModel> wishesModel = await wishDataSource.getByWishlist(wishlistId);
      return wishesModel.map((e) => e.toEntity()).toList();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<WishEntity> create(WishEntity entity) async {
    try {
      final WishModel wishModel = await wishDataSource.create(WishModel.fromEntity(entity));
      return wishModel.toEntity();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<WishEntity> update(WishEntity entity) async {
    try {
      final WishModel wishModel = await wishDataSource.update(WishModel.fromEntity(entity));
      return wishModel.toEntity();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await wishDataSource.delete(id);
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }
}
