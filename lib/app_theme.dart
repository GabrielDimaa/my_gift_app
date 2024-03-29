import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'routes/pages.dart';
import 'routes/routes.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> theme = ValueNotifier(ThemeMode.dark);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: theme,
      builder: (_, ThemeMode mode, __) {
        return GetMaterialApp(
          title: 'my Gift',
          debugShowCheckedModeBanner: false,
          initialRoute: splashRoute,
          themeMode: theme.value,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: _colorSchemeLight,
            scaffoldBackgroundColor: light,
            textTheme: _textThemeLight,
            fontFamily: 'Sarabun',
            textSelectionTheme: TextSelectionThemeData(cursorColor: secondary),
            elevatedButtonTheme: _elevatedButtonTheme(onSurface: primary),
            outlinedButtonTheme: _outlinedButtonTheme,
            textButtonTheme: _textButtonTheme,
            inputDecorationTheme: _inputDecorationThemeLight,
            appBarTheme: AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: dark,
              ),
            ),
            iconTheme: IconThemeData(
              color: dark,
            ),
            dialogBackgroundColor: light,
            dialogTheme: DialogTheme(
              backgroundColor: light,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              contentTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: dark),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: light,
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
            ),
            floatingActionButtonTheme: _floatingActionButtonTheme,
            sliderTheme: const SliderThemeData(rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape()),
            drawerTheme: DrawerThemeData(
              backgroundColor: light,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: _colorSchemeDark,
            scaffoldBackgroundColor: dark,
            textTheme: _textThemeDark,
            fontFamily: 'Sarabun',
            textSelectionTheme: TextSelectionThemeData(cursorColor: secondary),
            inputDecorationTheme: _inputDecorationThemeDark,
            elevatedButtonTheme: _elevatedButtonTheme(),
            outlinedButtonTheme: _outlinedButtonTheme,
            textButtonTheme: _textButtonTheme,
            iconTheme: IconThemeData(
              color: light,
            ),
            dialogBackgroundColor: dark,
            dialogTheme: DialogTheme(
              backgroundColor: dark,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              contentTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: light),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: dark,
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
            ),
            floatingActionButtonTheme: _floatingActionButtonTheme,
            sliderTheme: const SliderThemeData(rangeValueIndicatorShape: PaddleRangeSliderValueIndicatorShape()),
            drawerTheme: DrawerThemeData(
              backgroundColor: dark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 4,
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          getPages: Pages().getPages(),
        );
      },
    );
  }

  Color get primary => const Color(0xFF05299E);

  Color get primaryContainer => const Color(0xFFE1E5F3);

  Color get secondary => const Color(0xFFF8C630);

  Color get secondaryContainer => const Color(0xFFFFEBAF);

  Color get dark => const Color(0xFF191A1D);

  Color get light => const Color(0xFFFFFFFF);

  Color get error => const Color(0xFFE54B4B);

  Color get surfaceDark => const Color(0xFF303134);

  Color get surfaceLight => const Color(0xFFD6D6D6);

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
        surface: surfaceLight,
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
        surface: surfaceDark,
        onSurface: light,
      );

  TextTheme get _textThemeLight => TextTheme(
        titleLarge: TextStyle(color: dark, fontSize: 22, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: dark, fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: dark, fontSize: 34, fontWeight: FontWeight.w800),
        displaySmall: TextStyle(color: dark, fontSize: 40, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(color: dark, fontSize: 44, fontWeight: FontWeight.w700),
        displayLarge: TextStyle(color: dark, fontSize: 50, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.w500),
        labelLarge: TextStyle(color: dark, fontSize: 20, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(color: dark, fontSize: 16, fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(color: dark, fontSize: 18, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: dark, fontSize: 14, fontWeight: FontWeight.w300),
      );

  TextTheme get _textThemeDark => TextTheme(
        titleLarge: TextStyle(color: light, fontSize: 22, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: light, fontSize: 28, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: light, fontSize: 34, fontWeight: FontWeight.w800),
        displaySmall: TextStyle(color: light, fontSize: 40, fontWeight: FontWeight.w800),
        displayMedium: TextStyle(color: light, fontSize: 44, fontWeight: FontWeight.w700),
        displayLarge: TextStyle(color: light, fontSize: 50, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: light, fontSize: 18, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(color: light, fontSize: 18, fontWeight: FontWeight.w500),
        labelLarge: TextStyle(color: light, fontSize: 20, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(color: light, fontSize: 16, fontWeight: FontWeight.w400),
        bodyLarge: TextStyle(color: light, fontSize: 18, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: light, fontSize: 14, fontWeight: FontWeight.w300),
      );

  ElevatedButtonThemeData _elevatedButtonTheme({Color? onSurface}) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          backgroundColor: primary,
          disabledForegroundColor: onSurface?.withOpacity(0.38),
          disabledBackgroundColor: onSurface?.withOpacity(0.12),
          foregroundColor: light,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
      );

  OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: BorderSide(color: primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      );

  TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondary,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      );

  InputDecorationTheme get _inputDecorationThemeDark => InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          borderSide: BorderSide(color: error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: error, width: 2),
        ),
        errorStyle: TextStyle(color: error),
      );

  InputDecorationTheme get _inputDecorationThemeLight => InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w300),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: dark, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: secondary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: dark),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: error, width: 2),
        ),
        errorStyle: TextStyle(color: error),
      );

  FloatingActionButtonThemeData get _floatingActionButtonTheme => FloatingActionButtonThemeData(
        elevation: 4,
        backgroundColor: primary,
        foregroundColor: light,
      );
}
