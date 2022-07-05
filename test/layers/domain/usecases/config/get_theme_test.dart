import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/enums/theme_mode.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/config/get_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/config_repository_spy.dart';

void main() {
  late GetTheme sut;
  late ConfigRepositorySpy configRepositorySpy;

  const ThemeMode themeMode = ThemeMode.dark;

  setUp(() {
    configRepositorySpy = ConfigRepositorySpy.getTheme(ThemeMode.dark);
    sut = GetTheme(configRepository: configRepositorySpy);
  });

  test("Deve chamar getTheme com valores corretos", () async {
    await sut.get();
    verify(() => configRepositorySpy.getTheme()).called(1);
  });

  test("Deve chamar getTheme e retornar os valores com sucesso", () async {
    final ThemeMode? theme = await sut.get();
    expect(theme!.index, themeMode.index);
  });

  test("Deve chamar getTheme e retornar null", () async {
    configRepositorySpy.mockGetTheme(null);

    final ThemeMode? theme = await sut.get();
    expect(theme, null);
  });

  test("Deve throw StandardError", () {
    configRepositorySpy.mockGetThemeError(error: UnexpectedError());

    Future future = sut.get();
    expect(future, throwsA(isA<StandardError>()));

    configRepositorySpy.mockGetThemeError(error: StandardError());

    future = sut.get();
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    configRepositorySpy.mockGetThemeError();

    final Future future = sut.get();
    expect(future, throwsA(isA<Exception>()));
  });
}
