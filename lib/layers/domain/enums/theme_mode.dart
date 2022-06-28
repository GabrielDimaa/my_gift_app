enum ThemeMode { dark, light }

extension ThemeModeParse on ThemeMode {
  static ThemeMode fromIndex(int value) {
    if (value == ThemeMode.light.index) return ThemeMode.light;

    return ThemeMode.dark;
  }
}
