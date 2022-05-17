import '../../../../../i18n/resources.dart';
import '../../../entities/tag_entity.dart';
import '../../../entities/wishlist_entity.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_wishlist_repository.dart';
import '../../abstracts/wishlist/i_get_wishlists_by_tag.dart';

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
