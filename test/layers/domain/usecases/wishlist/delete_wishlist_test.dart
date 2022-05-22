import 'package:desejando_app/layers/domain/usecases/implements/wishlist/delete_wishlist.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
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

  test("Deve throw UnexpectedDomainError", () {
    wishlistRepositorySpy.mockDeleteError();
    
    final Future future = sut.delete(wishlistId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    wishlistRepositorySpy.mockDeleteError(error: NotFoundDomainError());

    final Future future = sut.delete(wishlistId);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}