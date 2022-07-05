import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/enums/theme_mode.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/config/save_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/config_repository_spy.dart';

void main() {
  late SaveTheme sut;
  late ConfigRepositorySpy configRepositorySpy;

  const ThemeMode themeMode = ThemeMode.dark;

  setUp(() {
    configRepositorySpy = ConfigRepositorySpy.saveTheme();
    sut = SaveTheme(configRepository: configRepositorySpy);
  });

  setUpAll(() => registerFallbackValue(themeMode));

  test("Deve chamar saveTheme com valores corretos", () async {
    await sut.save(themeMode);
    verify(() => configRepositorySpy.saveTheme(themeMode));
  });

  test("Deve throw Exception", () {
    configRepositorySpy.mockSaveThemeError();

    final Future future = sut.save(themeMode);
    expect(future, throwsA(isA<Exception>()));
  });

  test("Deve throw UnexpectedDomainError", () {
    configRepositorySpy.mockSaveThemeError(error: UnexpectedError());

    Future future = sut.save(themeMode);
    expect(future, throwsA(isA<StandardError>()));

    configRepositorySpy.mockSaveThemeError(error: StandardError());

    future = sut.save(themeMode);
    expect(future, throwsA(isA<StandardError>()));
  });
}
