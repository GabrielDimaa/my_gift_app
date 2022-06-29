import 'package:desejando_app/layers/domain/enums/theme_mode.dart';
import 'package:desejando_app/layers/domain/repositories/i_config_repository.dart';
import 'package:mocktail/mocktail.dart';

class ConfigRepositorySpy extends Mock implements IConfigRepository {
  ConfigRepositorySpy.saveTheme() {
    mockSaveTheme();
  }

  ConfigRepositorySpy.getTheme(ThemeMode value) {
    mockGetTheme(value);
  }

  //region addFriend
  When mockSaveThemeCall() => when(() => saveTheme(any()));
  void mockSaveTheme() => mockSaveThemeCall().thenAnswer((_) => Future.value());
  void mockSaveThemeError({Exception? error}) => mockSaveThemeCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region addFriend
  When mockGetThemeCall() => when(() => getTheme());
  void mockGetTheme(ThemeMode value) => mockGetThemeCall().thenAnswer((_) => Future.value(value));
  void mockGetThemeError({Exception? error}) => mockGetThemeCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
