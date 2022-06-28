import '../../../enums/theme_mode.dart';

abstract class IGetTheme {
  Future<ThemeMode?> get();
}