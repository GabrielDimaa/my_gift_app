import 'package:desejando_app/layers/data/repositories/i_wishlist_repository.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:mocktail/mocktail.dart';

class WishlistRepositorySpy extends Mock implements IWishlistRepository {
  WishlistRepositorySpy({WishlistEntity? data, List<WishlistEntity>? datas}) {
    if (data != null) mockGetById(data);
    if (datas != null) mockGetAll(datas);
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishlistEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getAll
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<WishlistEntity> value) => mockGetAllCall().thenAnswer((_) => Future.value(value));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}