import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/tag_entity.dart';
import '../../../repositories/i_tag_repository.dart';
import '../../abstracts/tag/i_save_tag.dart';

class SaveTag implements ISaveTag {
  final ITagRepository tagRepository;

  SaveTag({required this.tagRepository});

  @override
  Future<TagEntity> save(TagEntity entity) async {
    try {
      if (entity.name.isEmpty) throw RequiredError(R.string.nameTagEmptyError);
      if (entity.color.isEmpty) throw RequiredError(R.string.colorTagEmptyError);

      if (entity.id == null) {
        return await tagRepository.create(entity);
      } else {
        return await tagRepository.update(entity);
      }
    } on UnexpectedError {
      throw StandardError(R.string.saveError);
    }
  }
}
