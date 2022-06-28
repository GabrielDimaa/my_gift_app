import 'package:desejando_app/layers/domain/enums/theme_mode.dart';
import 'package:desejando_app/layers/infra/datasources/shared_preferences/shared_preferences_config_datasource.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/shared_preferences_spy.dart';

void main() {
  late SharedPreferencesConfigDataSource sut;
  late SharedPreferencesSpy prefsSpy;

  const String key = "theme_mode";
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
}