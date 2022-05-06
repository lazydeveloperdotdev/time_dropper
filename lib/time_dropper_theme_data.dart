part of 'time_dropper.dart';

@immutable
class TimeDropperThemeData with Diagnosticable {
  final Brightness? brightness;
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
  });
}
