import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/wishlist/delete_wishlist.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/wishlist_repository_spy.dart';

void main() {
  late DeleteWishlist sut;
  late WishlistRepositorySpy wishlistRepositorySpy;

  final String wishlistId = faker.guid.guid();

  setUp(() {
    wishlistRepositorySpy = WishlistRepositorySpy();
    sut = DeleteWishlist(wishlistRepository: wishlistRepositorySpy);
  });

  test("Deve chamar delete com valores corretos", () async {
    await sut.delete(wishlistId);
    verify(() => wishlistRepositorySpy.delete(wishlistId));
  });

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    wishlistRepositorySpy.mockDeleteError(error: UnexpectedError());
    
    final Future future = sut.delete(wishlistId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    wishlistRepositorySpy.mockDeleteError(error: StandardError());

    final Future future = sut.delete(wishlistId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    wishlistRepositorySpy.mockDeleteError(error: Exception());

    final Future future = sut.delete(wishlistId);
    expect(future, throwsA(isA<Exception>()));
  });
}