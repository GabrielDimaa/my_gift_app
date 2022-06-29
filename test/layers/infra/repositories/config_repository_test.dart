import 'package:desejando_app/layers/domain/enums/theme_mode.dart';
import 'package:desejando_app/layers/infra/helpers/errors/infra_error.dart';
import 'package:desejando_app/layers/infra/repositories/config_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../datasources/mocks/shared_preferences_config_datasource_spy.dart';

void main() {
  late ConfigRepository sut;
  late SharedPreferencesConfigDataSourceSpy dataSourceSpy;

  group("saveTheme", () {
    const ThemeMode themeMode = ThemeMode.dark;
    const int themeIndex = 0;

    setUp(() {
      dataSourceSpy = SharedPreferencesConfigDataSourceSpy.saveTheme();
      sut = ConfigRepository(configDataSource: dataSourceSpy);
    });

    setUpAll(() => registerFallbackValue(themeMode));

    test("Deve chamar saveTheme com valores corretos", () async {
      await sut.saveTheme(themeMode);
      verify(() => dataSourceSpy.saveTheme(themeIndex));
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockSaveThemeError(error: UnexpectedInfraError());

      final Future future = sut.saveTheme(themeMode);
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockSaveThemeError();

      final Future future = sut.saveTheme(themeMode);
      expect(future, throwsA(isA()));
    });
  });
}
