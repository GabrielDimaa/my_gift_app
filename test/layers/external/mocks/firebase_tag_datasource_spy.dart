import 'package:desejando_app/layers/infra/datasources/i_tag_datasource.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseTagDataSourceSpy extends Mock implements ITagDataSource {
  FirebaseTagDataSourceSpy({TagModel? data, List<TagModel>? datas, bool get = false, bool save = false}) {
    if (get) mockGetAll(datas!);

    if (save) {
      mockCreate(data!);
      mockUpdate(data);
    }
  }

  //region getAll
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<TagModel> datas) => mockGetAllCall().thenAnswer((_) => Future.value(datas));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region create
  When mockCreateCall() => when(() => create(any()));
  void mockCreate(TagModel data) => mockCreateCall().thenAnswer((_) => Future.value(data));
  void mockCreateError({Exception? error}) => mockCreateCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region update
  When mockUpdateCall() => when(() => update(any()));
  void mockUpdate(TagModel data) => mockUpdateCall().thenAnswer((_) => Future.value(data));
  void mockUpdateError({Exception? error}) => mockUpdateCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
