import '../../data/repositories/i_tag_repository.dart';
import '../../domain/entities/tag_entity.dart';
import '../../external/helpers/errors/external_error.dart';
import '../datasources/i_tag_datasource.dart';
import '../models/tag_model.dart';

class TagRepository implements ITagRepository {
  final ITagDataSource tagDataSource;

  TagRepository({required this.tagDataSource});

  @override
  Future<List<TagEntity>> getAll() async {
    try {
      final List<TagModel> tagsModel = await tagDataSource.getAll();
      return tagsModel.map((e) => e.toEntity()).toList();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }
}
