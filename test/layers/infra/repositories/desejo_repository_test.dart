import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/external_error.dart';
import 'package:desejando_app/layers/infra/models/desejo_model.dart';
import 'package:desejando_app/layers/infra/repositories/desejo_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../external/mocks/firebase_desejo_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late DesejoRepository sut;
  late FirebaseDesejoDataSourceSpy desejoDataSourceSpy;

  late String idDesejo;
  late DesejoModel desejoResult;

  setUp(() {
    idDesejo = faker.guid.guid();
    desejoResult = ModelFactory.desejo();

    desejoDataSourceSpy = FirebaseDesejoDataSourceSpy(desejoResult);
    sut = DesejoRepository(desejoDataSource: desejoDataSourceSpy);
  });

  group("getById", () {
    test("Deve chamar GetById no Datasource com valores corretos", () async {
      await sut.getById(idDesejo);

      verify(() => desejoDataSourceSpy.getById(idDesejo));
    });

    test("Deve retornar DesejoEntity com sucesso", () async {
      final DesejoEntity desejo = await sut.getById(idDesejo);

      expect(desejo, desejoResult.toEntity());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      desejoDataSourceSpy.mockGetByIdError(error: ConnectionExternalError());
      final Future future = sut.getById(idDesejo);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError", () {
      desejoDataSourceSpy.mockGetByIdError(error: Exception());
      final Future future = sut.getById(idDesejo);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw NotFoundDomainError se NotFoundExternalError", () {
      desejoDataSourceSpy.mockGetByIdError(error: NotFoundExternalError());
      final Future future = sut.getById(idDesejo);

      expect(future, throwsA(isA<NotFoundDomainError>()));
    });
  });
}