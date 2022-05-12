import 'package:desejando_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Desejando',
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: _colorSchemeLight,
        scaffoldBackgroundColor: light,
        textTheme: _textThemeLight,
        fontFamily: 'Sarabun',
        elevatedButtonTheme: _elevatedButtonTheme,
        textButtonTheme: _textButtonTheme,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: _colorSchemeDark,
        scaffoldBackgroundColor: dark,
        textTheme: _textThemeDark,
        fontFamily: 'Sarabun',
        textSelectionTheme: TextSelectionThemeData(cursorColor: secondary),
        inputDecorationTheme: _inputDecorationThemeDark,
        elevatedButtonTheme: _elevatedButtonTheme,
        textButtonTheme: _textButtonTheme,
      ),
      getPages: Routes().getRoutes(),
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

  TextTheme get _textThemeLight => TextTheme(
      headline6: TextStyle(color: dark, fontSize: 22, fontWeight: FontWeight.w600),
      headline5: TextStyle(color: dark, fontSize: 28, fontWeight: FontWeight.w700),
      headline4: TextStyle(color: dark, fontSize: 34, fontWeight: FontWeight.w800),
      subtitle2: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.w700),
      subtitle1: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.w400),
      button: TextStyle(color: dark, fontSize: 20, fontWeight: FontWeight.w700),
      bodyText2: TextStyle(color: dark, fontSize: 16, fontWeight: FontWeight.w400),
      bodyText1: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.w500),
      caption: TextStyle(color: dark, fontSize: 14, fontWeight: FontWeight.w300));

  TextTheme get _textThemeDark => TextTheme(
      headline6: TextStyle(color: light, fontSize: 22, fontWeight: FontWeight.w600),
      headline5: TextStyle(color: light, fontSize: 28, fontWeight: FontWeight.w700),
      headline4: TextStyle(color: light, fontSize: 34, fontWeight: FontWeight.w800),
      subtitle2: TextStyle(color: light, fontSize: 18, fontWeight: FontWeight.w700),
      subtitle1: TextStyle(color: light, fontSize: 18, fontWeight: FontWeight.w400),
      button: TextStyle(color: light, fontSize: 20, fontWeight: FontWeight.w700),
      bodyText2: TextStyle(color: light, fontSize: 16, fontWeight: FontWeight.w400),
      bodyText1: TextStyle(color: light, fontSize: 18, fontWeight: FontWeight.w400),
      caption: TextStyle(color: light, fontSize: 14, fontWeight: FontWeight.w300));

  ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          primary: primary,
          onPrimary: light,
          padding: const EdgeInsets.all(26),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
      );

  TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: secondary,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
      );

  InputDecorationTheme get _inputDecorationThemeDark => InputDecorationTheme(
        isDense: false,
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.all(20),
        hintStyle: const TextStyle(color: Color(0xFFC1C1C1), fontWeight: FontWeight.w300),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF464646), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: light, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF464646)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: error),
        ),
        errorStyle: TextStyle(color: error),
      );
}
