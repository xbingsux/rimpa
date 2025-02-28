import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/animation.dart';

class DeleteConfirmationPage extends StatefulWidget {
  final VoidCallback onConfirmDelete;

  const DeleteConfirmationPage({required this.onConfirmDelete, Key? key})
      : super(key: key);

  @override
  _DeleteConfirmationPageState createState() => _DeleteConfirmationPageState();
}

class _DeleteConfirmationPageState extends State<DeleteConfirmationPage>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  bool _isLoadingComplete = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _percentage = 1;
  int _currentMessageIndex = 0;
  List<String> _messages = [
    "เรากำลังตรวจหาบัญชีของคุณ...",
    "เรากำลังจะลบบัญชีของคุณ...",
    "เรากำลังลบบัญชีของคุณ..."
  ];

  @override
  void initState() {
    super.initState();
    _startLoading();

    // สร้าง Animation วงกลมออร่ากระพริบ
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
        setState(() {
          _isLoadingComplete = true;
        });
      } else {
        setState(() {
          _progress += 0.05;
          _percentage = (_progress * 100).toInt();

          if (_percentage % 40 == 0 && _currentMessageIndex < _messages.length - 1) {
            _currentMessageIndex++;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // วงกลมออร่ากระพริบ
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(_animation.value * 0.6),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: const Icon(Icons.delete, size: 80, color: Colors.red),
                ),
                const SizedBox(height: 20),

                // แถบโหลดแบบเคลื่อนที่จากซ้ายไปขวา
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 200,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          left: (_progress * 200) - 200,
                          duration: const Duration(milliseconds: 100),
                          child: Container(
                            width: 200,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // แสดงเปอร์เซ็นต์
                const SizedBox(height: 5),
                Text(
                  "$_percentage%",
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),

                // แสดงข้อความเปลี่ยนไปตามเวลา
                if (!_isLoadingComplete) ...[
                  const SizedBox(height: 20),
                  Text(
                    _messages[_currentMessageIndex],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],

                // ข้อความสุดท้ายเมื่อโหลดเสร็จ
                if (_isLoadingComplete) ...[
                  const SizedBox(height: 20),
                  const Text(
                    "เราเสียใจจริงๆนะที่คุณจะทิ้งเราไป",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ],
            ),
          ),

          // ปุ่มล่างจอ
          if (_isLoadingComplete)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ปุ่ม "ตกลง" (สีแดง)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onConfirmDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 226, 61, 11),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("ยืนยันลบ",
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ปุ่ม "ยกเลิก" (สีเทา)
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("ยกเลิก",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
