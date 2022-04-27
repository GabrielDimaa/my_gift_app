import 'package:desejando_app/layers/infra/datasources/i_wish_datasource.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseWishDataSourceSpy extends Mock implements IWishDataSource {
  FirebaseWishDataSourceSpy({required WishModel data, bool get = false, bool save = false}) {
    if (get) mockGetById(data);
    if (save) {
      mockCreate(data);
      mockUpdate(data);
    }
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishModel data) => mockGetByIdCall().thenAnswer((_) => Future.value(data));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region create
  When mockCreateCall() => when(() => create(any()));
  void mockCreate(WishModel data) => mockCreateCall().thenAnswer((_) => Future.value(data));
  void mockCreateError({Exception? error}) => mockCreateCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region update
  When mockUpdateCall() => when(() => update(any()));
  void mockUpdate(WishModel data) => mockUpdateCall().thenAnswer((_) => Future.value(data));
  void mockUpdateError({Exception? error}) => mockUpdateCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
