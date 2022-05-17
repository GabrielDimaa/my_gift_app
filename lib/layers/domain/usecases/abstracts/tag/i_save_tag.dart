import '../../../entities/tag_entity.dart';

abstract class ISaveTag {
  Future<TagEntity> save(TagEntity entity);
}