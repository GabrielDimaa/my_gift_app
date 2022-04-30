import 'package:desejando_app/layers/data/repositories/i_tag_repository.dart';
import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
import 'package:mocktail/mocktail.dart';

class TagRepositorySpy extends Mock implements ITagRepository {
  TagRepositorySpy({List<TagEntity>? datas, bool get = false}) {
    if (get) mockGetAll(datas!);
  }

  //region getAll
  When mockGetAllCall() => when(() => getAll());
  void mockGetAll(List<TagEntity> datas) => mockGetAllCall().thenAnswer((_) => Future.value(datas));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_error"));
//endregion
}