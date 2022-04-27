import 'package:desejando_app/layers/infra/datasources/i_wishlist_datasource.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseWishlistDataSourceSpy extends Mock implements IWishlistDataSource {
  FirebaseWishlistDataSourceSpy({WishlistModel? data, List<WishlistModel>? datas}) {
    if (data != null) {
      mockGetById(data);
      mockCreate(data);
      mockUpdate(data);
    }
    if (datas != null) mockGetAll(datas);
    mockDelete();
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishlistModel data) => mockGetByIdCall().thenAnswer((_) => Future.value(data));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region getById
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<WishlistModel> data) => mockGetAllCall().thenAnswer((_) => Future.value(data));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region create
  When mockCreateCall() => when(() => create(any()));
  void mockCreate(WishlistModel data) => mockCreateCall().thenAnswer((_) => Future.value(data));
  void mockCreateError({Exception? error}) => mockCreateCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region update
  When mockUpdateCall() => when(() => update(any()));
  void mockUpdate(WishlistModel data) => mockUpdateCall().thenAnswer((_) => Future.value(data));
  void mockUpdateError({Exception? error}) => mockUpdateCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region delete
  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) => Future.value());
  void mockDeleteError({Exception? error}) => mockDeleteCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
