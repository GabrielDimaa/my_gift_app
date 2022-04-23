import 'package:desejando_app/layers/infra/datasources/i_wishlist_datasource.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseWishlistDataSourceSpy extends Mock implements IWishlistDataSource {
  FirebaseWishlistDataSourceSpy({WishlistModel? data, List<WishlistModel>? datas}) {
    if (data != null) mockGetById(data);
    if (datas != null) mockGetAll(datas);
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
}
