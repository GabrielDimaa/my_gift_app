import 'package:desejando_app/layers/data/repositories/i_wish_repository.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:mocktail/mocktail.dart';

class WishRepositorySpy extends Mock implements IWishRepository {
  WishRepositorySpy({WishEntity? data, List<WishEntity>? datas}) {
    if (data != null) mockGetById(data);
    if (datas != null) mockGetAll(datas);
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getAll
  When mockGetAllCall() => when(() => getAll(any()));
  void mockGetAll(List<WishEntity> value) => mockGetAllCall().thenAnswer((_) => Future.value(value));
  void mockGetAllError({Exception? error}) => mockGetAllCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}