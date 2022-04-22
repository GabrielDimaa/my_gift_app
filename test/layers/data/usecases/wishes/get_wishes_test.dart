import 'package:desejando_app/layers/data/usecases/wishes/get_wishes.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entity_factory.dart';
import '../../../infra/mocks/wish_repository_spy.dart';

void main() {
  late GetWishes sut;
  late WishRepositorySpy wishRepositorySpy;

  final String userId = faker.guid.guid();
  final List<WishEntity> wishesResult = EntityFactory.wishes();

  setUp(() {
    wishRepositorySpy = WishRepositorySpy(datas: wishesResult);
    sut = GetWishes(wishRepository: wishRepositorySpy);
  });

  test("Deve chamar getAll com valores corretos", () async {
    await sut.get(userId);
    verify(() => wishRepositorySpy.getAll(userId));
  });

  test("Deve chamar getAll e retornar uma lista de wishes", () async {
    final List<WishEntity> wishes = await sut.get(userId);
    expect(wishes, wishesResult);
  });

  test("Deve throw UnexpectedDomainError se retornar um erro qualquer", () {
    wishRepositorySpy.mockGetAllError();

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
