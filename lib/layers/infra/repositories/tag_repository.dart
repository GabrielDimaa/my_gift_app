import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/i_tag_repository.dart';
import '../datasources/i_tag_datasource.dart';
import '../models/tag_model.dart';

class TagRepository implements ITagRepository {
  final ITagDataSource tagDataSource;

  TagRepository({required this.tagDataSource});

  @override
  Future<List<TagEntity>> getAll(userId) async {
    final List<TagModel> tagsModel = await tagDataSource.getAll(userId);
    return tagsModel.map((e) => e.toEntity()).toList();
  }

  @override
  Future<TagEntity> create(TagEntity entity) async {
    final TagModel tagModel = await tagDataSource.create(TagModel.fromEntity(entity));
    return tagModel.toEntity();
  }

  @override
  Future<TagEntity> update(TagEntity entity) async {
    final TagModel tagModel = await tagDataSource.update(TagModel.fromEntity(entity));
    return tagModel.toEntity();
  }

  @override
  Future<void> delete(String id) async {
    await tagDataSource.delete(id);
  }
}
