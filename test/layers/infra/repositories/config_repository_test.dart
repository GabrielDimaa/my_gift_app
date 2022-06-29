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

  group("getTheme", () {
    const ThemeMode themeMode = ThemeMode.dark;
    const int themeIndex = 0;

    setUp(() {
      dataSourceSpy = SharedPreferencesConfigDataSourceSpy.getTheme(themeMode.index);
      sut = ConfigRepository(configDataSource: dataSourceSpy);
    });

    test("Deve chamar getTheme", () async {
      await sut.getTheme();
      verify(() => dataSourceSpy.getTheme()).called(1);
    });

    test("Deve chamar getTheme e retornar os valores com sucesso", () async {
      final ThemeMode? theme = await sut.getTheme();
      expect(theme!.index, themeIndex);
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockGetThemeError(error: UnexpectedInfraError());

      final Future future = sut.getTheme();
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockGetThemeError();

      final Future future = sut.getTheme();
      expect(future, throwsA(isA()));
    });
  });

  group("deleteConfigs", () {
    setUp(() {
      dataSourceSpy = SharedPreferencesConfigDataSourceSpy.deleteConfigs();
      sut = ConfigRepository(configDataSource: dataSourceSpy);
    });

    test("Deve chamar deleteConfigs", () async {
      await sut.deleteConfigs();
      verify(() => dataSourceSpy.deleteConfigs()).called(1);
    });

    test("Deve throw UnexpectedInfraError", () {
      dataSourceSpy.mockDeleteConfigsError(error: UnexpectedInfraError());

      final Future future = sut.deleteConfigs();
      expect(future, throwsA(isA<UnexpectedInfraError>()));
    });

    test("Deve throw Exception", () {
      dataSourceSpy.mockDeleteConfigsError();

      final Future future = sut.deleteConfigs();
      expect(future, throwsA(isA()));
    });
  });
}
