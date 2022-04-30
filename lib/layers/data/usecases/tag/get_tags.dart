import '../../../../i18n/resources.dart';
import '../../../domain/entities/tag_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/tag/i_get_tags.dart';
import '../../repositories/i_tag_repository.dart';

class GetTags implements IGetTags {
  final ITagRepository tagRepository;

  GetTags({required this.tagRepository});

  @override
  Future<List<TagEntity>> get(String userId) async {
    try {
      return await tagRepository.getAll(userId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}
