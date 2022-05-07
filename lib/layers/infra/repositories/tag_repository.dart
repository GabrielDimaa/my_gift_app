import '../../domain/entities/tag_entity.dart';
import '../../domain/repositories/i_tag_repository.dart';
import '../datasources/i_tag_datasource.dart';
import '../errors/infra_error.dart';
import '../models/tag_model.dart';

class TagRepository implements ITagRepository {
  final ITagDataSource tagDataSource;

  TagRepository({required this.tagDataSource});

  @override
  Future<List<TagEntity>> getAll(userId) async {
    try {
      final List<TagModel> tagsModel = await tagDataSource.getAll(userId);
      return tagsModel.map((e) => e.toEntity()).toList();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<TagEntity> create(TagEntity entity) async {
    try {
      final TagModel tagModel = await tagDataSource.create(TagModel.fromEntity(entity));
      return tagModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<TagEntity> update(TagEntity entity) async {
    try {
      final TagModel tagModel = await tagDataSource.update(TagModel.fromEntity(entity));
      return tagModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await tagDataSource.delete(id);
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }
}
