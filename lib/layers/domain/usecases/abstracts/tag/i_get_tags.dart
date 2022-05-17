import '../../../entities/tag_entity.dart';

abstract class IGetTags {
  Future<List<TagEntity>> get(String userId);
}