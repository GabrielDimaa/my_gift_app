import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/wishlist_entity.dart';
import '../../../repositories/i_wishlist_repository.dart';
import '../../abstracts/wishlist/i_save_wishlist.dart';

class SaveWishlist implements ISaveWishlist {
  final IWishlistRepository wishlistRepository;

  SaveWishlist({required this.wishlistRepository});

  @override
  Future<WishlistEntity> save(WishlistEntity entity) async {
    try {
      if (entity.id == null) {
        final WishlistEntity wishlistResponse = await wishlistRepository.create(entity);
        if (wishlistResponse.id == null) throw StandardError(R.string.saveError);

        return wishlistResponse;
      } else {
        return await wishlistRepository.update(entity);
      }
    } on UnexpectedError {
      throw StandardError(R.string.saveError);
    }
  }
}
