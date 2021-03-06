import 'package:my_gift_app/layers/domain/enums/theme_mode.dart';
import 'package:my_gift_app/layers/infra/datasources/shared_preferences/shared_preferences_config_datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/shared_preferences_spy.dart';

void main() {
  late SharedPreferencesConfigDataSource sut;
  late SharedPreferencesSpy prefsSpy;

  const String key = "theme_mode";

  group("saveTheme", () {
    const ThemeMode themeMode = ThemeMode.dark;
    const int themeIndex = 0;

    setUp(() {
      prefsSpy = SharedPreferencesSpy.setInt(faker.randomGenerator.boolean());
      sut = SharedPreferencesConfigDataSource(sharedPreferences: prefsSpy);
    });

    test("Deve chamar setInt com valores corretos", () async {
      await sut.saveTheme(themeIndex);
      verify(() => prefsSpy.setInt(key, themeMode.index));
    });

    test("Deve throw", () async {
      prefsSpy.mockSetIntError();

      final Future future = sut.saveTheme(themeIndex);
      expect(future, throwsA(isA<Exception>()));
    });
  });

  group("getTheme", () {
    const ThemeMode themeMode = ThemeMode.dark;
    const int themeIndex = 0;

    setUp(() {
      prefsSpy = SharedPreferencesSpy.getInt(themeIndex);
      sut = SharedPreferencesConfigDataSource(sharedPreferences: prefsSpy);
    });

    test("Deve chamar getInt com valores corretos", () async {
      await sut.getTheme();
      verify(() => prefsSpy.getInt(key));
    });

    test("Deve chamar getInt e retornar valores com sucesso", () async {
      final int? theme = await sut.getTheme();
      expect(theme, themeMode.index);
    });

    test("Deve throw", () async {
      prefsSpy.mockGetIntError();

      final Future future = sut.getTheme();
      expect(future, throwsA(isA<Exception>()));
    });
  });

  group("deleteConfigs", () {
    setUp(() {
      prefsSpy = SharedPreferencesSpy.remove(faker.randomGenerator.boolean());
      sut = SharedPreferencesConfigDataSource(sharedPreferences: prefsSpy);
    });

    test("Deve chamar remove com valores corretos", () async {
      await sut.deleteConfigs();
      verify(() => prefsSpy.remove(key)).called(1);
    });

    test("Deve throw", () async {
      prefsSpy.mockRemoveError();

      final Future future = sut.deleteConfigs();
      expect(future, throwsA(isA<Exception>()));
    });
  });
}