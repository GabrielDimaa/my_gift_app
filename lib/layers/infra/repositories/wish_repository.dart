import '../../data/repositories/i_wish_repository.dart';
import '../../domain/entities/wish_entity.dart';
import '../../external/helpers/external_error.dart';
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
}