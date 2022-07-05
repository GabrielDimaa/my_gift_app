import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/config/delete_configs.dart';
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
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw UnexpectedError", () {
    configRepositorySpy.mockDeleteConfigsError(error: UnexpectedError());

    final Future future = sut.delete();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    configRepositorySpy.mockDeleteConfigsError(error: StandardError());

    final Future future = sut.delete();
    expect(future, throwsA(isA<StandardError>()));
  });
}
