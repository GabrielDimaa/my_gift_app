import 'package:desejando_app/layers/domain/entities/wish_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/external_error.dart';
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

  late String wishId;
  late WishModel wishResult;

  setUp(() {
    wishId = faker.guid.guid();
    wishResult = ModelFactory.wish();

    wishDataSourceSpy = FirebaseWishDataSourceSpy(wishResult);
    sut = WishRepository(wishDataSource: wishDataSourceSpy);
  });

  group("getById", () {
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
}