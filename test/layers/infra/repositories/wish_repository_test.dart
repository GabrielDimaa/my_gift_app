import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:desejando_app/layers/infra/repositories/wish_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entity_factory.dart';
import '../../external/mocks/firebase_wish_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late WishRepository sut;
  late FirebaseWishDataSourceSpy wishDataSourceSpy;

  group("getById", () {
    final String wishId = faker.guid.guid();
    final WishModel wishResult = ModelFactory.wish();

    setUp(() {
      wishDataSourceSpy = FirebaseWishDataSourceSpy(data: wishResult, get: true);
      sut = WishRepository(wishDataSource: wishDataSourceSpy);
    });

    test("Deve chamar GetById no Datasource com valores corretos", () async {
      await sut.getById(wishId);

      verify(() => wishDataSourceSpy.getById(wishId));
    });

    test("Deve retornar WishEntity com sucesso", () async {
      final WishEntity wish = await sut.getById(wishId);

      expect(wish, wishResult.toEntity());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishDataSourceSpy.mockGetByIdError(error: ConnectionExternalError());
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishDataSourceSpy.mockGetByIdError(error: Exception());
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      wishDataSourceSpy.mockGetByIdError(error: NotFoundExternalError());
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("create", () {
    final WishEntity wishRequest = EntityFactory.wish(withId: false);
    final WishModel wishResult = ModelFactory.wish();

    setUp(() {
      wishDataSourceSpy = FirebaseWishDataSourceSpy(data: wishResult, save: true);
      sut = WishRepository(wishDataSource: wishDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(wishResult));

    test("Deve chamar Create com valores corretos", () async {
      await sut.create(wishRequest);

      verify(() => wishDataSourceSpy.create(WishModel.fromEntity(wishRequest)));
    });

    test("Deve chamar Create retornar WishEntity com sucesso", () async {
      final WishEntity wish = await sut.create(wishRequest);

      expect(wish, wishResult.toEntity());
      expect(wish.id != null, true);
    });

    test("Deve throw ValidationDomainError se wishlistId for null", () async {
      final Future future = sut.create(EntityFactory.wish(withWishlistId: false));

      expect(future, throwsA(isA<ValidationDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishDataSourceSpy.mockCreateError(error: ConnectionExternalError());
      final Future future = sut.create(wishRequest);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishDataSourceSpy.mockCreateError(error: Exception());
      final Future future = sut.create(wishRequest);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      wishDataSourceSpy.mockCreateError(error: NotFoundExternalError());
      final Future future = sut.create(wishRequest);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("update", () {
    final WishEntity wishRequest = EntityFactory.wish();
    final WishModel wishResult = ModelFactory.wish(id: wishRequest.id);

    setUp(() {
      wishDataSourceSpy = FirebaseWishDataSourceSpy(data: wishResult, save: true);
      sut = WishRepository(wishDataSource: wishDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(wishResult));

    test("Deve chamar Update com valores corretos", () async {
      await sut.update(wishRequest);

      verify(() => wishDataSourceSpy.update(WishModel.fromEntity(wishRequest)));
    });

    test("Deve chamar Update retornar WishEntity com sucesso", () async {
      final WishEntity wish = await sut.update(wishRequest);

      expect(wish, wishResult.toEntity());
      expect(wish.id == wishRequest.id, true);
      expect(wish.id != null, true);
    });

    test("Deve throw ValidationDomainError se wishlistId for null", () async {
      final Future future = sut.update(EntityFactory.wish(withWishlistId: false));

      expect(future, throwsA(isA<ValidationDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishDataSourceSpy.mockUpdateError(error: ConnectionExternalError());
      final Future future = sut.update(wishRequest);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishDataSourceSpy.mockUpdateError(error: Exception());
      final Future future = sut.update(wishRequest);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      wishDataSourceSpy.mockUpdateError(error: NotFoundExternalError());
      final Future future = sut.update(wishRequest);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("delete", () {
    final String wishId = faker.guid.guid();

    setUp(() {
      wishDataSourceSpy = FirebaseWishDataSourceSpy(delete: true);
      sut = WishRepository(wishDataSource: wishDataSourceSpy);
    });

    test("Deve chamar Delete com valores corretos", () async {
      await sut.delete(wishId);

      verify(() => wishDataSourceSpy.delete(wishId));
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishDataSourceSpy.mockDeleteError(error: ConnectionExternalError());
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishDataSourceSpy.mockDeleteError(error: Exception());
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      wishDataSourceSpy.mockDeleteError(error: NotFoundExternalError());
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });
}