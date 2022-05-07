import 'package:desejando_app/layers/domain/usecases/wishlist/save_wishlist.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_extension.dart';
import '../../../domain/entities/entity_factory.dart';
import '../../../infra/mocks/wish_repository_spy.dart';
import '../../../infra/mocks/wishlist_repository_spy.dart';

void main() {
  late SaveWishlist sut;
  late WishlistRepositorySpy wishlistRepositorySpy;
  late WishRepositorySpy wishRepositorySpy;

  group("create", () {
    final WishlistEntity entity = EntityFactory.wishlist(withId: false);
    final WishlistEntity wishlistResult = EntityFactory.wishlist();
    final WishEntity wishResult = EntityFactory.wish();

    setUp(() {
      wishlistRepositorySpy = WishlistRepositorySpy(data: wishlistResult);
      wishRepositorySpy = WishRepositorySpy(data: wishResult, save: true);
      sut = SaveWishlist(wishlistRepository: wishlistRepositorySpy, wishRepository: wishRepositorySpy);
    });

    setUpAll(() {
      registerFallbackValue(entity);
      registerFallbackValue(wishResult);
    });

    test("Deve chamar create com valores corretos", () async {
      await sut.save(entity);
      verifyInOrder([
        () => wishlistRepositorySpy.create(entity),
        () => wishRepositorySpy.create(entity.wishes[0]),
      ]);
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

    test("Deve salvar wishlist e repassar o id para os wishes", () async {
      await sut.save(entity);
      final capture = verify(() => wishRepositorySpy.create(captureAny())).captured;
      expect(capture.any((e) => e.wishlistId != wishlistResult.id), false);
    });

    test("Deve throw ValidationDomainError se entity.id null", () {
      wishlistRepositorySpy.mockCreate(EntityFactory.wishlist(withId: false));

      final Future future = sut.save(entity);
      expect(future, throwsA(isA<ValidationDomainError>()));
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
    final WishEntity wishResult = EntityFactory.wish();

    setUp(() {
      wishlistRepositorySpy = WishlistRepositorySpy(data: wishlistResult);
      wishRepositorySpy = WishRepositorySpy(data: wishResult);
      sut = SaveWishlist(wishlistRepository: wishlistRepositorySpy, wishRepository: wishRepositorySpy);
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
