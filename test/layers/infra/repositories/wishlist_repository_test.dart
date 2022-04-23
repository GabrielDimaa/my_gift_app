import 'package:desejando_app/layers/domain/entities/wishlist_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/wishlist_model.dart';
import 'package:desejando_app/layers/infra/repositories/wishlist_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../external/mocks/firebase_wishlist_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late WishlistRepository sut;
  late FirebaseWishlistDataSourceSpy wishlistDataSourceSpy;

  final WishlistModel wishlistResult = ModelFactory.wishlist();
  final List<WishlistModel> wishlistsResult = ModelFactory.wishlists();

  setUp(() {
    wishlistDataSourceSpy = FirebaseWishlistDataSourceSpy(data: wishlistResult, datas: wishlistsResult);
    sut = WishlistRepository(wishlistDataSource: wishlistDataSourceSpy);
  });

  group("getById", () {
    final String wishlistId = faker.guid.guid();

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
    final String userId = faker.guid.guid();

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
}