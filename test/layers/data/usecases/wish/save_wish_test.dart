import 'package:desejando_app/layers/data/usecases/wish/save_wish.dart';
import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../infra/mocks/wish_repository_spy.dart';

void main() {
  late SaveWish sut;
  late WishRepositorySpy wishRepositorySpy;

  group("create", () {
    final WishEntity entityResult = EntityFactory.wish();
    final WishEntity entityRequest = EntityFactory.wish(withId: false);

    setUp(() {
      wishRepositorySpy = WishRepositorySpy(data: entityResult, save: true);
      sut = SaveWish(wishRepository: wishRepositorySpy);
    });

    setUpAll(() => registerFallbackValue(entityResult));

    test("Deve chamar create com valores corretos", () async {
      await sut.save(entityRequest);
      verify(() => wishRepositorySpy.create(entityRequest));
    });

    test("Deve chamar create e retornar os valores com sucesso", () async {
      final WishEntity wish = await sut.save(entityRequest);
      expect(wish, entityResult);
      expect(wish.id != null, true);
      expect(wish != entityRequest, true);
    });

    test("Deve throw se wish não tiver um wishlist vinculado", () {
      final Future future = sut.save(EntityFactory.wish(withId: false, withWishlistId: false));
      expect(future, throwsA(isA<ValidationDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishRepositorySpy.mockCreateError();

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });

  group("update", () {
    final WishEntity entityRequest = EntityFactory.wish();
    final WishEntity entityResult = EntityFactory.wish(id: entityRequest.id);

    setUp(() {
      wishRepositorySpy = WishRepositorySpy(data: entityResult, save: true);
      sut = SaveWish(wishRepository: wishRepositorySpy);
    });

    setUpAll(() => registerFallbackValue(entityResult));

    test("Deve chamar update com valores corretos", () async {
      await sut.save(entityRequest);
      verify(() => wishRepositorySpy.update(entityRequest));
    });

    test("Deve chamar update e retornar os valores com sucesso", () async {
      final WishEntity wish = await sut.save(entityRequest);
      expect(wish, entityResult);
      expect(wish.id != null, true);
      expect(wish == entityResult, true);
      expect(wish.id == entityRequest.id, true);
    });

    test("Deve throw se wish não tiver um wishlist vinculado", () {
      final Future future = sut.save(EntityFactory.wish(withId: false, withWishlistId: false));
      expect(future, throwsA(isA<ValidationDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishRepositorySpy.mockUpdateError();

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError", () {
      wishRepositorySpy.mockUpdateError(error: NotFoundDomainError());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });
}
