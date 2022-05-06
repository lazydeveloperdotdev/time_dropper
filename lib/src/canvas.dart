part of '../time_dropper.dart';

/// Extension on `num` applies on `double` and `int`
extension Ext on num {
  /// Extension to convert degrees to radians
  double toRad() {
    return pi / 180 * this;
  }
}

/// CustomPainter to draw the dial and various components on the dial
class HandlePainter extends CustomPainter {
  final Color color;
  final Color sliderColor;
  final Color unSelectedColor;
  final double hourAngle;
  final double minuteAngle;
  final bool updateMinute;
  final bool bordered;

  HandlePainter({
    required this.hourAngle,
    required this.minuteAngle,
    required this.color,
    required this.sliderColor,
    required this.unSelectedColor,
    this.updateMinute = false,
    this.bordered = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    _paintDial(canvas, size);
    _paintClockHands(canvas, size);
    _paintHandle(canvas, size);
  }

  double _getRadius(Size size) {
    return size.shortestSide / 2;
  }

  Offset _getHandOffset(double percentage, double length) {
    var offset = (percentage / 4).abs();
    final angle = (2 * pi * percentage.toRad()) + offset.toRad();
    return Offset(length * (cos(angle)), length * sin(angle));
  }

  void _paintClockHands(Canvas canvas, Size size) {
    Paint handPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.bevel
      ..strokeWidth = 5;

    double minutes = minuteAngle / 6.0;

    double hour = hourAngle / 6.0;

    canvas.drawLine(
      _getHandOffset(-hour, _getRadius(size) - 80),
      _offsetZero,
      handPaint..color = updateMinute ? unSelectedColor.withOpacity(0.5) : sliderColor.withOpacity(0.5),
    );

    canvas.drawLine(
      _getHandOffset(-minutes, _getRadius(size) - 50),
      _offsetZero,
      handPaint
        ..strokeWidth = 3
        ..color = updateMinute ? sliderColor.withOpacity(0.5) : unSelectedColor.withOpacity(0.5),
    );
  }

  _paintHandle(Canvas canvas, Size size) {
    var radius = _getRadius(size) - 20;
    var sliderPaint = Paint()
      ..color = sliderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    var indicatorPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var a = updateMinute ? minuteAngle : hourAngle;
    canvas.drawArc(
      Rect.fromCircle(center: _offsetZero, radius: radius),
      -(a + 10).toRad(), //radians
      20.toRad(), //radians
      false,
      sliderPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: _offsetZero, radius: radius),
      -(a + 6).toRad(), //radians
      0.1.toRad(), //radians
      false,
      indicatorPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: _offsetZero, radius: radius),
      -(a - 6).toRad(), //radians
      0.1.toRad(), //radians
      false,
      indicatorPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: _offsetZero, radius: radius),
      -(a).toRad(), //radians
      0.1.toRad(), //radians
      false,
      indicatorPaint..strokeWidth = 7,
    );
  }

  Offset get _offsetZero => const Offset(0, 0);

  _paintDial(Canvas canvas, Size size) {
    var dialPaint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = bordered ? PaintingStyle.stroke : PaintingStyle.fill;

    canvas.drawCircle(_offsetZero, _getRadius(size), dialPaint);
    canvas.drawCircle(
      _offsetZero,
      3,
      dialPaint
        ..style = PaintingStyle.fill
        ..color = sliderColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        0.toRad(),
        360.toRad(),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Clipper to draw pointer on the top of the dial
class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2 + 10, 12)
      ..arcTo(Rect.fromLTWH(6, 12, size.width - 12, size.height - 12), -80.toRad(), 345.toRad(), false);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Clipper to draw pointer on the bottom of the dial
class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..arcTo(Rect.fromLTWH(6, 0, size.width - 12, size.height - 12), 80.toRad(), 360.toRad(), false)
      ..lineTo(size.width / 2 + 6, size.height)
      ..lineTo(size.width / 2 - 6, size.height - 12);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
