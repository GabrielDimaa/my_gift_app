import '../../data/repositories/i_wish_repository.dart';
import '../../domain/entities/wish_entity.dart';
import '../../external/helpers/errors/external_error.dart';
import '../datasources/i_wish_datasource.dart';
import '../models/wish_model.dart';

class WishRepository implements IWishRepository {
  final IWishDataSource wishDataSource;

  WishRepository({required this.wishDataSource});

  @override
  Future<WishEntity> getById(String id) async {
    try {
      final WishModel wishModel = await wishDataSource.getById(id);
      return wishModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<WishEntity> create(WishEntity entity) async {
    try {
      if (entity.id != null) throw InvalidArgumentExternalError();

      final WishModel wishModel = await wishDataSource.create(WishModel.fromEntity(entity));
      return wishModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<WishEntity> update(WishEntity entity) async {
    try {
      if (entity.id == null) throw InvalidArgumentExternalError();

      final WishModel wishModel = await wishDataSource.update(WishModel.fromEntity(entity));
      return wishModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<void> delete(String id) async {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
