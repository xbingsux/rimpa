import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:rimpa/modules/views/home/banners/banner_slider.dart';
import 'package:rimpa/widgets/event/event_recommend.dart';
import 'package:rimpa/widgets/event/all_events.dart';
import 'package:rimpa/widgets/my_app_bar.dart';
import '../../controllers/listevent/listevent.controller.dart';
import '../../controllers/listbanner/listbanner.controller.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listEventController = Get.put(ListEventController());
  final listBannerController = Get.put(ListBannerController()); // Add this line

  @override
  void initState() {
    super.initState();

    // เรียก popup แจ้งเตือน
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   PopupDialog.checkAndShowPopup(context);
    // });
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < listBannerController.banners.length - 1) {
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
      appBar: MyAppBar(),
      body: Obx(() {
        if (listEventController.isLoading.value || listBannerController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BannerSliderComponent(), // Corrected line
                Gap(16),
                EventRecommend(),
                SizedBox(height: 16),
                // Add dashed line
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(60, (index) {
                      return Expanded(
                        child: Container(
                          color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                          height: 1,
                        ),
                      );
                    }),
                  ),
                ),
                // Grid Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AllEvents(),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
