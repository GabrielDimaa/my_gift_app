import '../../../domain/enums/theme_mode.dart';

abstract class ConfigPresenter {
  Future<void> logout();
  Future<void> saveTheme(ThemeMode themeMode);
}