import 'package:my_gift_app/layers/domain/usecases/implements/wishlist/get_wishlist_by_id.dart';
import 'package:my_gift_app/layers/domain/entities/wish_entity.dart';
import 'package:my_gift_app/layers/domain/entities/wishlist_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/wish_repository_spy.dart';
import '../../../infra/repositories/mocks/wishlist_repository_spy.dart';

void main() {
  late GetWishlistById sut;
  late WishlistRepositorySpy wishlistRepositorySpy;
  late WishRepositorySpy wishRepositorySpy;

  final String id = faker.guid.guid();
  final WishlistEntity wishlistResult = EntityFactory.wishlist()..wishes = [];
  final List<WishEntity> wishes = EntityFactory.wishes(id: wishlistResult.id);

  setUp(() {
    wishlistRepositorySpy = WishlistRepositorySpy(data: wishlistResult);
    wishRepositorySpy = WishRepositorySpy(datas: wishes, get: true);
    sut = GetWishlistById(wishlistRepository: wishlistRepositorySpy, wishRepository: wishRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(wishlistResult));

  test("Deve chamar getById com valores corretos", () async {
    await sut.get(id);
    verify(() => wishlistRepositorySpy.getById(id));
  });

  test("Deve chamar getById e retornar os wishes correspondentes", () async {
    wishlistResult.wishes = [];
    final WishlistEntity wishlist = await sut.get(id);

    expect(wishlist.wishes.isNotEmpty, true);
    expect(wishlist.wishes.equals(wishes), true);
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
