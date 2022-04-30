import '../models/tag_model.dart';

abstract class ITagDataSource {
  Future<List<TagModel>> getAll(String userId);
}
