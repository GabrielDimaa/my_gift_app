import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/wish/get_wish_by_id.dart';
import 'package:my_gift_app/layers/domain/entities/wish_entity.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/wish_repository_spy.dart';

void main() {
  late GetWishById sut;
  late WishRepositorySpy wishRepository;

  late String wishId = faker.guid.guid();
  late WishEntity wishResult = EntityFactory.wish();

  setUp(() {
    wishRepository = WishRepositorySpy(data: wishResult, get: true);
    sut = GetWishById(wishRepository: wishRepository);
  });

  test("Deve chamar GetById no Repository com valores corretos", () async {
    await sut.get(wishId);
    verify(() => wishRepository.getById(wishId));
  });

  test("Deve retornar o WishEntity com sucesso", () async {
    final WishEntity wish = await sut.get(wishId);
    expect(wish, wishResult);
  });

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    wishRepository.mockGetByIdError(error: UnexpectedError());

    final Future future = sut.get(wishId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    wishRepository.mockGetByIdError(error: StandardError());

    final Future future = sut.get(wishId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    wishRepository.mockGetByIdError(error: Exception());

    final Future future = sut.get(wishId);
    expect(future, throwsA(isA<Exception>()));
  });
}