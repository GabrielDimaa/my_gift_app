import 'package:desejando_app/layers/infra/datasources/i_wish_datasource.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseWishDataSourceSpy extends Mock implements IWishDataSource {
  FirebaseWishDataSourceSpy(WishModel value) {
    mockGetById(value);
  }

  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishModel value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));
}
