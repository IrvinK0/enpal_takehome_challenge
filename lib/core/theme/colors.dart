import 'package:flutter/material.dart';

/// A private utility class that provides color constants used across
/// multiple palettes. These colors include shades and specific ARGB values
/// to maintain visual consistency.
class _EnpalColors {
  static var solar = Colors.orange;
  static var house = Colors.blue;
  static var charging = Colors.green;

  static var blueShaded = Colors.blue.shade500;
  static var greyShaded = Colors.grey.shade300;
  static var blueDark = const Color.fromARGB(255, 16, 46, 75);
  static var blueDark1 = const Color.fromARGB(255, 16, 46, 60);
}

/// An abstract class that defines the structure for a color palette.
///
/// The [ColorPallete] interface standardizes color schemes by specifying
/// core colors for primary use, inactive elements, and specific components
/// such as solar, house, and charging indicators, as well as app bar and background colors.
///
/// Implementations of this class (like [LightPallete] and [DarkPallete])
/// provide different color schemes for light and dark themes.
abstract class ColorPallete {
  /// Primary color used throughout the app.
  Color get primary;

  /// Color used for inactive elements.
  Color get inactive;

  /// Color associated with solar-related elements.
  Color get solar;

  /// Color associated with house-related elements.
  Color get house;

  /// Color associated with charging-related elements.
  Color get charging;

  /// Color used for the app bar background.
  Color get appBar;

  /// Background color for the app.
  Color get background;
}

/// A color palette specifically designed for light theme modes.
///
/// [LightPallete] implements [ColorPallete] to provide a set of colors that
/// are optimized for light-themed user interfaces.
class LightPallete implements ColorPallete {
  @override
  Color get primary => _EnpalColors.blueShaded;

  @override
  Color get inactive => _EnpalColors.greyShaded;

  @override
  Color get solar => _EnpalColors.solar;

  @override
  Color get house => _EnpalColors.house;

  @override
  Color get charging => _EnpalColors.charging;

  @override
  Color get appBar => Colors.white;

  @override
  Color get background => Colors.grey.shade50;
}

/// A color palette specifically designed for dark theme modes.
///
/// [DarkPallete] implements [ColorPallete] to provide a set of colors optimized
/// for dark-themed user interfaces.
class DarkPallete implements ColorPallete {
  @override
  Color get primary => _EnpalColors.blueShaded;

  @override
  Color get inactive => _EnpalColors.greyShaded;

  @override
  Color get solar => _EnpalColors.solar;

  @override
  Color get house => _EnpalColors.house;

  @override
  Color get charging => _EnpalColors.charging;

  @override
  Color get appBar => _EnpalColors.blueDark;

  @override
  Color get background => _EnpalColors.blueDark1;
}
