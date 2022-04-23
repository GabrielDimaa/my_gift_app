import 'package:desejando_app/layers/infra/models/wishlist_model.dart';

import '../../data/repositories/i_wishlist_repository.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../../external/helpers/errors/external_error.dart';
import '../datasources/i_wishlist_datasource.dart';

class WishlistRepository implements IWishlistRepository {
  final IWishlistDataSource wishlistDataSource;

  WishlistRepository({required this.wishlistDataSource});

  @override
  Future<WishlistEntity> getById(String id) async {
    try {
      final WishlistModel wishlistModel = await wishlistDataSource.getById(id);
      return wishlistModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<List<WishlistEntity>> getAll(String userId) async {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}