import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/wishlist_entity.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/wishlist/save_wishlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/wishlist_repository_spy.dart';

void main() {
  late SaveWishlist sut;
  late WishlistRepositorySpy wishlistRepositorySpy;

  group("create", () {
    final WishlistEntity entity = EntityFactory.wishlist(withId: false);
    final WishlistEntity wishlistResult = EntityFactory.wishlist();

    setUp(() {
      wishlistRepositorySpy = WishlistRepositorySpy(data: wishlistResult);
      sut = SaveWishlist(wishlistRepository: wishlistRepositorySpy);
    });

    setUpAll(() => registerFallbackValue(entity));

    test("Deve chamar create com valores corretos", () async {
      await sut.save(entity);
      verify(() => wishlistRepositorySpy.create(entity));
    });

    test("Deve criar wishlist com sucesso", () async {
      final WishlistEntity wishlist = await sut.save(entity);
      expect(wishlist.equals(wishlistResult), true);
      expect(wishlist.id != null, true);
    });

    test("Deve criar todos wishes", () async {
      final WishlistEntity wishlist = await sut.save(entity);
      expect(wishlist.wishes.length, wishlistResult.wishes.length);
    });

    test("Deve throw StandardError se entity.id null", () {
      wishlistRepositorySpy.mockCreate(EntityFactory.wishlist(withId: false));

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError se ocorrer um erro inesperado", () {
      wishlistRepositorySpy.mockCreateError(error: UnexpectedError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      wishlistRepositorySpy.mockCreateError(error: StandardError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      wishlistRepositorySpy.mockCreateError(error: Exception());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<Exception>()));
    });
  });

  group("update", () {
    final WishlistEntity entity = EntityFactory.wishlist();
    final WishlistEntity wishlistResult = EntityFactory.wishlist(id: entity.id);

    setUp(() {
      wishlistRepositorySpy = WishlistRepositorySpy(data: wishlistResult);
      sut = SaveWishlist(wishlistRepository: wishlistRepositorySpy);
    });

    setUpAll(() => registerFallbackValue(entity));

    test("Deve chamar update com valores corretos", () async {
      await sut.save(entity);
      verify(() => wishlistRepositorySpy.update(entity));
    });

    test("Deve atualizar wishlist com sucesso", () async {
      final WishlistEntity wishlist = await sut.save(entity);
      expect(wishlist, wishlistResult);
      expect(wishlist != entity, true);
      expect(wishlist.id, entity.id);
    });

    test("Deve throw UnexpectedDomainError se ocorrer um erro inesperado", () {
      wishlistRepositorySpy.mockUpdateError(error: UnexpectedError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      wishlistRepositorySpy.mockUpdateError(error: StandardError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      wishlistRepositorySpy.mockUpdateError();

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<Exception>()));
    });
  });
}
