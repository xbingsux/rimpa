import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'dart:async'; // นำเข้าคลาส Timer
import 'package:rimpa/core/services/api_urls.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controllers/events/list_banner_controller_.dart'; // นำเข้าคอนโทรลเลอร์
import '../../../../components/imageloader/app-image.component.dart';

class BannerSliderComponent extends StatefulWidget {
  @override
  _BannerSliderComponentState createState() => _BannerSliderComponentState();
}

class _BannerSliderComponentState extends State<BannerSliderComponent> {
  ApiUrls apiUrls = Get.find();
  final BannerEventController controller = Get.put(BannerEventController());
  final PageController _pageController = PageController(viewportFraction: 0.925);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    controller.fetchBanners(); // ดึงข้อมูลแบนเนอร์
    startAutoScroll(); // เริ่มการเลื่อนแบนเนอร์อัตโนมัติ
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int currentIndex = _pageController.page?.round() ?? 0;
        int nextPage = (currentIndex + 1) % controller.banners.length;

        _pageController.animateToPage(nextPage, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
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
        // return Center(child: CircularProgressIndicator());
        return bannerLoading();
      } else if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Text(controller.errorMessage.value),
        );
      } else if (controller.banners.isEmpty) {
        return SizedBox();
      }

      // จำกัดแบนเนอร์ให้สูงสุด 8 ภาพ
      var banners = controller.banners.take(8).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // bannerLoading(),
          // Banner Slider
          AspectRatio(
            aspectRatio: (16.0/9.0) * 0.925,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                controller.pageIndex.value = index; // อัปเดตหน้าปัจจุบัน
              },
              itemBuilder: (context, index) {
                String bannerPath = banners[index]["path"] ?? '';
                String imageUrl = bannerPath.isEmpty ? 'assets/images/default_banner.jpg' : '${apiUrls.imgUrl.value}$bannerPath';
            
                return GestureDetector(
                  onTap: () {
                    // stopAutoScroll(); // หยุด Timer เมื่อกดเข้าไปดูแบนเนอร์
                    // var bannerId = banners[index]['id'];
                    // controller.fetchBannerDetail(bannerId);
            
                    // Get.to(() => BannersDetailPage(bannerId: bannerId), arguments: bannerId)?.then((_) {
                    //   // เมื่อกลับมาที่หน้าหลัก ให้เริ่มการเลื่อนใหม่
                    //   startAutoScroll();
                    // });
                  },
                  // child: AspectRatio(
                  //   aspectRatio: 16 / 9,
                  //   child: Container(
                  //     decoration: ShapeDecoration(
                  //       color: Colors.amber,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
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
          GetX<BannerEventController>(
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(banners.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: controller.pageIndex.value == index ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.pageIndex.value == index ? Colors.blue : Colors.grey,
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

Widget bannerLoading() {
  return Column(
    children: [
      Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            height: 150,
            decoration: ShapeDecoration(
              color: Color(0xFFD9D9D9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
