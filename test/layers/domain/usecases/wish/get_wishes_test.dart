import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/wish_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/wish/get_wishes.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/wish_repository_spy.dart';

void main() {
  late GetWishes sut;
  late WishRepositorySpy wishRepositorySpy;

  final wishlistId = faker.guid.guid();
  final List<WishEntity> wishesResult = EntityFactory.wishes();

  setUp(() {
    wishRepositorySpy = WishRepositorySpy(get: true, datas: wishesResult);
    sut = GetWishes(wishRepository: wishRepositorySpy);
  });

  test("Deve chamar getAll com valores corretos", () async {
    await sut.get(wishlistId);
    verify(() => wishRepositorySpy.getByWishlist(wishlistId));
  });

  test("Deve chamar getAll e retornar wishes com sucesso", () async {
    final List<WishEntity> wishes = await sut.get(wishlistId);
    expect(wishes.equals(wishesResult), true);
  });

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    wishRepositorySpy.mockGetByWishlistError(error: UnexpectedError());

    final Future future = sut.get(wishlistId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    wishRepositorySpy.mockGetByWishlistError(error: StandardError());

    final Future future = sut.get(wishlistId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    wishRepositorySpy.mockGetByWishlistError(error: Exception());

    final Future future = sut.get(wishlistId);
    expect(future, throwsA(isA<Exception>()));
  });
}