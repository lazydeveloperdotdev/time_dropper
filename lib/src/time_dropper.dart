part of '../time_dropper.dart';

class TimeDropper extends StatefulWidget {
  final GlobalKey? containerKey;
  final void Function(TimeOfDay time) close;
  final TimeDropperThemeData? themeData;
  final Color? barrierColor;
  final TimeOfDay? initialTime;
  final TimeDropperStyle style;
  final void Function(TimeOfDay time)? onTimeChanged;

  const TimeDropper({
    Key? key,
    this.containerKey,
    required this.close,
    required this.onTimeChanged,
    this.themeData,
    this.barrierColor,
    this.initialTime,
    this.style = TimeDropperStyle.outerFilled,
  }) : super(key: key);

  @override
  State<TimeDropper> createState() => _TimeDropperState();
}

class _TimeDropperState extends State<TimeDropper> with SingleTickerProviderStateMixin {
  double hourAngle = 0;
  double minuteAngle = 0;
  late double radius = 125;
  bool _panStarted = false;

  _initValue() {
    var now = DateTime.now();

    var time = widget.initialTime ?? TimeOfDay(hour: now.hour, minute: now.minute);

    var hours = <double>[];
    var mins = <double>[];
    for (int i = 0; i < 12; i++) {
      var v = 90.0 - (i * 30.0);
      if (v < 0) {
        v = 360.0 - ((i - 15) * 30.0);
      }
      hours.add(v);
    }
    for (int i = 0; i < 60; i++) {
      var v = 90.0 - (i * 6.0);
      if (v < 0) {
        v = 360.0 - ((i - 15) * 6.0);
      }
      mins.add(v);
    }

    hourAngle = hours[(time.hour % 12)];
    minuteAngle = mins[time.minute];
  }

