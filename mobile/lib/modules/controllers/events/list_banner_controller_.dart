import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL

class BannerEventController extends GetxController {
  var isLoading = false.obs;
  var banners = [].obs; // เก็บข้อมูลแบนเนอร์ทั้งหมด
  var bannerDetail = {}.obs; // เก็บข้อมูลรายละเอียดแบนเนอร์
  var errorMessage = ''.obs;
  var pageIndex = 0.obs; // เพิ่มตัวแปร pageIndex เพื่อเก็บค่าหน้าปัจจุบัน
  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX

  // ฟังก์ชันดึงข้อมูลแบนเนอร์ทั้งหมด
  Future<void> fetchBanners() async {
    isLoading.value = true;
    try {
      var response = await dio.post(apiUrlsController.listsbanners.value);
      if (response.statusCode == 200 && response.data['status'] == "success") {
        banners.value = response.data['banner'];
      } else {
        errorMessage.value = "ไม่สามารถโหลดข้อมูลแบนเนอร์ได้";
      }
    } catch (e) {
      print("Error: $e");

      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
    } finally {
      isLoading.value = false;
    }
  }

  // ฟังก์ชันดึงข้อมูลรายละเอียดของแบนเนอร์ตาม `id`
  Future<void> fetchBannerDetail(int id) async {
    isLoading.value = true;
    try {
      var response = await dio.post(
        apiUrlsController.getbanner.value, // URL สำหรับดึงรายละเอียดแบนเนอร์
        data: {"id": id}, // ส่ง `id` ของแบนเนอร์ไปยัง API
      );

      if (response.statusCode == 200 && response.data['status'] == "success") {
        bannerDetail.value =
            response.data['banner']; // อัปเดตรายละเอียดแบนเนอร์
      } else {
        errorMessage.value = "ไม่สามารถโหลดรายละเอียดแบนเนอร์ได้";
      }
    } catch (e) {
      print("Error: $e");
      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
    } finally {
      isLoading.value = false;
    }
  }
}
