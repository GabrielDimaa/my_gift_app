import 'package:desejando_app/layers/data/usecases/wishlist/save_wishlist.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entity_factory.dart';
import '../../../infra/mocks/wishlist_repository_spy.dart';

void main() {
  late SaveWishlist sut;
  late WishlistRepositorySpy wishlistRepositorySpy;

  group("create", () {
    final WishlistEntity entity = EntityFactory.wishlistWithoutId();
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
      expect(wishlist, wishlistResult);
      expect(wishlist.id != null, true);
    });

    test("Deve throw UnexpectedDomainError", () {
      wishlistRepositorySpy.mockCreateError();

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw AlreadyExistsDomainError", () {
      wishlistRepositorySpy.mockCreateError(error: AlreadyExistsDomainError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<AlreadyExistsDomainError>()));
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

    test("Deve throw UnexpectedDomainError", () {
      wishlistRepositorySpy.mockUpdateError();

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw AlreadyExistsDomainError", () {
      wishlistRepositorySpy.mockUpdateError(error: AlreadyExistsDomainError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<AlreadyExistsDomainError>()));
    });

    test("Deve throw NotFoundDomainError", () {
      wishlistRepositorySpy.mockUpdateError(error: NotFoundDomainError());

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });
}
