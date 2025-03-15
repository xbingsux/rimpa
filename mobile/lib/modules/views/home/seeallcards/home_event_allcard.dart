import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rimpa/widgets/button/back_button.dart';
import 'package:rimpa/widgets/event/all_reward.dart';
import '../../../../core/constant/app.constant.dart';
import '../../../controllers/listevent/listevent.controller.dart';

class HomeEventAllcard extends StatefulWidget {
  @override
  _HomeEventAllcardState createState() => _HomeEventAllcardState();
}

class _HomeEventAllcardState extends State<HomeEventAllcard> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listEventController = Get.put(ListEventController());

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
                "สิทธิพิเศษ",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: AppTextSize.xl,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: MyBackButton(),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        double bodyHeight = constraints.maxHeight;
        // double bodyWidth = constraints.maxWidth;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: AllReward(
            showTitle: false,
            isScroll: true,
            screenHigh: bodyHeight - (40),
          ),
        );
      }),
    );
  }
}
