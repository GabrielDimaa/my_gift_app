import 'package:desejando_app/layers/data/usecases/wish/get_wishes.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/mocks/wish_repository_spy.dart';

void main() {
  late GetWishesByWishlist sut;
  late WishRepositorySpy wishRepositorySpy;

  final wishlistId = faker.guid.guid();
  final List<WishEntity> wishesResult = EntityFactory.wishes();

  setUp(() {
    wishRepositorySpy = WishRepositorySpy(get: true, datas: wishesResult);
    sut = GetWishesByWishlist(wishRepository: wishRepositorySpy);
  });

  test("Deve chamar getAll com valores corretos", () async {
    await sut.get(wishlistId);
    verify(() => wishRepositorySpy.getByWishlist(wishlistId));
  });

  test("Deve chamar getAll e retornar wishes com sucesso", () async {
    final List<WishEntity> wishes = await sut.get(wishlistId);
    expect(wishes.equals(wishesResult), true);
  });

  test("Deve throw UnexpectedDomainError", () {
    wishRepositorySpy.mockGetByWishlistError();

    final Future future = sut.get(wishlistId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}