import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/wish/save_wish.dart';
import 'package:my_gift_app/layers/domain/entities/wish_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entities/entity_factory.dart';
import '../../../infra/repositories/mocks/wish_repository_spy.dart';

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
      expect(future, throwsA(isA<RequiredError>()));
    });

    test("Deve throw StandardError se ocorrer um erro inesperado", () {
      wishRepositorySpy.mockCreateError(error: UnexpectedError());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      wishRepositorySpy.mockCreateError(error: StandardError());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      wishRepositorySpy.mockCreateError(error: Exception());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<Exception>()));
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
      expect(future, throwsA(isA<RequiredError>()));
    });

    test("Deve throw StandardError se ocorrer um erro inesperado", () {
      wishRepositorySpy.mockUpdateError(error: UnexpectedError());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw StandardError", () {
      wishRepositorySpy.mockUpdateError(error: StandardError());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      wishRepositorySpy.mockUpdateError(error: Exception());

      final Future future = sut.save(entityRequest);
      expect(future, throwsA(isA<Exception>()));
    });
  });
}
