import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/external_error.dart';
import 'package:desejando_app/layers/infra/models/desejo_model.dart';
import 'package:desejando_app/layers/infra/repositories/desejo_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/desejos/classes_spy_mock.dart';
import '../../../mocks/desejos/mock_desejo.dart';

void main() {
  late DesejoRepository sut;
  late DesejoDataSourceSpy desejoDataSourceSpy;

  late String idDesejo;
  late DesejoModel desejoResult;

  When mockGetByIdCall() => when(() => desejoDataSourceSpy.getById(any()));
  void mockGetById(DesejoModel value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({ExternalError? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));

  setUp(() {
    desejoDataSourceSpy = DesejoDataSourceSpy();
    sut = DesejoRepository(desejoDataSource: desejoDataSourceSpy);

    idDesejo = faker.guid.guid();
    desejoResult = MockDesejo.desejoModel();

    mockGetById(desejoResult);
  });

  group("getById", () {
    test("Deve chamar GetById no Datasource com valores corretos", () async {
      await sut.getById(idDesejo);

      verify(() => desejoDataSourceSpy.getById(idDesejo));
    });

    test("Deve retornar o DesejoEntity com sucesso", () async {
      final DesejoEntity desejo = await sut.getById(idDesejo);

      expect(desejo, desejoResult.toEntity());
    });

    test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
      mockGetByIdError(error: ConnectionExternalError());
      final Future future = sut.getById(idDesejo);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });

    test("Deve throw UnexpectedDomainError se UnexpectedExternalError", () {
      mockGetByIdError();
      final Future future = sut.getById(idDesejo);

      expect(future, throwsA(isA<UnexpectedDomainError>()));
    });
  });
}