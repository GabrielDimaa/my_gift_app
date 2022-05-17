import '../../../../../i18n/resources.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_wishlist_repository.dart';
import '../../abstracts/wishlist/i_delete_wishlist.dart';

class DeleteWishlist implements IDeleteWishlist {
  final IWishlistRepository wishlistRepository;

  DeleteWishlist({required this.wishlistRepository});

  @override
  Future<void> delete(String id) async {
    try {
      await wishlistRepository.delete(id);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.deleteError);
    }
  }
}