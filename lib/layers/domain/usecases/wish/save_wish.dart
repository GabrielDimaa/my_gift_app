import '../../../../i18n/resources.dart';
import '../../entities/wish_entity.dart';
import '../../helpers/errors/domain_error.dart';
import '../../repositories/i_wish_repository.dart';
import 'i_save_wish.dart';

class SaveWish implements ISaveWish {
  final IWishRepository wishRepository;

  SaveWish({required this.wishRepository});

  @override
  Future<WishEntity> save(WishEntity entity) async {
    try {
      if (entity.wishlistId == null) throw ValidationDomainError(message: R.string.wishlistUninformedError);

      if (entity.id == null) {
        return await wishRepository.create(entity);
      } else {
        return await wishRepository.update(entity);
      }
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.saveError);
    }
  }
}
