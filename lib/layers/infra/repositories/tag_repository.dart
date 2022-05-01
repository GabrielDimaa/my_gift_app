import '../../data/repositories/i_tag_repository.dart';
import '../../domain/entities/tag_entity.dart';
import '../../external/helpers/errors/external_error.dart';
import '../datasources/i_tag_datasource.dart';
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
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<TagEntity> update(TagEntity entity) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
