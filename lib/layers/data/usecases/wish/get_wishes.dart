import '../../../../i18n/resources.dart';
import '../../../domain/entities/wish_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wish/i_get_wishes.dart';
import '../../repositories/i_wish_repository.dart';

class GetWishesByWishlist implements IGetWishesByWishlist {
  final IWishRepository wishRepository;

  GetWishesByWishlist({required this.wishRepository});

  @override
  Future<List<WishEntity>> get(String wishlistId) async {
    try {
      return await wishRepository.getByWishlist(wishlistId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}
