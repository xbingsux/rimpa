import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rimpa/modules/controllers/reward/list_reward_controller.dart';
import 'package:rimpa/widgets/card/reward_score.dart';
import 'package:rimpa/widgets/event/all_reward.dart';
import 'package:rimpa/widgets/event/reward_recommend.dart';
import 'package:rimpa/widgets/my_app_bar.dart';
import 'dart:async';
import '../../../core/constant/app.constant.dart';
import '../../controllers/listreward/listreward.controller.dart'; // Add this import
import '../../controllers/listbanner/listbanner.controller.dart'; // Add this import
import '../../controllers/listevent/listevent.controller.dart'; // Add this import

class HomeRewardPage extends StatefulWidget {
  const HomeRewardPage({super.key});

  @override
  _HomeRewardPageState createState() => _HomeRewardPageState();
}

class _HomeRewardPageState extends State<HomeRewardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listRewardController = Get.put(ListRewardController()); // Add this line
  final listBannerController = Get.put(ListBannerController()); // Add this line
  final listEventController = Get.put(ListEventController()); // Add this line
  final rewardController = Get.put(RewardController()); //  ใส่ตรงนี้
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < listBannerController.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // _pageController.animateToPage(
      //   _currentPage,
      //   duration: const Duration(milliseconds: 300),
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
    // เพิ่ม ProfileController
    return Scaffold(
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        double bodyHeight = constraints.maxHeight;
        // double bodyWidth = constraints.maxWidth;
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradiant.gradientY_1,
              ),
              child: MyAppBar(
                backgroundColor: Colors.transparent,
                darkMode: true,
              ),
            ),
            SizedBox(
              height: 96,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 45,
                        decoration: const BoxDecoration(color: AppColors.accent2
                            // gradient: AppGradiant.gradientX_1,
                            ),
                      ),
                      Container(
                        height: 45,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RewardScore(),
                  ),
                ],
              ),
            ),
            Container(
              height: bodyHeight - (96 + 60 + 58 ),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
                    // color: Colors.amber,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RewardRecommend(),
                      // EventFav(),
                      // EventRecommend(),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: AllReward(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}



            // 