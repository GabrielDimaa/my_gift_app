import '../../../../i18n/resources.dart';
import '../../../domain/entities/wishlist_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishlist/i_get_wishlists.dart';
import '../../repositories/i_wishlist_repository.dart';

class GetWishlists implements IGetWishlists {
  final IWishlistRepository wishlistRepository;

  GetWishlists({required this.wishlistRepository});

  @override
  Future<List<WishlistEntity>> get(String userId) async {
    try {
      return await wishlistRepository.getAll(userId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}