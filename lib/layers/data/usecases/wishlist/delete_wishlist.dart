import '../../../../i18n/resources.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishlist/i_delete_wishlist.dart';
import '../../repositories/i_wishlist_repository.dart';

class DeleteWishlist implements IDeleteWishlist {
  final IWishlistRepository wishlistRepository;

  DeleteWishlist({required this.wishlistRepository});

  @override
  Future<void> delete(String wishlistId) async {
    try {
      await wishlistRepository.delete(wishlistId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.deleteError);
    }
  }
}