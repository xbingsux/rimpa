import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // นำเข้าคลาส Timer
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/reward/list_reward_controller.dart';
import 'package:rimpa/modules/views/home/rewardbanners/rewarddetail.dart';
import '../../../../components/imageloader/app-image.component.dart';

class RewardBannerSliderComponent extends StatefulWidget {
  @override
  _RewardBannerSliderComponentState createState() =>
      _RewardBannerSliderComponentState();
}

class _RewardBannerSliderComponentState
    extends State<RewardBannerSliderComponent> {
  ApiUrls apiUrls = Get.find();
  final RewardController controller = Get.put(RewardController());
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    controller.fetchRewards(); // ดึงข้อมูลแบนเนอร์รางวัล
    startAutoScroll(); // เริ่มการเลื่อนแบนเนอร์อัตโนมัติ
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int currentIndex = _pageController.page?.round() ?? 0;
        int nextPage = (currentIndex + 1) % controller.rewards.length;

        _pageController.animateToPage(nextPage,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
  }

  void stopAutoScroll() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopAutoScroll(); // หยุด Timer เมื่อ Widget ถูกทำลาย
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      } else if (controller.rewards.isEmpty) {
        return Center(child: Text("ไม่มีแบนเนอร์รางวัล"));
      }

      // จำกัดแบนเนอร์ให้สูงสุด 8 ภาพ
      var banners = controller.rewards.take(8).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reward Banner Slider
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                controller.pageIndex.value = index; // อัปเดตหน้าปัจจุบัน
              },
              itemBuilder: (context, index) {
                String bannerPath = banners[index]["img"] ?? '';
                String imageUrl = bannerPath.isEmpty
                    ? 'assets/images/default_reward_banner.jpg'
                    : '${apiUrls.imgUrl.value}$bannerPath';

                return GestureDetector(
                  onTap: () {
                    stopAutoScroll(); // หยุด Timer เมื่อกดเข้าไปดูแบนเนอร์
                    var bannerId = banners[index]['id'];
                    controller.fetchRewardDetail(bannerId);
                    
                    Get.to(() => RewardDetail(bannerId: bannerId), arguments: bannerId)
?.then((_) {
                      // เมื่อกลับมาที่หน้าหลัก ให้เริ่มการเลื่อนใหม่
                      startAutoScroll();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: AppImageComponent(
                      aspectRatio: 16 / 9,
                      fit: BoxFit.cover,
                      imageType: AppImageType.network,
                      imageAddress: imageUrl,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          // จุดที่แสดงด้านล่างแบนเนอร์
          GetX<RewardController>(
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(banners.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: controller.pageIndex.value == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.pageIndex.value == index
                          ? Colors.blue
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      );
    });
  }
}
