import '../../domain/entities/tag_entity.dart';

abstract class ITagRepository {
  Future<List<TagEntity>> getAll(String userId);
  Future<TagEntity> create(TagEntity entity);
  Future<TagEntity> update(TagEntity entity);
  Future<void> delete(String id);
}