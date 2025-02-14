import 'package:flutter/material.dart';

class CustomDialog extends StatefulWidget {
  final BuildContext context;

  CustomDialog({required this.context});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // กำหนดเวลาอนิเมชั่น
    )..forward(); // เริ่มอนิเมชั่นทันทีที่ Dialog เปิด

    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut), // ใช้ curve "elasticOut" เพื่อให้ดูเด้งขึ้น
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent, // พื้นหลังของ Dialog โปร่งใส
      child: ScaleTransition( // ใช้ ScaleTransition สำหรับอนิเมชั่นขยาย
        scale: _scaleAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipPath(
                clipper: TicketClipper(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white, // พื้นหลังสีขาว
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "สำเร็จ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // สีฟ้า
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "คุณได้รับคะแนนเรียบร้อยแล้ว",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey, // สีเทา
                        ),
                      ),
                      SizedBox(height: 30),
                      CustomPaint(
                        size: Size(double.infinity, 1),
                        painter: DottedLinePainter(
                          color: Colors.grey,
                          dashWidth: 8,
                          dashSpace: 6,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100, // พื้นหลังฟ้าอ่อน
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue), // ขอบสีฟ้า
                        ),
                        child: Text(
                          "100 คะแนน",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // สีฟ้า
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "ยอดสะสมของคุณเหลือ 150 คะแนน",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // สีดำ
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
              top: -68,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity: 1.0, // ทำให้สีสดใส
                  duration: Duration(seconds: 1),
                  child: AnimatedPulseCircle(),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 20,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(20)));
    path.addArc(Rect.fromCircle(center: Offset(0, size.height / 2), radius: 30),
        -1.5708, 3.1416);
    path.addArc(
        Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: 30),
        1.5708, 3.1416);
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class AnimatedPulseCircle extends StatefulWidget {
  @override
  _AnimatedPulseCircleState createState() => _AnimatedPulseCircleState();
}

class _AnimatedPulseCircleState extends State<AnimatedPulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(_controller.value),
                blurRadius: 20 + (_controller.value * 15),
                spreadRadius: _controller.value * 10,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.blue,
            child: Icon(Icons.check, color: Colors.white, size: 52),
          ),
        );
      },
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  DottedLinePainter(
      {this.dashWidth = 6.0, this.dashSpace = 4.0, this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
