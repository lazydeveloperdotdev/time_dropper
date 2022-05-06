library time_dropper;

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'src/canvas.dart';

part 'src/time_dropper.dart';

part 'time_dropper_theme_data.dart';

enum TimeDropperStyle { outerFilled, innerFilled, bordered }

OverlayEntry? _overlayEntry;

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
