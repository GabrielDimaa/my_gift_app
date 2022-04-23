import '../../../../i18n/resources.dart';
import '../../../domain/entities/wishlist_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishes/i_get_wishlist_by_id.dart';
import '../../repositories/i_wishlist_repository.dart';

class GetWishlistById implements IGetWishlistById {
  final IWishlistRepository wishlistRepository;

  GetWishlistById({required this.wishlistRepository});

  @override
  Future<WishlistEntity> get(String id) async {
    try {
      return await wishlistRepository.getById(id);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}