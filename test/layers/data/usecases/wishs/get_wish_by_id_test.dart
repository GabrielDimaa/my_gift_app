import 'package:desejando_app/layers/data/usecases/wishs/get_wish_by_id.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entity_factory.dart';
import '../../../infra/mocks/wish_repository_spy.dart';

void main() {
  late GetWishById sut;
  late WishRepositorySpy wishRepository;

  late String wishId;
  late WishEntity wishResult;

  setUp(() {
    wishId = faker.guid.guid();
    wishResult = EntityFactory.wish();

    wishRepository = WishRepositorySpy(wishResult);
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

  test("Deve throw UnexpectedDomainError", () {
    wishRepository.mockGetByIdError();
    final Future future = sut.get(wishId);

    expect(future, throwsA(UnexpectedDomainError));
  });

  test("Deve throw NotFoundDomainError", () {
    wishRepository.mockGetByIdError(error: NotFoundDomainError());
    final Future future = sut.get(wishId);

    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}