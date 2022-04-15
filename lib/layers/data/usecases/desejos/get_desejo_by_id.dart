import '../../../domain/entities/desejo_entity.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/desejos/i_get_desejo_by_id.dart';
import '../../repositories/i_desejo_repository.dart';

class GetDesejoById implements IGetDesejoById {
  final IDesejoRepository desejoRepository;

  GetDesejoById({required this.desejoRepository});

  @override
  Future<DesejoEntity> get(String id) async {
    try {
      return await desejoRepository.getById(id);
    } on NotFoundDomainError {
      throw NotFoundDomainError;
    } on AlreadyExistsError {
      throw AlreadyExistsError;
    } catch (e) {
      throw UnexpectedDomainError;
    }
  }
}