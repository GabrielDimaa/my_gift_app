import 'package:flutter/material.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desejando',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: _colorSchemeLight,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: _colorSchemeDark,
      ),
    );
  }

  Color get primary => const Color(0xFF05299E);

  Color get primaryContainer => const Color(0xFFE1E5F3);

  Color get secondary => const Color(0xFFF8C630);

  Color get secondaryContainer => const Color(0xFFFFEBAF);

  Color get dark => const Color(0xFF191A1D);

  Color get light => const Color(0xFFFFFFFF);

  Color get error => const Color(0xFFE54B4B);

  Color get surface => const Color(0xFF303134);

  ColorScheme get _colorSchemeLight => ColorScheme.dark(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: light,
        primaryContainer: primary.withAlpha(7),
        onPrimaryContainer: primary,
        secondary: secondary,
        onSecondary: light,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: secondaryContainer,
        error: error,
        onError: error,
        background: light,
        onBackground: dark,
        surface: surface,
        onSurface: light,
      );

  ColorScheme get _colorSchemeDark => ColorScheme.dark(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: light,
        primaryContainer: primary.withAlpha(7),
        onPrimaryContainer: primary,
        secondary: secondary,
        onSecondary: light,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: secondaryContainer,
        error: error,
        onError: error,
        background: dark,
        onBackground: light,
        surface: surface,
        onSurface: light,
      );
}
