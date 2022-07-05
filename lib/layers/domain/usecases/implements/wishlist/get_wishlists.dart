import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/wishlist_entity.dart';
import '../../../repositories/i_wishlist_repository.dart';
import '../../abstracts/wishlist/i_get_wishlists.dart';

class GetWishlists implements IGetWishlists {
  final IWishlistRepository wishlistRepository;

  GetWishlists({required this.wishlistRepository});

  @override
  Future<List<WishlistEntity>> get(String userId) async {
    try {
      return await wishlistRepository.getAll(userId);
    } on UnexpectedError {
      throw StandardError(R.string.getError);
    }
  }
}