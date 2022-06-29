import '../enums/theme_mode.dart';

abstract class IConfigRepository {
  Future<void> saveTheme(ThemeMode themeMode);
  Future<ThemeMode?> getTheme();
  Future<void> deleteConfigs();
}