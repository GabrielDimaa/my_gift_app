import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/wish_model.dart';
import 'package:desejando_app/layers/infra/repositories/wish_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../external/mocks/firebase_wish_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late WishRepository sut;
  late FirebaseWishDataSourceSpy wishDataSourceSpy;

  final WishModel wishResult = ModelFactory.wish();
  final List<WishModel> wishesResult = ModelFactory.wishes();

  setUp(() {
    wishDataSourceSpy = FirebaseWishDataSourceSpy(data: wishResult, datas: wishesResult);
    sut = WishRepository(wishDataSource: wishDataSourceSpy);
  });

  group("getById", () {
    final String wishId = faker.guid.guid();

    test("Deve chamar GetById no Datasource com valores corretos", () async {
      await sut.getById(wishId);

      verify(() => wishDataSourceSpy.getById(wishId));
    });

    test("Deve retornar DesejoEntity com sucesso", () async {
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

  group("getAll", () {
    final String userId = faker.guid.guid();

    test("Deve chamar GetAll no Datasource com valores corretos", () async {
      await sut.getAll(userId);

      verify(() => wishDataSourceSpy.getAll(userId));
    });

    test("Deve retornar List<DesejoEntity> com sucesso", () async {
      final List<WishEntity> wishes = await sut.getAll(userId);

      expect(wishes, wishesResult.map((e) => e.toEntity()).toList());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      wishDataSourceSpy.mockGetAllError(error: ConnectionExternalError());
      final Future future = sut.getAll(userId);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      wishDataSourceSpy.mockGetAllError(error: Exception());
      Future future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));

      wishDataSourceSpy.mockGetAllError(error: UnexpectedDomainError("any_message"));
      future = sut.getAll(userId);
      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });
}