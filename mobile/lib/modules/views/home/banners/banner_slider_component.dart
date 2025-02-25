import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async'; // นำเข้าคลาส Timer
import 'package:rimpa/core/services/api_urls.dart';
import '../../../controllers/events/list_banner_controller_.dart'; // นำเข้าคอนโทรลเลอร์
import '../../../../components/imageloader/app-image.component.dart';
import '../homedetail/home_detail.dart';

class BannerSliderComponent extends StatelessWidget {
  ApiUrls apiUrls = Get.find();
  final BannerEventController controller = Get.put(BannerEventController());
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    controller.fetchBanners();

    // เริ่มตั้งเวลาให้เลื่อนแบนเนอร์ทุก 5 วินาที
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      int currentIndex = _pageController.page?.round() ?? 0;
      if (currentIndex == controller.banners.length - 1) {
        _pageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      } else if (controller.banners.isEmpty) {
        return Center(child: Text("ไม่มีแบนเนอร์"));
      }

      // จำกัดแบนเนอร์ให้สูงสุด 8 ภาพ
      var banners = controller.banners.take(8).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Slider
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                controller.pageIndex.value = index; // อัปเดตหน้าปัจจุบัน
              },
              itemBuilder: (context, index) {
                String bannerPath = banners[index]["path"] ?? '';
                String imageUrl = bannerPath.isEmpty
                    ? 'assets/images/default_banner.jpg'
                    : '${apiUrls.imgUrl.value}$bannerPath';

                return GestureDetector(
                  onTap: () {
                    // เรียก fetchBannerDetail เพื่อดึงรายละเอียดแบนเนอร์
                    var bannerId = banners[index]['id'];
                    controller.fetchBannerDetail(bannerId);  // เรียก fetchBannerDetail

                    // ส่งข้อมูลแบนเนอร์ที่โหลดแล้วไปยังหน้ารายละเอียด
                    Get.toNamed('/detail-banner', arguments: {
                      'bannerId': bannerId,
                      'bannerDetail': banners[index], // ส่งข้อมูลของแบนเนอร์
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: AppImageComponent(
                      aspectRatio: 2.08 / 1,
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
