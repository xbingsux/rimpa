import 'package:flutter/material.dart';
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
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent, // ทำให้ Status Bar โปร่งใส
    //   statusBarIconBrightness: Brightness.light, // ตั้งค่าไอคอนของ Status Bar ให้เหมาะกับพื้นหลัง
    // ));

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
                gradient: AppGradiant.gradientX_1,
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
                        decoration: const BoxDecoration(
                          gradient: AppGradiant.gradientX_1,
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
              height: bodyHeight - (96 + 40 + 58),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
                    // color: Colors.amber,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Removed card here
                      // const SizedBox(height: 40),
                      // Banner slider
                      // Obx(() {
                      //   if (listBannerController.isLoading.value) {
                      //     return const Center(child: CircularProgressIndicator());
                      //   } else {
                      //     return SizedBox(
                      //       height: 150,
                      //       child: PageView.builder(
                      //         controller: _pageController,
                      //         itemCount: listBannerController.banners.length,
                      //         onPageChanged: (index) {
                      //           setState(() {
                      //             _currentPage = index;
                      //           });
                      //         },
                      //         itemBuilder: (context, index) {
                      //           var banner = listBannerController.banners[index];
                      //           return GestureDetector(
                      //             onTap: () {
                      //               Get.to(() => BannerDetailPage(banner: banner)); // Corrected line
                      //             },
                      //             child: Container(
                      //               margin: const EdgeInsets.symmetric(horizontal: 8),
                      //               child: AppImageComponent(
                      //                 aspectRatio: 16 / 9,
                      //                 fit: BoxFit.cover,
                      //                 imageType: AppImageType.network,
                      //                 imageAddress: '${AppApi.urlApi}${banner.path.replaceAll("\\", "/")}', // Use AppApi.urlApi
                      //               ),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   }
                      // }),

                      // const SizedBox(height: 8),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: List.generate(listBannerController.banners.length, (index) {
                      //     return Container(
                      //       margin: const EdgeInsets.symmetric(horizontal: 4),
                      //       width: _currentPage == index ? 12 : 8,
                      //       height: 8,
                      //       decoration: BoxDecoration(
                      //         color: _currentPage == index ? Colors.blue : Colors.grey,
                      //         borderRadius: BorderRadius.circular(4),
                      //       ),
                      //     );
                      //   }),
                      // ),
                      RewardRecommend(),
                      // EventFav(),
                      // EventRecommend(),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: AllReward(),
                      ),
                      // Add dashed line
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