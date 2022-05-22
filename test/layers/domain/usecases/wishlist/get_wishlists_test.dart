import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/wishlist/get_wishlists.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/wishlist_repository_spy.dart';

void main() {
  late GetWishlists sut;
  late WishlistRepositorySpy wishlistRepositorySpy;

  final List<WishlistEntity> wishResult = EntityFactory.wishlists();
  final String userId = faker.guid.guid();

  setUp(() {
    wishlistRepositorySpy = WishlistRepositorySpy(datas: wishResult);
    sut = GetWishlists(wishlistRepository: wishlistRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(EntityFactory.tag()));

  test("Deve chamar getAll com valores corretos", () async {
    await sut.get(userId);
    verify(() => wishlistRepositorySpy.getAll(userId));
  });

  test("Deve chamar getAll e retornar dados com sucesso", () async {
    final List<WishlistEntity> wishlists = await sut.get(userId);
    expect(wishlists, wishResult);
  });

  test("Deve throw UnexpectedDomainError se retornar um erro qualquer", () {
    wishlistRepositorySpy.mockGetAllError();

    final Future future = sut.get(userId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}