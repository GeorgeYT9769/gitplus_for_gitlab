import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

class ThemeConfig with ChangeNotifier {
  static ThemeData createTheme({
    required Brightness brightness,
    ColorScheme? dynamicColorScheme,
    required Color customSeedColor,
    required bool useDynamicColor,
  }) {
    ColorScheme colorScheme;
    if (useDynamicColor) {
      if (dynamicColorScheme != null) {
        colorScheme = dynamicColorScheme.harmonized();
      } else {
        // Fallback to default seed if dynamic is requested but unavailable
        colorScheme = ColorScheme.fromSeed(
          seedColor: Colors.lightBlue,
          brightness: brightness,
        );
      }
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: customSeedColor,
        brightness: brightness,
      );
    }

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: true),
      dividerTheme: const DividerThemeData(
        space: 0,
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(foregroundColor: colorScheme.onPrimary),
      tabBarTheme: TabBarThemeData(indicatorColor: colorScheme.primary),
    );
  }

  static ThemeData lightTheme({ColorScheme? dynamicColorScheme, Color? customSeedColor, bool? useDynamicColor}) => 
      createTheme(
        brightness: Brightness.light,
        dynamicColorScheme: dynamicColorScheme,
        customSeedColor: customSeedColor ?? Colors.lightBlue,
        useDynamicColor: useDynamicColor ?? true,
      );

  static ThemeData darkTheme({ColorScheme? dynamicColorScheme, Color? customSeedColor, bool? useDynamicColor}) => 
      createTheme(
        brightness: Brightness.dark,
        dynamicColorScheme: dynamicColorScheme,
        customSeedColor: customSeedColor ?? Colors.lightBlue,
        useDynamicColor: useDynamicColor ?? true,
      );

  static void switchTheme() {}
}
