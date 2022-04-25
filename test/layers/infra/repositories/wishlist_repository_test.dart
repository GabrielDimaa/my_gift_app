import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:desejando_app/layers/infra/repositories/wishlist_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entity_factory.dart';
import '../../external/mocks/firebase_wishlist_datasource_spy.dart';
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
      expect(wishlist, wishlistResult.toEntity());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishlistDataSourceSpy.mockGetByIdError(error: ConnectionExternalError());

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishlistDataSourceSpy.mockGetByIdError(error: Exception());

      final Future future = sut.getById(wishlistId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      wishlistDataSourceSpy.mockGetByIdError(error: NotFoundExternalError());

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
      expect(wishlist, wishlistsResult.map((e) => e.toEntity()).toList());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishlistDataSourceSpy.mockGetAllError(error: ConnectionExternalError());

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishlistDataSourceSpy.mockGetAllError(error: Exception());

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      wishlistDataSourceSpy.mockGetAllError(error: NotFoundExternalError());

      final Future future = sut.getAll(userId);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });

  group("create", () {
    final WishlistEntity entity = EntityFactory.wishlistWithoutId();
    final WishlistModel modelResult = ModelFactory.wishlist();

    setUp(() {
      wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy(data: modelResult);
      sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(modelResult));

    test("Deve chamar create com valores corretos", () async {
      await sut.create(entity);
      verify(() => wishlistDataSourceSpy.create(WishlistModel.fromEntity(entity)));
    });

    test("Deve criar wishlist com sucesso", () async {
      final WishlistEntity wishlist = await sut.create(entity);
      expect(wishlist, modelResult.toEntity());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishlistDataSourceSpy.mockCreateError(error: ConnectionExternalError());

      final Future future = sut.create(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishlistDataSourceSpy.mockCreateError();

      final Future future = sut.create(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw AlreadyExistsDomainError", () {
    wishlistDataSourceSpy.mockCreateError(error: AlreadyExistsExternalError());

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

    test("Deve chamar update com valores corretos", () async {
      await sut.update(entity);
      verify(() => wishlistDataSourceSpy.update(WishlistModel.fromEntity(entity)));
    });

    test("Deve update wishlist com sucesso", () async {
      final WishlistEntity wishlist = await sut.update(entity);
      expect(wishlist, modelResult.toEntity());
      expect(wishlist != entity, true);
      expect(wishlist.id, entity.id);
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishlistDataSourceSpy.mockUpdateError(error: ConnectionExternalError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishlistDataSourceSpy.mockUpdateError();

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw AlreadyExistsDomainError", () {
      wishlistDataSourceSpy.mockUpdateError(error: AlreadyExistsExternalError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<AlreadyExistsDomainError>()));
    });

    test("Deve throw NotFoundDomainError", () {
      wishlistDataSourceSpy.mockUpdateError(error: NotFoundExternalError());

      final Future future = sut.update(entity);
      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });
}