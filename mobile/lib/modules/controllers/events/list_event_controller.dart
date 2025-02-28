import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:rimpa/widgets/popupdialog/popupeventpoint_dialog.dart';
import '../../../core/services/api_urls.dart';

import '../../controllers/middleware/auth_middleware.dart';
class EventController extends GetxController {
  final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();
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
        apiUrlsController
            .getEventDetails.value, // URL สำหรับดึงรายละเอียดแบนเนอร์
        data: {"id": id}, // ส่ง `id` ของแบนเนอร์ไปยัง API
      );

      print(
          'Response status code: ${response.statusCode}'); // Log status code ของ response
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
        print(
            'Failed to fetch event details. Status: ${response.data['status']}');
      }
    } catch (e) {
      print("Error: $e");
      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
    } finally {
      isLoading.value = false;
    }
  }

Future<void> scanQRCode(String userId, String qrcode) async {
  if (isLoading.value) return; // ป้องกันการเรียก API หลายครั้ง
  isLoading.value = true; // ตั้งสถานะเป็นกำลังโหลด
  print('Scanning QR code for user: $userId with QR: $qrcode'); // log ข้อมูลการสแกน

  try {
    // ดึง token จาก AuthMiddleware
    final AuthMiddleware _authMiddleware = Get.find<AuthMiddleware>();
    String? token = await _authMiddleware.getToken(); // ดึง token

    if (token == null) {
      errorMessage.value = "ไม่มี token สำหรับการยืนยันตัวตน";
      print("No token found");
      return;
    }

    var response = await Dio().post(
      apiUrlsController.Scanevent.value, // URL สำหรับดึงรายละเอียดแบนเนอร์
      options: Options(
        headers: {
          "Authorization": "Bearer $token", // ส่ง token ใน headers
        },
      ),
      data: {
        'qrcode': qrcode,
      },
    );
    print('Response status code: ${response.statusCode}'); // log สถานะของ response
    print('Response data: ${response.data}'); // log ข้อมูลที่ได้รับจาก API

    if (response.statusCode == 200 && response.data['status'] == "success") {
      var event = response.data['event'];

      if (event != null && event.isNotEmpty) {
        // ถ้ามีกิจกรรมให้ทำงาน
        print('Event data: $event');
      } else {
        // กรณีที่ไม่มีข้อมูลกิจกรรม
        errorMessage.value = "ไม่พบข้อมูลกิจกรรม";
        print('No events found');
      }
    } else {
      errorMessage.value = "ไม่สามารถโหลดข้อมูลกิจกรรมได้";
      print('Failed to fetch event. Status: ${response.data['status']}');
    }
  } catch (e) {
    print("Error: $e");
    errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
  } finally {
    isLoading.value = false; // ปิดสถานะการโหลด
  }
}




Future<void> checkIn(int subEventId, BuildContext context) async {
  if (isLoading.value) return; // ป้องกันไม่ให้เรียกหลายครั้ง
  isLoading.value = true;
  print('Checking in for subEventId: $subEventId'); // Log subEventId ที่จะใช้ในการเช็คอิน

  String? token = await _authMiddleware.getToken(); // ดึง token จาก middleware

  try {
    var response = await dio.post(
      apiUrlsController.checkinevent.value, // URL สำหรับการเช็คอิน
      data: {"sub_event_id": subEventId}, // ส่งข้อมูล sub_event_id ไปยัง API
      options: Options(
        headers: {"Authorization": "Bearer $token"}, // ใส่ Authorization header
      ),
    );

    print('Response status code: ${response.statusCode}'); // Log status code ของ response
    print('Response data: ${response.data}'); // Log ข้อมูลที่ได้รับจาก API

    if (response.statusCode == 200 && response.data['status'] == 'success') {
      var event = response.data['event']; // ดึงข้อมูล event จาก response

      // ตรวจสอบ event ที่ได้รับ
      if (event != null && event.isNotEmpty) {
        // หากข้อมูลกิจกรรมมีอยู่จริงให้แสดง CustomDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(context: context); // แสดง CustomDialog
          },
        );
      } else {
        // หากข้อมูลไม่ครบถ้วนให้แสดงข้อความ error
        print('No event found');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(context: context); // แสดง CustomDialog หรือข้อความ error
          },
        );
      }
    } else {
      // แสดงข้อความเมื่อ API ล้มเหลว
      print('Failed to check in: ${response.data['message']}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(context: context); // แสดง CustomDialog หรือข้อความ error
        },
      );
    }
  } catch (e) {
    print("Error: $e"); // หากเกิดข้อผิดพลาดในการเชื่อมต่อ
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(context: context); // แสดง CustomDialog หากเกิดข้อผิดพลาด
      },
    );
  } finally {
    isLoading.value = false; // รีเซ็ตสถานะการโหลด
  }
}


}
