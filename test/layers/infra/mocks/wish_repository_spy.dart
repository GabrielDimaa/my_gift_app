import 'package:desejando_app/layers/data/repositories/i_wish_repository.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:mocktail/mocktail.dart';

class WishRepositorySpy extends Mock implements IWishRepository {
  WishRepositorySpy(WishEntity data) {
    mockGetById(data);
  }

  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));
}