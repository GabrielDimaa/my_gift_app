import '../../domain/entities/tag_entity.dart';

abstract class ITagRepository {
  Future<List<TagEntity>> getAll(String userId);
}