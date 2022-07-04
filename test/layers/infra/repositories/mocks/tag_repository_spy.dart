import 'package:my_gift_app/layers/domain/entities/tag_entity.dart';
import 'package:my_gift_app/layers/domain/repositories/i_tag_repository.dart';
import 'package:mocktail/mocktail.dart';

class TagRepositorySpy extends Mock implements ITagRepository {
  TagRepositorySpy({TagEntity? data, List<TagEntity>? datas, bool get = false, bool save = false, bool delete = false}) {
    if (get) mockGetAll(datas!);

    if (save) {
      mockCreate(data!);
      mockUpdate(data);
    }

    if (delete) mockDelete();
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

  //region delete
  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) => Future.value());
  void mockDeleteError({Exception? error}) => mockDeleteCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
