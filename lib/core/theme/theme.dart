import 'package:enpal/core/theme/colors.dart';
import 'package:flutter/material.dart';

class EnpalTheme {
  static ThemeData get light {
    final pallete = LightPallete();
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: pallete.appBar,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),
      scaffoldBackgroundColor: pallete.background,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 17)),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedForegroundColor: Colors.white,
          selectedBackgroundColor: pallete.primary,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? pallete.primary
                : pallete.inactive),
      ),
    );
  }

  static ThemeData get dark {
    final pallete = DarkPallete();
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: pallete.appBar,
      ),
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: Colors.blue,
      ),
      scaffoldBackgroundColor: pallete.background,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 17)),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedForegroundColor: Colors.white,
          selectedBackgroundColor: pallete.primary,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? pallete.primary
                : pallete.inactive),
      ),
    );
  }
}
