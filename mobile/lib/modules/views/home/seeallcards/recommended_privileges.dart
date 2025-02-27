import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:rimpa/modules/views/home/homedetail/home_detail_reward.dart';

import '../../../../components/dropdown/app-dropdown.component.dart';
import '../../../../components/cards/app-card.component.dart';
import '../../../../components/imageloader/app-image.component.dart';
import '../../../../core/constant/app.constant.dart';
import '../home_reward.dart';
import '../homedetail/home_detail.dart';
import '../../../controllers/listreward/listreward.controller.dart'; // Add this import
import '../../../models/listreward.model.dart'; // Add this import

class RecommendedPrivilegesPage extends StatefulWidget {
  @override
  _RecommendedPrivilegesPageState createState() =>
      _RecommendedPrivilegesPageState();
}

class _RecommendedPrivilegesPageState extends State<RecommendedPrivilegesPage> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;
  final listRewardController = Get.put(ListRewardController()); // Add this line
  String _sortOrder = "ใหม่สุด"; // Add this line

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 7) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
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
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // รองรับ Light/Dark Mode
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "สิทธิพิเศษ",
                style: TextStyle(color: Color(0xFF1E54FD), fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.notifications_none, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (listRewardController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<ListReward> sortedRewards =
              listRewardController.rewards.toList();
          if (_sortOrder == "ใหม่สุด") {
            sortedRewards.sort((a, b) => b.id.compareTo(a.id));
          } else {
            sortedRewards.sort((a, b) => a.id.compareTo(b.id));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grid Section
                  AppDropdown(
                    onChanged: (value) {
                      setState(() {
                        _sortOrder = value;
                      });
                    },
                    choices: ["ใหม่สุด", "เก่าสุด"],
                    active: _sortOrder,
                  ),
                  SizedBox(height: 8),
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: sortedRewards.length,
                    itemBuilder: (context, index) {
                      var reward = sortedRewards[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => HomeDetailReward(reward: reward));
                        },
                        child: AppCardComponent(
                          child: Column(
                            children: [
                              AppImageComponent(
                                imageType: AppImageType.network,
                                imageAddress:
                                    '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}',
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  reward.rewardName,
                                  style: TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
