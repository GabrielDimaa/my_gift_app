import '../../../../../i18n/resources.dart';
import '../../../entities/wish_entity.dart';
import '../../../entities/wishlist_entity.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_wish_repository.dart';
import '../../../repositories/i_wishlist_repository.dart';
import '../../abstracts/wishlist/i_get_wishlist_by_id.dart';

class GetWishlistById implements IGetWishlistById {
  final IWishlistRepository wishlistRepository;
  final IWishRepository wishRepository;

  GetWishlistById({required this.wishlistRepository, required this.wishRepository});

  @override
  Future<WishlistEntity> get(String id) async {
    try {
      final WishlistEntity wishlist = await wishlistRepository.getById(id);
      final List<WishEntity> wishes = await wishRepository.getByWishlist(id);
      wishlist.wishes.addAll(wishes);

      return wishlist;
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}