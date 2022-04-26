import '../../../../i18n/resources.dart';
import '../../../domain/entities/wishlist_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishlist/i_save_wishlist.dart';
import '../../repositories/i_wishlist_repository.dart';

class SaveWishlist implements ISaveWishlist {
  final IWishlistRepository wishlistRepository;

  SaveWishlist({required this.wishlistRepository});

  @override
  Future<WishlistEntity> save(WishlistEntity entity) async {
    try {
      if (entity.id == null) {
        return await wishlistRepository.create(entity);
      } else {
        return await wishlistRepository.update(entity);
      }
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.saveError);
    }
  }
}
