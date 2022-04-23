import 'package:desejando_app/layers/infra/datasources/i_wishlist_datasource.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseWishlistDataSourceSpy extends Mock implements IWishlistDataSource {
  FirebaseWishlistDataSourceSpy({required WishlistModel data}) {
    mockGetById(data);
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishlistModel data) => mockGetByIdCall().thenAnswer((_) => Future.value(data));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
