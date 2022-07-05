import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/wish_entity.dart';
import '../../../repositories/i_wish_repository.dart';
import '../../abstracts/wish/i_get_wish_by_id.dart';

class GetWishById implements IGetWishById {
  final IWishRepository wishRepository;

  GetWishById({required this.wishRepository});

  @override
  Future<WishEntity> get(String id) async {
    try {
      return await wishRepository.getById(id);
    } on UnexpectedError {
      throw StandardError(R.string.getError);
    }
  }
}
