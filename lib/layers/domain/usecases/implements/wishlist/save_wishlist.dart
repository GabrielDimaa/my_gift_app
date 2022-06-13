import '../../../../../i18n/resources.dart';
import '../../../entities/wish_entity.dart';
import '../../../entities/wishlist_entity.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_wish_repository.dart';
import '../../../repositories/i_wishlist_repository.dart';
import '../../abstracts/wishlist/i_save_wishlist.dart';

class SaveWishlist implements ISaveWishlist {
  final IWishlistRepository wishlistRepository;
  final IWishRepository wishRepository;

  SaveWishlist({required this.wishlistRepository, required this.wishRepository});

  @override
  Future<WishlistEntity> save(WishlistEntity entity) async {
    try {
      if (entity.id == null) {
        final WishlistEntity wishlistResponse = await wishlistRepository.create(entity);
        if (wishlistResponse.id == null) throw ValidationDomainError(message: R.string.saveError);

        return wishlistResponse;
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
