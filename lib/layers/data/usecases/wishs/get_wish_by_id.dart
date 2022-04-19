import '../../../domain/entities/wish_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wishs/i_get_wish_by_id.dart';
import '../../repositories/i_wish_repository.dart';

class GetWishById implements IGetWishById {
  final IWishRepository wishRepository;

  GetWishById({required this.wishRepository});

  @override
  Future<WishEntity> get(String id) async {
    try {
      return await wishRepository.getById(id);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError;
    }
  }
}