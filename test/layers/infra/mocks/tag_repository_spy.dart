import 'package:desejando_app/layers/data/repositories/i_tag_repository.dart';
import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
import 'package:mocktail/mocktail.dart';

class TagRepositorySpy extends Mock implements ITagRepository {
  TagRepositorySpy({TagEntity? data, List<TagEntity>? datas, bool get = false, bool save = false}) {
    if (get) mockGetAll(datas!);

    if (save) {
      mockCreate(data!);
      mockUpdate(data);
    }
  }

  //region getAll
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<TagEntity> datas) => mockGetAllCall().thenAnswer((_) => Future.value(datas));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region create
  When mockCreateCall() => when(() => create(any()));
  void mockCreate(TagEntity datas) => mockCreateCall().thenAnswer((_) => Future.value(datas));
  void mockCreateError({Exception? error}) => mockCreateCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region update
  When mockUpdateCall() => when(() => update(any()));
  void mockUpdate(TagEntity datas) => mockUpdateCall().thenAnswer((_) => Future.value(datas));
  void mockUpdateError({Exception? error}) => mockUpdateCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
