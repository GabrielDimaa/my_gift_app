import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:desejando_app/layers/infra/repositories/wishlist_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../domain/entities/entity_factory.dart';
import '../datasources/mocks/firebase_wishlist_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late WishlistRepository sut;
  late FirebaseWishlistDataSourceSpy wishlistDataSourceSpy;

  group("getById", () {
    final WishlistModel wishlistResult = ModelFactory.wishlist();
    final String wishlistId = faker.guid.guid();

    setUp(() {
      wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy(data: wishlistResult);
      sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(wishlistResult));

    test("Deve chamar GetById no Datasource com valores corretos", () async {
      await sut.getById(wishlistId);
      verify(() => wishlistDataSourceSpy.getById(wishlistId));
    });

    test("Deve retornar WishlistEntity com sucesso", () async {
      final WishlistEntity wishlist = await sut.getById(wishlistId);
      expect(wishlist.equals(wishlistResult.toEntity()), true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      wishlistDataSourceSpy.mockGetByIdError(error: ConnectionInfraError());

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw Exception", () {
      wishlistDataSourceSpy.mockGetByIdError();

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedInfraError", () {
      wishlistDataSourceSpy.mockGetByIdError(error: UnexpectedInfraError());

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundInfraError", () {
      wishlistDataSourceSpy.mockGetByIdError(error: NotFoundInfraError());

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("getAll", () {
    final List<WishlistModel> wishlistsResult = ModelFactory.wishlists();
    final String userId = faker.guid.guid();

    setUp(() {
      wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy(datas: wishlistsResult);
      sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
    });

    test("Deve chamar GetAll no Datasource com valores corretos", () async {
      await sut.getAll(userId);
      verify(() => wishlistDataSourceSpy.getAll(userId));
    });

    test("Deve retornar List<WishlistEntity> com sucesso", () async {
      final List<WishlistEntity> wishlist = await sut.getAll(userId);
      expect(wishlist.equals(wishlistsResult.map((e) => e.toEntity()).toList()), true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      wishlistDataSourceSpy.mockGetAllError(error: ConnectionInfraError());

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw Exception", () {
      wishlistDataSourceSpy.mockGetAllError();

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedInfraError", () {
      wishlistDataSourceSpy.mockGetAllError(error: UnexpectedInfraError());

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundInfraError", () {
      wishlistDataSourceSpy.mockGetAllError(error: NotFoundInfraError());

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("create", () {
    final WishlistEntity entity = EntityFactory.wishlist(withId: false);
    final WishlistModel modelResult = ModelFactory.wishlist();

    setUp(() {
      wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy(data: modelResult);
      sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(modelResult));

    test("Deve criar wishlist com sucesso", () async {
      final WishlistEntity wishlist = await sut.create(entity);
      expect(wishlist.equals(modelResult.toEntity()), true);
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      wishlistDataSourceSpy.mockCreateError(error: ConnectionInfraError());

      final Future future = sut.create(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw Exception", () {
      wishlistDataSourceSpy.mockCreateError();

      final Future future = sut.create(entity);
      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedInfraError", () {
      wishlistDataSourceSpy.mockCreateError(error: UnexpectedInfraError());

      final Future future = sut.create(entity);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw AlreadyExistsDomainError", () {
    wishlistDataSourceSpy.mockCreateError(error: AlreadyExistsInfraError());

    final Future future = sut.create(entity);
    expect(future, throwsA(isA<AlreadyExistsDomainError>()));
    });
  });

  group("update", () {
    final WishlistEntity entity = EntityFactory.wishlist();
    final WishlistModel modelResult = ModelFactory.wishlist(id: entity.id);

    setUp(() {
      wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy(data: modelResult);
      sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(modelResult));

    test("Deve update wishlist com sucesso", () async {
      final WishlistEntity wishlist = await sut.update(entity);
      expect(wishlist.equals(modelResult.toEntity()), true);
      expect(wishlist != entity, true);
      expect(wishlist.id, entity.id);
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      wishlistDataSourceSpy.mockUpdateError(error: ConnectionInfraError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw Exception", () {
      wishlistDataSourceSpy.mockUpdateError();

      final Future future = sut.update(entity);
      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedInfraError", () {
      wishlistDataSourceSpy.mockUpdateError(error: UnexpectedInfraError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw AlreadyExistsDomainError", () {
      wishlistDataSourceSpy.mockUpdateError(error: AlreadyExistsInfraError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<AlreadyExistsDomainError>()));
    });

    test("Deve throw NotFoundDomainError", () {
      wishlistDataSourceSpy.mockUpdateError(error: NotFoundInfraError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("delete", () {
    final String wishlistId = faker.guid.guid();

    setUp(() {
      wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy();
      sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
    });

    test("Deve chamar Delete com valores corretos", () async {
      await sut.delete(wishlistId);
      verify(() => wishlistDataSourceSpy.delete(wishlistId));
    });

    test("Deve throw UnexpectedDomainError se ConnectionInfraError", () {
      wishlistDataSourceSpy.mockDeleteError(error: ConnectionInfraError());

      final Future future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw Exception", () {
      wishlistDataSourceSpy.mockDeleteError();

      final Future future = sut.delete(wishlistId);
      expect(future, throwsA(isA()));
    });

    test("Deve throw UnexpectedInfraError", () {
      wishlistDataSourceSpy.mockDeleteError(error: UnexpectedInfraError());

      final Future future = sut.delete(wishlistId);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw NotFoundDomainError", () {
      wishlistDataSourceSpy.mockDeleteError(error: NotFoundInfraError());

      final Future future = sut.delete(wishlistId);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });
}