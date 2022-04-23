import 'package:desejando_app/layers/data/repositories/i_wishlist_repository.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:mocktail/mocktail.dart';

class WishlistRepositorySpy extends Mock implements IWishlistRepository {
  WishlistRepositorySpy({required WishlistEntity data}) {
    mockGetById(data);
  }

  //region getById
  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(WishlistEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}