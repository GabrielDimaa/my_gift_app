import '../../../../i18n/resources.dart';
import '../../../domain/entities/wish_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wish/i_save_wish.dart';
import '../../repositories/i_wish_repository.dart';

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
