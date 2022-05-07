import '../../../../i18n/resources.dart';
import '../../helpers/errors/domain_error.dart';
import '../../repositories/i_tag_repository.dart';
import 'i_delete_tag.dart';

class DeleteTag implements IDeleteTag {
  final ITagRepository tagRepository;

  DeleteTag({required this.tagRepository});

  @override
  Future<void> delete(String id) async {
    try {
      await tagRepository.delete(id);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.deleteError);
    }
  }
}
