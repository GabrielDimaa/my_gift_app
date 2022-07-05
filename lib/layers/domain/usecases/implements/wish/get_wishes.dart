import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/wish_entity.dart';
import '../../../repositories/i_wish_repository.dart';
import '../../abstracts/wish/i_get_wishes.dart';

class GetWishes implements IGetWishes {
  final IWishRepository wishRepository;

  GetWishes({required this.wishRepository});

  @override
  Future<List<WishEntity>> get(String wishlistId) async {
    try {
      return await wishRepository.getByWishlist(wishlistId);
    } on UnexpectedError {
      throw StandardError(R.string.getError);
    }
  }
}
