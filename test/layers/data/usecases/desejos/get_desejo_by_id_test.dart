import 'package:desejando_app/layers/data/usecases/desejos/get_desejo_by_id.dart';
import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/entity_factory.dart';
import '../../../infra/mocks/desejo_repository_spy.dart';

void main() {
  late GetDesejoById sut;
  late DesejoRepositorySpy desejoRepository;

  late String idDesejo;
  late DesejoEntity desejoResult;

  setUp(() {
    idDesejo = faker.guid.guid();
    desejoResult = EntityFactory.desejo();

    desejoRepository = DesejoRepositorySpy(desejoResult);
    sut = GetDesejoById(desejoRepository: desejoRepository);
  });

  test("Deve chamar GetById no Repository com valores corretos", () async {
    await sut.get(idDesejo);

    verify(() => desejoRepository.getById(idDesejo));
  });

  test("Deve retornar o DesejoEntity com sucesso", () async {
    final DesejoEntity desejo = await sut.get(idDesejo);

    expect(desejo, desejoResult);
  });

  test("Deve throw UnexpectedDomainError", () {
    desejoRepository.mockGetByIdError();
    final Future future = sut.get(idDesejo);

    expect(future, throwsA(UnexpectedDomainError));
  });

  test("Deve throw NotFoundError", () {
    desejoRepository.mockGetByIdError(error: NotFoundDomainError());
    final Future future = sut.get(idDesejo);

    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}