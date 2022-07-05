import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../repositories/i_tag_repository.dart';
import '../../abstracts/tag/i_delete_tag.dart';

class DeleteTag implements IDeleteTag {
  final ITagRepository tagRepository;

  DeleteTag({required this.tagRepository});

  @override
  Future<void> delete(String id) async {
    try {
      await tagRepository.delete(id);
    } on UnexpectedError {
      throw StandardError(R.string.deleteError);
    }
  }
}
