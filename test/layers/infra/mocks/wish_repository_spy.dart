import 'package:desejando_app/layers/data/repositories/i_wish_repository.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:mocktail/mocktail.dart';

class WishRepositorySpy extends Mock implements IWishRepository {
  WishRepositorySpy({WishEntity? data, List<WishEntity>? datas, bool get = false, bool save = false, bool delete = false}) {
    if (get) {
      if (data != null) mockGetById(data);
      if (datas != null) mockGetByWishlist(datas);
    }

    if (save) {
      mockCreate(data!);
      mockUpdate(data);
    }

    if (delete) mockDelete();
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getAll
  When mockGetByWishlistCall() => when(() => getByWishlist(any()));
  void mockGetByWishlist(List<WishEntity> value) => mockGetByWishlistCall().thenAnswer((_) => Future.value(value));
  void mockGetByWishlistError({Exception? error}) => mockGetByWishlistCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region create
  When mockCreateCall() => when(() => create(any()));
  void mockCreate(WishEntity value) => mockCreateCall().thenAnswer((_) => Future.value(value));
  void mockCreateError({Exception? error}) => mockCreateCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region update
  When mockUpdateCall() => when(() => update(any()));
  void mockUpdate(WishEntity value) => mockUpdateCall().thenAnswer((_) => Future.value(value));
  void mockUpdateError({Exception? error}) => mockUpdateCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region delete
  When mockDeleteCall() => when(() => delete(any()));
  void mockDelete() => mockDeleteCall().thenAnswer((_) => Future.value());
  void mockDeleteError({Exception? error}) => mockDeleteCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}