import 'package:desejando_app/layers/data/usecases/wishlist/get_wishlist_by_id.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../infra/mocks/wishlist_repository_spy.dart';

void main() {
  late GetWishlistById sut;
  late WishlistRepositorySpy wishlistRepositorySpy;

  final String id = faker.guid.guid();
  final WishlistEntity wishlistResult = EntityFactory.wishlist();

  setUp(() {
    wishlistRepositorySpy = WishlistRepositorySpy(data: wishlistResult);
    sut = GetWishlistById(wishlistRepository: wishlistRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(wishlistResult));

  test("Deve chamar getById com valores corretos", () async {
    await sut.get(id);
    verify(() => wishlistRepositorySpy.getById(id));
  });

  test("Deve chamar getById e retornar um wishlist", () async {
    final WishlistEntity wishlist = await sut.get(id);
    expect(wishlist, wishlistResult);
  });

  test("Deve throw UnexpectedDomainError se retornar um erro qualquer", () {
    wishlistRepositorySpy.mockGetByIdError();

    final Future future = sut.get(id);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
