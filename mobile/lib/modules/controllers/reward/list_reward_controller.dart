import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:rimpa/widgets/popupdialog/popupredeempoint_dialog.dart';
import '../../../core/services/api_urls.dart'; // นำเข้าที่เก็บ API URL

class RewardController extends GetxController {
  var isLoading = false.obs;
  var rewards = [].obs; // รายการรางวัลทั้งหมด
  var rewardDetail = {}.obs; // รายละเอียดรางวัล
  var errorMessage = ''.obs;
  var pageIndex = 0.obs; // ใช้เก็บค่าหน้าปัจจุบัน
  var isRedeemed = false.obs; // กำหนดตัวแปรเก็บสถานะการแลกรางวัล
  final Dio dio = Dio();
  final apiUrlsController = Get.find<ApiUrls>(); // เรียก ApiUrls จาก GetX

  // ฟังก์ชันดึงข้อมูลรางวัลทั้งหมด
  Future<void> fetchRewards() async {
    isLoading.value = true;
    try {
      var response = await dio.post(apiUrlsController.listsreward.value);

      if (response.statusCode == 200 && response.data['status'] == "success") {
        rewards.value = (response.data['reward'] as List).map((item) {
          item['img'] = item['img'].replaceAll(r'\', '/'); // แก้ path รูปภาพ
          return item;
        }).toList();

        print("Fetched rewards: ${rewards.value}");
      } else {
        errorMessage.value = "ไม่สามารถโหลดข้อมูลรางวัลได้";
        print("Error Message: ${errorMessage.value}");
      }
    } catch (e) {
      print("Error fetching rewards: $e");
      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
    } finally {
      isLoading.value = false;
    }
  }

  // ฟังก์ชันดึงข้อมูลรายละเอียดของรางวัลตาม `id`
  Future<void> fetchRewardDetail(int id) async {
    isLoading.value = true;
    try {
      var response = await dio.post(
        apiUrlsController.getreward.value, // URL สำหรับดึงรายละเอียดรางวัล
        data: {"id": id}, // ส่ง `id` ของรางวัลไปยัง API
      );

      if (response.statusCode == 200 && response.data['status'] == "success") {
        rewardDetail.value = response.data['reward']; // อัปเดตรายละเอียดรางวัล
      } else {
        errorMessage.value = "ไม่สามารถโหลดรายละเอียดรางวัลได้";
      }
    } catch (e) {
      print("Error: $e");
      errorMessage.value = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
    } finally {
      isLoading.value = false;
    }
  }

Future<void> redeemReward(
    String idProfile, String idReward, Decimal points, Decimal cost) async {
  if (isLoading.value) return;
  isLoading.value = true;
  print("points: $points");
  print("cost: $cost");

  try {
    int profileId = int.parse(idProfile);
    int rewardId = int.parse(idReward);

    var response = await dio.post(
      apiUrlsController.redeemReward.value,
      data: {
        'idProfile': profileId,
        'idReward': rewardId,
      },
    );

    if (response.statusCode == 200 && response.data['status'] == 'success') {
      rewardDetail.value = response.data['reward'];
      errorMessage.value = "";

      // แสดง Dialog พร้อมส่งค่า points และ cost
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return CustomDialog(
            context: context,
            cost: cost,
          );
        },
      ).then((_) {
        Get.back(); // ปิด Dialog แล้วกลับไปหน้าก่อนหน้า
      });
    } else if (response.data['message'] == 'You have already redeemed this reward!') {
      errorMessage.value = "คุณเคยแลกรางวัลนี้ไปแล้ว";
      rewardDetail.value['isRedeemed'] = true;
    } else {
      errorMessage.value = "ไม่สามารถ redeem รางวัลได้";
    }
  } catch (e) {
    errorMessage.value = "เกิดข้อผิดพลาดในการ redeem รางวัล";
  } finally {
    isLoading.value = false;
  }
}
}
