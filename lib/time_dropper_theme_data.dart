part of 'time_dropper.dart';

/// Defines the visual properties of the [TimeDropper] widget displayed with [showTimeDropper].
/// By default, it adapts the application's theme
/// where [primaryColor] is picked from app theme's [ColorScheme.secondary],
/// [canvasColor] from [ThemeData.canvasColor],
/// [unSelectedColor] from [ThemeData.hintColor]
/// and [fontFamily] from [ThemeData.textTheme.bodyText2.fontFamily]

@immutable
class TimeDropperThemeData with Diagnosticable {
  final Brightness? brightness;
  final double? elevation;
  final Color? primaryColor;
  final Color? canvasColor;
  final Color? handleColor;
  final Color? handleDotsColor;
  final Color? innerColor;
  final Color? unSelectedColor;
  final Color? selectedColor;
  final Color? unSelectedHandColor;
  final Color? selectedHandColor;
  final Color? shadowColor;
  final String? fontFamily;

  /// Creates a theme that can be used in [showTimeDropper]
  TimeDropperThemeData({
    this.canvasColor,
    this.handleColor,
    this.handleDotsColor,
    this.innerColor,
    this.unSelectedColor,
    this.selectedColor,
    this.unSelectedHandColor,
    this.selectedHandColor,
    this.brightness,
    this.primaryColor,
    this.shadowColor,
    this.fontFamily,
    this.elevation,
  });
}
