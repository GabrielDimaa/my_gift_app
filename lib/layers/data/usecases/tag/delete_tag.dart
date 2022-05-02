import '../../../../i18n/resources.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/tag/i_delete_tag.dart';
import '../../repositories/i_tag_repository.dart';

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
