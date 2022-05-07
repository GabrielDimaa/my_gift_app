import '../../../../i18n/resources.dart';
import '../../entities/tag_entity.dart';
import '../../helpers/errors/domain_error.dart';
import '../../repositories/i_tag_repository.dart';
import 'i_get_tags.dart';

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
