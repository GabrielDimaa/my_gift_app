import '../models/tag_model.dart';

abstract class ITagDataSource {
  Future<List<TagModel>> getAll(String userId);
  Future<TagModel> create(TagModel model);
  Future<TagModel> update(TagModel model);
}
