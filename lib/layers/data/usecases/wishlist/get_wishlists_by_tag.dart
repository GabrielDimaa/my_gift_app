import '../../../../i18n/resources.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/entities/wishlist_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishlist/i_get_wishlists_by_tag.dart';
import '../../repositories/i_wishlist_repository.dart';

class GetWishlistByTag implements IGetWishlistsByTag {
  final IWishlistRepository wishlistRepository;

  GetWishlistByTag({required this.wishlistRepository});

  @override
  Future<List<WishlistEntity>> get(TagEntity tag) async {
    try {
      return await wishlistRepository.getByTag(tag);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}
