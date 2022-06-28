import '../../../enums/theme_mode.dart';

abstract class ISaveTheme {
  Future<void> save(ThemeMode themeMode);
}