  @override
  void initState() {
    _initValue();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _sendTime();
    });
    super.initState();
  }

  double _getDragDegree(DragUpdateDetails details) {
    double angle = 0.0;
    Offset coordinates = details.localPosition;
    var center = (radius * 2) / 2;
    Offset pureCoordinates = Offset(((coordinates.dx - center) / center), ((coordinates.dy - center) / center) * -1);
    var angleTan = (pureCoordinates.dy.abs()) / (pureCoordinates.dx.abs());

    double minValue = sqrt((pow(pureCoordinates.dx, 2) + pow(pureCoordinates.dy, 2)));

    if ((minValue > 0.6)) {
      angle = atan(angleTan) * 180 / pi;
      angle = angle.roundToDouble();
      if (pureCoordinates.dx.isNegative && !pureCoordinates.dy.isNegative) {
        angle = 90 - angle;
        angle += 90;
      }
      if (pureCoordinates.dx.isNegative && pureCoordinates.dy.isNegative) {
        angle += 180;
      }
      if (!pureCoordinates.dx.isNegative && pureCoordinates.dy.isNegative) {
        angle = 90 - angle;
        angle += 270;
      }
    }
    return angle;
  }

  void onHourPanUpdate(DragUpdateDetails details) {
    var angle = _getDragDegree(details);

    setState(() {
      _panStarted = true;
      hourAngle = clampToNearest(angle, 30);
    });
    _sendTime();
  }

  double clampToNearest(double angle, int step) {
    return ((angle ~/ step) * step).toDouble();
  }

  void onMinutePanUpdate(DragUpdateDetails details) {
    var angle = _getDragDegree(details);
    setState(() {
      _panStarted = true;
      minuteAngle = clampToNearest(angle, 6);
    });
    _sendTime();
  }

  _sendTime() {
    if (widget.onTimeChanged == null) return;
    var hour = _normalize(hourAngle, true);
    if (_isPm) hour += 12;
    widget.onTimeChanged!(TimeOfDay(hour: hour, minute: _normalize(minuteAngle)));
  }

  _onClose() {
    var hour = _normalize(hourAngle, true);
    if (_isPm) hour += 12;
    widget.close(TimeOfDay(hour: hour, minute: _normalize(minuteAngle)));
  }

  bool _updateMinute = false;
  bool _isPm = false;

  _normalize(double angle, [bool hour = false]) {
    var value = ((450 - angle) ~/ 6) % 60;
    if (hour) value ~/= 5;
    return value;
  }

  String _format(double angle, [bool hour = false]) {
    var value = _normalize(angle, hour);
    if (hour && value == 0) value = 12;
    if (value < 10) return "0$value";
    return "$value";
  }

  _setAmPm(bool v) {
    setState(() {
      _isPm = v;
    });
    _sendTime();
  }

  _setUpdateMinute(bool v) {
    setState(() {
      _panStarted = false;
      _updateMinute = v;
    });
  }

  Offset? get _position {
    if (widget.containerKey == null) return null;
    RenderBox? obj = widget.containerKey!.currentContext?.findRenderObject() as RenderBox?;
    return obj?.localToGlobal(Offset.zero);
  }

  Size? get _size {
    if (widget.containerKey == null) return null;
    RenderBox? obj = widget.containerKey!.currentContext?.findRenderObject() as RenderBox?;
    return obj?.size;
  }

  double get x {
    if (_position == null) return 0.0;
    return (_position!.dx - radius) + ((_size?.width ?? 2.0) / 2);
  }

  double get y {
    if (_position == null) return 0.0;
    return _position!.dy + (_size?.height ?? 0) - 5;
  }

  TimeDropperThemeData get _theme {
    var _themeData = widget.themeData;
    var theme = Theme.of(context);
    if (_themeData?.brightness == Brightness.dark && theme.brightness != Brightness.dark) {
      theme = ThemeData.dark();
    }
    if (_themeData?.brightness == Brightness.light && theme.brightness != Brightness.light) {
      theme = ThemeData.light();
    }

    var primaryColor = _themeData?.primaryColor ?? theme.colorScheme.secondary;
    var selectedColor = _themeData?.selectedColor ?? theme.colorScheme.secondary;
    var unSelectedColor = _themeData?.unSelectedHandColor ?? theme.hintColor;
    return TimeDropperThemeData(
      brightness: theme.brightness,
      primaryColor: primaryColor,
      selectedColor: selectedColor,
      unSelectedColor: unSelectedColor,
      selectedHandColor: _themeData?.selectedHandColor ?? selectedColor.withOpacity(0.5),
      unSelectedHandColor: _themeData?.unSelectedHandColor ?? unSelectedColor.withOpacity(0.5),
      innerColor: _themeData?.innerColor ?? primaryColor,
      shadowColor: _themeData?.shadowColor ?? theme.hintColor,
      handleColor: _themeData?.handleColor ?? primaryColor,
      handleDotsColor: _themeData?.handleDotsColor ?? Colors.white,
      canvasColor: _themeData?.canvasColor ?? theme.canvasColor,
      fontFamily: _themeData?.fontFamily ?? theme.textTheme.bodyText2?.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedColor = _theme.selectedColor;
    var unSelectedColor = _theme.unSelectedColor;

    CustomClipper<Path> clipper = NoClipper();
    EdgeInsets padding = const EdgeInsets.fromLTRB(15, 15, 15, 15);
    if (widget.containerKey != null) {
      clipper = TopClipper();
      padding = const EdgeInsets.fromLTRB(15, 27, 15, 15);
    }

    var size = MediaQuery.of(context).size;

    var diameter = 250.0;
    var dy = y;
    var dx = x;

    if (dx < 0) {
      dx = 20;
    }
    if ((dx + diameter) > size.width) {
      dx = size.width - diameter - 20;
    }
    if ((dy + diameter + 20) > size.height) {
      dy = dy - diameter - (_size?.height ?? 0) + 10;
      clipper = BottomClipper();
      padding = const EdgeInsets.fromLTRB(15, 15, 15, 27);
    }

    var child = PhysicalShape(
      color: Colors.transparent,
      clipper: clipper,
      shadowColor: _theme.shadowColor!,
      elevation: 10,
      child: ClipPath(
        clipper: clipper,
        child: Container(
          width: diameter,
          height: diameter,
          padding: padding,
          decoration: BoxDecoration(
            color: widget.style == TimeDropperStyle.outerFilled ? _theme.primaryColor : _theme.canvasColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _theme.shadowColor!,
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              GestureDetector(
                onPanUpdate: _updateMinute ? onMinutePanUpdate : onHourPanUpdate,
                child: TweenAnimationBuilder(
                  builder: (BuildContext context, double a1, Widget? child) {
                    return CustomPaint(
                      painter: HandlePainter(
                        color: widget.style == TimeDropperStyle.outerFilled
                            ? _theme.canvasColor!
                            : widget.style == TimeDropperStyle.innerFilled
                                ? _theme.innerColor!.withOpacity(0.3)
                                : _theme.innerColor!.withOpacity(0.5),
                        updateMinute: _updateMinute,
                        sliderColor: selectedColor!,
                        bordered: widget.style == TimeDropperStyle.bordered,
                        unSelectedColor: unSelectedColor!,
                        hourAngle: _panStarted
                            ? hourAngle
                            : _updateMinute
                                ? hourAngle
                                : a1,
                        minuteAngle: _panStarted
                            ? minuteAngle
                            : _updateMinute
                                ? a1
                                : minuteAngle,
                      ),
                    );
                  },
                  tween: Tween(
                    begin: _updateMinute ? hourAngle : minuteAngle,
                    end: _updateMinute ? minuteAngle : hourAngle,
                  ),
                  duration: const Duration(milliseconds: 300),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(primary: _updateMinute ? unSelectedColor : selectedColor),
                        onPressed: () => _setUpdateMinute(false),
                        child: Text(
                          _format(hourAngle, true),
                          textScaleFactor: 3.0,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text(
                        ":",
                        textScaleFactor: 3.0,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: unSelectedColor,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(primary: _updateMinute ? selectedColor : unSelectedColor),
                        onPressed: () => _setUpdateMinute(true),
                        child: Text(
                          _format(minuteAngle),
                          textScaleFactor: 3.0,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: selectedColor!),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 28,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: _isPm ? selectedColor : Colors.white,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(),
                              backgroundColor: _isPm ? null : selectedColor,
                            ),
                            onPressed: () => _setAmPm(false),
                            child: const Text(
                              "am",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 28,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: _isPm ? Colors.white : selectedColor,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(),
                              backgroundColor: _isPm ? selectedColor : null,
                            ),
                            onPressed: () => _setAmPm(true),
                            child: const Text(
                              "pm",
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              )
            ],
          ),
        ),
      ),
    );
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          GestureDetector(
            onTap: _onClose,
            child: Container(
              color: widget.barrierColor ?? Colors.black12,
            ),
          ),
          if (widget.containerKey == null)
            Center(child: child)
          else
            Positioned(
              left: dx,
              top: dy,
              child: child,
            ),
        ],
      ),
    );
  }
}
