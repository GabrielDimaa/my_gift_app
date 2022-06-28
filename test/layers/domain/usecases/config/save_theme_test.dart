import 'package:desejando_app/layers/domain/enums/theme_mode.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/domain/usecases/implements/config/save_theme.dart';
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

  test("Deve throw UnexpectedDomainError", () {
    configRepositorySpy.mockSaveThemeError();

    final Future future = sut.save(themeMode);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
