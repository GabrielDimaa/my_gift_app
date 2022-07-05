import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/wish_entity.dart';
import '../../../repositories/i_wish_repository.dart';
import '../../abstracts/wish/i_save_wish.dart';

class SaveWish implements ISaveWish {
  final IWishRepository wishRepository;

  SaveWish({required this.wishRepository});

  @override
  Future<WishEntity> save(WishEntity entity) async {
    try {
      if (entity.wishlistId == null) throw RequiredError(R.string.wishlistUninformedError);

      if (entity.id == null) {
        return await wishRepository.create(entity);
      } else {
        return await wishRepository.update(entity);
      }
    } on UnexpectedError {
      throw StandardError(R.string.saveError);
    }
  }
}
