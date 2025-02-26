import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_urls.dart';

class EventController extends GetxController {
  var event = [].obs; // Holds the list of events
  var eventdetail = {}.obs; // Holds selected event details
  var isLoading = false.obs;
  final Dio dio = Dio();
  var errorMessage = ''.obs;
  final apiUrlsController = Get.find<ApiUrls>();

  // Fetch all events
  Future<void> fetchEventList() async {
    if (isLoading.value) return; // Prevent multiple calls
    isLoading.value = true; // Start loading
    try {
      var response = await dio.post(apiUrlsController.listsevents.value);
      if (response.statusCode == 200 && response.data['status'] == "success") {
        if (response.data['event'] != null) {
          event.value = response.data['event'];
        } else {
          errorMessage.value = "ไม่พบข้อมูลกิจกรรม";
        }
      } else {
        errorMessage.value = "ไม่สามารถโหลดข้อมูลกิจกรรม";
      }
    } catch (e) {
      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch event details by id
  Future<void> fetcheventdetail(int id) async {
    if (isLoading.value) return; // Prevent multiple calls
    isLoading.value = true;
    print('Fetching event details for ID: $id'); // Log ID ที่จะดึงข้อมูล

    try {
      var response = await dio.post(
        apiUrlsController.getEventDetails.value, // URL สำหรับดึงรายละเอียดแบนเนอร์
        data: {"id": id}, // ส่ง `id` ของแบนเนอร์ไปยัง API
      );

      print('Response status code: ${response.statusCode}'); // Log status code ของ response
      print('Response data: ${response.data}'); // Log ข้อมูลที่ได้รับจาก API

      if (response.statusCode == 200 && response.data['status'] == "success") {
        var event = response.data['event'];

        // ตรวจสอบว่า event มีค่าหรือไม่ก่อนที่จะเข้าถึงข้อมูล
        if (event != null && event.isNotEmpty) {
          eventdetail.value = event; // อัปเดตรายละเอียดแบนเนอร์
        } else {
          errorMessage.value = "ไม่พบข้อมูลกิจกรรม";
          print('No events found');
        }
      } else {
        errorMessage.value = "ไม่สามารถโหลดรายละเอียดกิจกรรมได้";
        print('Failed to fetch event details. Status: ${response.data['status']}');
      }
    } catch (e) {
      print("Error: $e");
      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
    } finally {
      isLoading.value = false;
    }
  }
}
