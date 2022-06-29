import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/config/delete_configs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/config_repository_spy.dart';

void main() {
  late DeleteConfigs sut;
  late ConfigRepositorySpy configRepositorySpy;

  setUp(() {
    configRepositorySpy = ConfigRepositorySpy.deleteConfigs();
    sut = DeleteConfigs(configRepository: configRepositorySpy);
  });

  test("Deve chamar deleteConfigs", () async {
    await sut.delete();
    verify(() => configRepositorySpy.deleteConfigs()).called(1);
  });

  test("Deve throw UnexpectedDomainError", () {
    configRepositorySpy.mockDeleteConfigsError();

    final Future future = sut.delete();
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
