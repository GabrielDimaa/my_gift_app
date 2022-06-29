import 'package:flutter/material.dart' as material;

enum ThemeMode { dark, light }

extension ThemeModeParse on ThemeMode {
  static ThemeMode fromIndex(int value) {
    if (value == ThemeMode.light.index) return ThemeMode.light;

    return ThemeMode.dark;
  }

  static ThemeMode fromMaterial(material.ThemeMode theme) {
    if (theme == material.ThemeMode.light) return ThemeMode.light;

    return ThemeMode.dark;
  }

  material.ThemeMode toMaterial() {
    if (this == ThemeMode.light) return material.ThemeMode.light;

    return material.ThemeMode.dark;
  }
}
