import 'package:desejando_app/layers/infra/datasources/i_tag_datasource.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseTagDataSourceSpy extends Mock implements ITagDataSource {
  FirebaseTagDataSourceSpy({List<TagModel>? datas, bool get = false}) {
    if (get) mockGetAll(datas!);
  }

  //region getAll
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<TagModel> datas) => mockGetAllCall().thenAnswer((_) => Future.value(datas));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_message"));
//endregion
}
