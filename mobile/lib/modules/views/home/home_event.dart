import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/services/api_urls.dart';
import 'package:rimpa/modules/controllers/events/list_event_controller.dart';
import '../../../components/cards/app-card.component.dart';
import '../../../components/dropdown/app-dropdown.component.dart';
import '../../../components/imageloader/app-image.component.dart';
import 'homedetail/home_detail.dart';

class HomeEventPage extends StatefulWidget {
  @override
  _HomeEventPageState createState() => _HomeEventPageState();
}

class _HomeEventPageState extends State<HomeEventPage> {
  final EventController controller =
      Get.put(EventController()); // Initialize EventController
  ApiUrls apiUrls = Get.find();
  bool isLoading = false; // เพิ่มตัวแปรเพื่อเช็คสถานะการโหลด
  @override
  void initState() {
    super.initState();
    controller.fetchEventList(); // Fetch data when page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "กิจกรรม",
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
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDropdown(
                      onChanged: (value) {
                        // Handle sorting action
                      },
                      choices: ["ใหม่สุด", "เก่าสุด"],
                      active: "เรียงตาม",
                    ),
                    SizedBox(height: 8),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 0,
                        childAspectRatio: 2 / 3,
                      ),
                      itemCount: controller.event.length,
                      itemBuilder: (context, index) {
                        var eventItem = controller.event[index];
                        var subEvent = eventItem['sub_event']
                            [0]; // Assuming one sub-event per event

                        // Check if there's a valid image and then get the path
                        String imageUrl = subEvent['img'].isNotEmpty
                            ? '${apiUrls.imgUrl.value}${subEvent['img'][0]['path']}'
                            : 'assets/images/default_banner.jpg'; // Use a default image if not available

                        var description =
                            eventItem['description'] ?? "ไม่มีคำอธิบาย";
                        // Shorten description to 3 lines if it's too long
                        description = description.length > 50
                            ? description.substring(0, 50) + '...'
                            : description;

                        return GestureDetector(
                          onTap: () {
                            if (isLoading)
                              return; // ถ้า isLoading เป็น true, ไม่ให้ทำการคลิกอีก
                            setState(() {
                              isLoading =
                                  true; // ตั้งค่า isLoading เป็น true เมื่อเริ่มโหลด
                            });
                            var bannerId = controller.event[index]['id'];
                            controller.fetcheventdetail(bannerId).then((_) {
                              setState(() {
                                isLoading =
                                    false; // กลับเป็น false เมื่อโหลดเสร็จ
                              });
                              Get.to(() => HomeDetailPage(),
                                  arguments: bannerId);
                            }).catchError((error) {
                              setState(() {
                                isLoading =
                                    false; // กลับเป็น false หากเกิดข้อผิดพลาด
                              });
                            });
                          },
                          child: AppCardComponent(
                            child: Column(
                              children: [
                                AppImageComponent(
                                  imageType: AppImageType.network,
                                  imageAddress: imageUrl,
                                ),
                                SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    description,
                                    style: TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow
                                        .ellipsis, // Handle text overflow
                                    maxLines: 3, // Limit description to 3 lines
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
        },
      ),
    );
  }
}
