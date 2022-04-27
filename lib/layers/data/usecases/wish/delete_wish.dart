import '../../../../i18n/resources.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/wish/i_delete_wish.dart';
import '../../repositories/i_wish_repository.dart';

class DeleteWish implements IDeleteWish {
  final IWishRepository wishRepository;

  DeleteWish({required this.wishRepository});

  @override
  Future<void> delete(String id) async {
    try {
      await wishRepository.delete(id);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.deleteError);
    }
  }
}
