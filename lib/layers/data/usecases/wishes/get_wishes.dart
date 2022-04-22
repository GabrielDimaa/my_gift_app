import '../../../../i18n/resources.dart';
import '../../../domain/entities/wish_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishes/i_get_wishes.dart';
import '../../repositories/i_wish_repository.dart';

class GetWishes implements IGetWishes {
  final IWishRepository wishRepository;

  GetWishes({required this.wishRepository});

  @override
  Future<List<WishEntity>> get(String userId) async {
    try {
      return await wishRepository.getAll(userId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}