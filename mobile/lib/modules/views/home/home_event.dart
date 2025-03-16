import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/widgets/button/notifiction_button.dart';
import 'package:rimpa/widgets/event/all_events.dart';
import '../../controllers/listevent/listevent.controller.dart';

class HomeEventPage extends StatefulWidget {
  @override
  _HomeEventPageState createState() => _HomeEventPageState();
}

class _HomeEventPageState extends State<HomeEventPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listEventController = Get.put(ListEventController()); // Add this line

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // _pageController.animateToPage(
      //   _currentPage,
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeIn,
      // );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "กิจกรรม",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: AppTextSize.xl,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: NotificationButton(),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        double bodyHeight = constraints.maxHeight;
        // double bodyWidth = constraints.maxWidth;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AllEvents(
            showTitle: false,
            isScroll: true,
            screenHigh: bodyHeight - (40),
          ),
        );
      }),
    );
  }
}
