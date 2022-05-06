library time_dropper;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'src/canvas.dart';

part 'src/time_dropper.dart';

part 'time_dropper_theme_data.dart';

/// Styles of the time dropper widget
enum TimeDropperStyle {
  /// fill outer portion with `primaryColor` and rest with `canvasColor`
  outerFilled,

  /// fill inner portion with `primaryColor` and rest with `canvasColor`
  innerFilled,

  /// add a thick border around a dial and fill rest with `canvasColor`
  bordered
}

OverlayEntry? _overlayEntry;

/// Shows a rounded dialog containing animated time picker.
/// near the container widget ([GlobalKey] of the container needs to be referenced)
///
/// ```dart
///  containerKey: _someKey
/// ```
///
/// The selected time can be listened through [onTimeChanged] callback which gives a [TimeOfDay]
///
/// {@tool snippet}
/// Pre-select the time with [initialTime]
///
/// ```dart
/// showTimeDropper(
///   context: context,
///   initialTime: TimeOfDay(hour: 20, minute: 30), 10:30pm
///   onTimeChanged: (TimeOfDay time){
///     TODO: update your UI
///   }
/// );
/// ```
/// {@end-tool}
///
/// The [context] argument is passed to
/// [showDialog], the documentation for which discusses how it is used.

/// By default, the date dropper gets its colors from the overall theme's
/// [ColorScheme] and [ThemeData.hintColor] which can be further customized by providing a
/// [TimeDropperThemeData].
void showTimeDropper({
  required BuildContext context,
  void Function(TimeOfDay time)? onTimeChanged,
  void Function(TimeOfDay time)? onDone,
  TimeOfDay? initialTime,
  GlobalKey? containerKey,
  Color? barrierColor,
  TimeDropperStyle style = TimeDropperStyle.outerFilled,
  TimeDropperThemeData? themeData,
}) async {
  _overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return TimeDropper(
        containerKey: containerKey,
        onTimeChanged: onTimeChanged,
        barrierColor: barrierColor,
        themeData: themeData,
        style: style,
        initialTime: initialTime,
        close: (TimeOfDay time) {
          if (onDone != null) onDone(time);
          _overlayEntry?.remove();
        },
      );
    },
  );
  Overlay.of(context)?.insert(_overlayEntry!);
}
