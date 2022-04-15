import 'package:desejando_app/layers/data/usecases/desejos/get_desejo_by_id.dart';
import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/desejos/classes_spy_mock.dart';
import '../../../../mocks/desejos/mock_desejo_entity.dart';

void main() {
  late GetDesejoById sut;
  late DesejoRepositorySpy desejoRepository;

  late String idDesejo;
  late DesejoEntity desejoResult;

  When mockGetByIdCall() => when(() => desejoRepository.getById(any()));
  void mockGetById(DesejoEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({DomainError? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));

  setUp(() {
    desejoRepository = DesejoRepositorySpy();
    sut = GetDesejoById(desejoRepository: desejoRepository);

    idDesejo = faker.guid.guid();
    desejoResult = MockDesejoEntity.desejoEntity();

    mockGetById(desejoResult);
  });

  test("Deve chamar GetById no Repository com valores corretos", () async {
    await sut.get(idDesejo);

    verify(() => desejoRepository.getById(idDesejo));
  });

  test("Deve retornar o DesejoEntity com sucesso", () async {
    final DesejoEntity desejo = await sut.get(idDesejo);

    expect(desejo, desejoResult);
  });

  test("Deve throw UnexpectedError", () {
    mockGetByIdError();
    final Future future = sut.get(idDesejo);

    expect(future, throwsA(UnexpectedDomainError));
  });

  test("Deve throw AlreadyExistsError", () {
    mockGetByIdError(error: AlreadyExistsError("any_message"));
    final Future future = sut.get(idDesejo);

    expect(future, throwsA(AlreadyExistsError));
  });

  test("Deve throw NotFoundError", () {
    mockGetByIdError(error: NotFoundDomainError("any_message"));
    final Future future = sut.get(idDesejo);

    expect(future, throwsA(NotFoundDomainError));
  });
}