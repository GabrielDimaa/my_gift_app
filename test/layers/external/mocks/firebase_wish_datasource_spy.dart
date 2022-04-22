import 'package:desejando_app/layers/infra/datasources/i_wish_datasource.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseWishDataSourceSpy extends Mock implements IWishDataSource {
  FirebaseWishDataSourceSpy({WishModel? data, List<WishModel>? datas}) {
    if (data != null) mockGetById(data);
    if (datas != null) mockGetAll(datas);
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishModel data) => mockGetByIdCall().thenAnswer((_) => Future.value(data));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region getAll
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<WishModel> datas) => mockGetAllCall().thenAnswer((_) => Future.value(datas));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
