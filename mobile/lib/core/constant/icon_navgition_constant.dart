import 'dart:math' as Math;
import 'dart:ui';

import 'package:flutter/material.dart';

class EmtyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white // You can customize this color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Path path = Path()
      // Move the start point of the path
      ..moveTo(8.875, 17)
      // Draw line to the specified point
      ..lineTo(12.875, 17)
      // Custom path for the SVG
      ..moveTo(1.22621, 12.214)
      ..cubicTo(0.873212, 9.916, 0.696212, 8.768, 1.13121, 7.749)
      ..cubicTo(1.56521, 6.731, 2.52921, 6.034, 4.45621, 4.641)
      ..lineTo(5.89621, 3.6)
      ..cubicTo(8.29321, 1.867, 9.49221, 1, 10.8752, 1)
      ..cubicTo(12.2582, 1, 13.4572, 1.867, 15.8542, 3.6)
      ..lineTo(17.2942, 4.641)
      ..cubicTo(19.2212, 6.034, 20.1842, 6.731, 20.6192, 7.749)
      ..cubicTo(21.0532, 8.768, 20.8772, 9.916, 20.5242, 12.213)
      ..lineTo(20.2232, 14.173)
      ..cubicTo(19.7232, 17.429, 19.4722, 19.057, 18.3042, 20.029)
      ..cubicTo(17.1362, 21.001, 15.4292, 21, 12.0142, 21)
      ..lineTo(9.73521, 21)
      ..cubicTo(6.32021, 21, 4.61321, 21, 3.44521, 20.029)
      ..cubicTo(2.27721, 19.057, 2.02721, 17.429, 1.52621, 14.172)
      ..lineTo(1.22621, 12.214);

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class HomeIconPainter extends CustomPainter {
  final bool isActive;

  HomeIconPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isActive
          ? Colors.white
          : Colors.grey // ถ้าเลือกจะเป็นสีขาว ถ้าไม่ได้เลือกจะเป็นสีเทา
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Path path = Path()
      // Move the start point of the path
      ..moveTo(8.875, 17)
      // Draw line to the specified point
      ..lineTo(12.875, 17)
      // Custom path for the SVG
      ..moveTo(1.22621, 12.214)
      ..cubicTo(0.873212, 9.916, 0.696212, 8.768, 1.13121, 7.749)
      ..cubicTo(1.56521, 6.731, 2.52921, 6.034, 4.45621, 4.641)
      ..lineTo(5.89621, 3.6)
      ..cubicTo(8.29321, 1.867, 9.49221, 1, 10.8752, 1)
      ..cubicTo(12.2582, 1, 13.4572, 1.867, 15.8542, 3.6)
      ..lineTo(17.2942, 4.641)
      ..cubicTo(19.2212, 6.034, 20.1842, 6.731, 20.6192, 7.749)
      ..cubicTo(21.0532, 8.768, 20.8772, 9.916, 20.5242, 12.213)
      ..lineTo(20.2232, 14.173)
      ..cubicTo(19.7232, 17.429, 19.4722, 19.057, 18.3042, 20.029)
      ..cubicTo(17.1362, 21.001, 15.4292, 21, 12.0142, 21)
      ..lineTo(9.73521, 21)
      ..cubicTo(6.32021, 21, 4.61321, 21, 3.44521, 20.029)
      ..cubicTo(2.27721, 19.057, 2.02721, 17.429, 1.52621, 14.172)
      ..lineTo(1.22621, 12.214);

    // Draw the path on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ActivityIconPainter extends CustomPainter {
  final bool isActive;

  ActivityIconPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isActive
          ? Colors.white
          : Colors.grey // ถ้าเลือกจะเป็นสีขาว ถ้าไม่ได้เลือกจะเป็นสีเทา
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Path path = Path()
      // วาดเส้นแรก (วงกลม)
      ..moveTo(19.2917, 14.3333)
      ..lineTo(19.2917, 7.66667)
      ..cubicTo(19.2917, 4.52444, 19.2917, 2.95222, 18.315, 1.97667)
      ..cubicTo(17.3394, 1, 15.7672, 1, 12.625, 1)
      ..lineTo(8.18055, 1)
      ..cubicTo(5.03833, 1, 3.46611, 1, 2.49055, 1.97667)
      ..cubicTo(1.51389, 2.95222, 1.51389, 4.52444, 1.51389, 7.66667)
      ..lineTo(1.51389, 14.3333)
      ..cubicTo(1.51389, 17.4756, 1.51389, 19.0478, 2.49055, 20.0233)
      ..cubicTo(3.46611, 21, 5.03833, 21, 8.18055, 21)
      ..lineTo(21.5139, 21)
      ..moveTo(5.95833, 6.55556)
      ..lineTo(14.8472, 6.55556)
      ..moveTo(5.95833, 11)
      ..lineTo(14.8472, 11)
      ..moveTo(5.95833, 15.4444)
      ..lineTo(10.4028, 15.4444);

    // วาดเส้นที่สอง (เส้นที่ขอบขวา)
    path.moveTo(19.2917, 6.55566);
    path.lineTo(20.4028, 6.55566);
    path.cubicTo(21.9739, 6.55566, 22.7594, 6.55566, 23.2472, 7.04455);
    path.cubicTo(23.7361, 7.53233, 23.7361, 8.31789, 23.7361, 9.889);
    path.lineTo(23.7361, 18.7779);
    path.cubicTo(23.7361, 19.3673, 23.502, 19.9325, 23.0852, 20.3492);
    path.cubicTo(22.6685, 20.766, 22.1033, 21.0001, 21.5139, 21.0001);
    path.cubicTo(20.9245, 21.0001, 20.3593, 20.766, 19.9425, 20.3492);
    path.cubicTo(19.5258, 19.9325, 19.2917, 19.3673, 19.2917, 18.7779);
    path.lineTo(19.2917, 6.55566);

    // วาดเส้นที่เป็น path บน Canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class RewardIconPainter extends CustomPainter {
  final bool isActive;

  RewardIconPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isActive
          ? Colors.white
          : Colors.grey // ถ้าเลือกจะเป็นสีขาว ถ้าไม่ได้เลือกจะเป็นสีเทา
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // วาดวงกลมที่มีขอบมน
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radius = size.width / 2; // ขนาดรัศมีของวงกลม

    // วาดวงกลมขอบมน
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // วาดดาวที่อยู่กลางวงกลม
    Path starPath = Path();
    double starSize = radius / 2; // ขนาดของดาว

    // วาดรูปดาว 5 แฉก
    for (int i = 0; i < 5; i++) {
      double angle =
          i * 72.0 - 90.0; // ปรับมุมเริ่มต้นให้แฉกแรกหันขึ้น (0 องศา)
      double x1 = centerX + starSize * Math.cos((angle) * Math.pi / 180);
      double y1 = centerY + starSize * Math.sin((angle) * Math.pi / 180);

      double x2 =
          centerX + starSize * 0.5 * Math.cos((angle + 36.0) * Math.pi / 180);
      double y2 =
          centerY + starSize * 0.5 * Math.sin((angle + 36.0) * Math.pi / 180);

      if (i == 0) {
        starPath.moveTo(x1, y1); // จุดเริ่มต้นของการวาดดาว
      } else {
        starPath.lineTo(x1, y1);
      }

      starPath.lineTo(x2, y2); // วาดแฉกดาวที่สอง
    }
    starPath.close(); // ปิดรูปดาว

    // วาดดาว
    canvas.drawPath(starPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class QrIconPainter extends CustomPainter {
  final bool isActive;

  QrIconPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isActive
          ? Colors.white
          : Colors.grey // สีที่แตกต่างระหว่าง active และ non-active
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 // กำหนดความหนาของเส้น
      ..strokeCap = StrokeCap.butt // ใช้ StrokeCap.butt เพื่อไม่ให้เส้นมีโค้งมน
      ..strokeJoin = StrokeJoin.round; // ใช้ StrokeJoin.round เพื่อมุมมน

    // ขนาดของสี่เหลี่ยม
    double radius = 10; // ความมนของมุม
    double width = size.width;
    double height = size.height;

    // วาดเส้นขอบสี่เหลี่ยมมนแต่ละขอบแยก
    Path path = Path()
      ..moveTo(0, radius) // เริ่มที่มุมบนซ้าย
      ..lineTo(0, height - radius) // ขอบซ้าย
      ..arcToPoint(Offset(radius, height),
          radius: Radius.circular(radius), clockwise: false) // มุมล่างซ้าย
      ..lineTo(width - radius, height) // ขอบล่าง
      ..arcToPoint(Offset(width, height - radius),
          radius: Radius.circular(radius), clockwise: false) // มุมล่างขวา
      ..lineTo(width, radius) // ขอบขวา
      ..arcToPoint(Offset(width - radius, 0),
          radius: Radius.circular(radius), clockwise: false) // มุมบนขวา
      ..lineTo(radius, 0) // ขอบบน
      ..arcToPoint(Offset(0, radius),
          radius: Radius.circular(radius),
          clockwise: false); // มุมบนซ้ายเชื่อมกับขอบแรก

    canvas.drawPath(path, paint);

    // วาดเส้นขีดตรงกลาง
    double lineStartX = width * 0.25;
    double lineEndX = width * 0.75;
    double lineY = height / 2;

    // วาดเส้นตรงกลาง
    Path middlePath = Path()
      ..moveTo(lineStartX, lineY)
      ..lineTo(lineEndX, lineY);

    // วาดเส้น
    canvas.drawPath(middlePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ProfileIconPainter extends CustomPainter {
  final bool isActive;

  ProfileIconPainter({required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isActive
          ? Colors.white
          : Colors.grey // ถ้าเลือกจะเป็นสีขาว ถ้าไม่ได้เลือกจะเป็นสีเทา
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Path สำหรับเส้นขอบและวงกลม
    Path outerPath = Path()
      ..moveTo(5.25234, 13)
      ..lineTo(10.9977, 13)
      ..cubicTo(13.2771, 13, 15.125, 14.8479, 15.125, 17.1273)
      ..cubicTo(15.125, 17.8577, 14.639, 18.4112, 14.0184, 18.514)
      ..lineTo(5.25234, 13)
      ..moveTo(5.25234, 13)
      ..cubicTo(2.97288, 13, 1.125, 14.8479, 1.125, 17.1273)
      ..lineTo(5.25234, 13)
      ..lineTo(1.125, 17.1273)
      ..cubicTo(1.125, 17.8577, 1.61108, 18.4112, 2.23156, 18.514)
      ..lineTo(2.23156, 18.514)
      ..cubicTo(3.63436, 18.7464, 5.71798, 19, 8.125, 19)
      ..lineTo(2.23156, 18.514)
      ..lineTo(8.125, 19)
      ..cubicTo(10.5319, 19, 12.6156, 18.7465, 14.0184, 18.514)
      ..lineTo(8.125, 19)
      ..moveTo(2.14988, 19.0072)
      ..cubicTo(1.25942, 18.8597, 0.625, 18.0723, 0.625, 17.1273)
      ..cubicTo(0.625, 14.5717, 2.69673, 12.5, 5.25234, 12.5)
      ..lineTo(10.9977, 12.5)
      ..cubicTo(13.5533, 12.5, 15.625, 14.5717, 15.625, 17.1273)
      ..cubicTo(15.625, 18.0723, 14.9905, 18.8597, 14.1002, 19.0072);

    // วาดเส้นขอบที่มีสไตล์
    canvas.drawPath(outerPath, paint);

    // Path สำหรับวงกลมกลาง
    Path innerPath = Path()
      ..moveTo(4.625, 5)
      ..cubicTo(4.625, 6.933, 6.192, 8.5, 8.125, 8.5)
      ..cubicTo(10.058, 8.5, 11.625, 6.933, 11.625, 5)
      ..cubicTo(11.625, 3.067, 10.058, 1.5, 8.125, 1.5)
      ..cubicTo(6.192, 1.5, 4.625, 3.067, 4.625, 5)
      ..close();

    // วาดวงกลมกลาง
    paint.style = PaintingStyle.fill; // กำหนดให้เป็นการเติมสี
    canvas.drawPath(innerPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}