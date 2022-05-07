import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/repositories/i_wishlist_repository.dart';
import 'package:mocktail/mocktail.dart';

class WishlistRepositorySpy extends Mock implements IWishlistRepository {
  WishlistRepositorySpy({WishlistEntity? data, List<WishlistEntity>? datas}) {
    if (data != null) {
      mockGetById(data);
      mockCreate(data);
      mockUpdate(data);
    }

    if (datas != null) {
      mockGetAll(datas);
      mockGetByTag(datas);
    }

    mockDelete();
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

  //region getByTag
  When mockGetByTagCall() => when(() => getByTag(any()));
  void mockGetByTag(List<WishlistEntity> value) => mockGetByTagCall().thenAnswer((_) => Future.value(value));
  void mockGetByTagError({Exception? error}) => mockGetByTagCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region create
  When mockCreateCall() => when(() => create(any()));
  void mockCreate(WishlistEntity value) => mockCreateCall().thenAnswer((_) => Future.value(value));
  void mockCreateError({Exception? error}) => mockCreateCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region update
  When mockUpdateCall() => when(() => update(any()));
  void mockUpdate(WishlistEntity value) => mockUpdateCall().thenAnswer((_) => Future.value(value));
  void mockUpdateError({Exception? error}) => mockUpdateCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region delete
  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) => Future.value());
  void mockDeleteError({Exception? error}) => mockDeleteCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}