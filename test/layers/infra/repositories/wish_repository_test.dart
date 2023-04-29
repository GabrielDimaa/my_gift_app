import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/entities/wish_entity.dart';
import 'package:my_gift_app/layers/infra/models/wish_model.dart';
import 'package:my_gift_app/layers/infra/repositories/wish_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../domain/entities/entity_factory.dart';
import '../datasources/mocks/firebase_wish_datasource_spy.dart';
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

      expect(wish.equals(wishResult.toEntity()), true);
    });
    
    test("sdlfkjsld", () async {
      final WishEntity wish = await sut.getById(wishId);

      expect(wish.equals(wishResult.toEntity()), true);
    });

    test("Deve throw StandardError", () {
      wishDataSourceSpy.mockGetByIdError(error: StandardError());
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      wishDataSourceSpy.mockGetByIdError(error: UnexpectedError());
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      wishDataSourceSpy.mockGetByIdError();
      final Future future = sut.getById(wishId);

      expect(future, throwsA(isA()));
    });
  });

  group("getAll", () {
    final String wishlistId = faker.guid.guid();
    final List<WishModel> wishesResult = ModelFactory.wishes();

    setUp(() {
      wishDataSourceSpy = FirebaseWishDataSourceSpy(datas: wishesResult, get: true);
      sut = WishRepository(wishDataSource: wishDataSourceSpy);
    });

    test("Deve chamar GetAll no Datasource com valores corretos", () async {
      await sut.getByWishlist(wishlistId);
      verify(() => wishDataSourceSpy.getByWishlist(wishlistId));
    });

    test("Deve retornar List<WishEntity> com sucesso", () async {
      final List<WishEntity> wishes = await sut.getByWishlist(wishlistId);
      expect(wishes.equals(wishesResult.map((e) => e.toEntity()).toList()), true);
    });

    test("Deve throw StandardError", () {
      wishDataSourceSpy.mockGetByWishlistError(error: StandardError());
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      wishDataSourceSpy.mockGetByWishlistError(error: UnexpectedError());
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      wishDataSourceSpy.mockGetByWishlistError();
      final Future future = sut.getByWishlist(wishlistId);

      expect(future, throwsA(isA()));
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

    test("Deve chamar Create retornar WishEntity com sucesso", () async {
      final WishEntity wish = await sut.create(wishRequest);

      expect(wish.equals(wishResult.toEntity()), true);
      expect(wish.id != null, true);
    });

    test("Deve throw StandardError", () {
      wishDataSourceSpy.mockCreateError(error: StandardError());
      final Future future = sut.create(wishRequest);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw UnexpectedError", () {
      wishDataSourceSpy.mockCreateError(error: UnexpectedError());
      final Future future = sut.create(wishRequest);

      expect(future, throwsA(isA<UnexpectedError>()));
    });

    test("Deve throw Exception", () {
      wishDataSourceSpy.mockCreateError();
      final Future future = sut.create(wishRequest);

      expect(future, throwsA(isA()));
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

    test("Deve chamar Update retornar WishEntity com sucesso", () async {
      final WishEntity wish = await sut.update(wishRequest);

      expect(wish.equals(wishResult.toEntity()), true);
      expect(wish.id == wishRequest.id, true);
      expect(wish.id != null, true);
    });

    test("Deve throw StandardError", () {
      wishDataSourceSpy.mockUpdateError(error: StandardError());
      final Future future = sut.update(wishRequest);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      wishDataSourceSpy.mockUpdateError();
      final Future future = sut.update(wishRequest);

      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedError", () {
      wishDataSourceSpy.mockUpdateError(error: UnexpectedError());
      final Future future = sut.update(wishRequest);

      expect(future, throwsA(isA<UnexpectedError>()));
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

    test("Deve throw StandardError", () {
      wishDataSourceSpy.mockDeleteError(error: StandardError());
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<StandardError>()));
    });

    test("Deve throw Exception", () {
      wishDataSourceSpy.mockDeleteError(error: Exception());
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedError", () {
      wishDataSourceSpy.mockDeleteError(error: UnexpectedError());
      final Future future = sut.delete(wishId);

      expect(future, throwsA(isA<UnexpectedError>()));
    });
  });
}
