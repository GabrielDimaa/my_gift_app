import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/tag_entity.dart';
import '../../../repositories/i_tag_repository.dart';
import '../../abstracts/tag/i_get_tags.dart';

class GetTags implements IGetTags {
  final ITagRepository tagRepository;

  GetTags({required this.tagRepository});

  @override
  Future<List<TagEntity>> get(String userId) async {
    try {
      return await tagRepository.getAll(userId);
    } on UnexpectedError {
      throw StandardError(R.string.getError);
    }
  }
}
