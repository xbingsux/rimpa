import 'package:get/get.dart';
import 'package:rimpa/core/services/api_service.dart';
import 'package:rimpa/modules/views/redeem/redeem_qr_model.dart';

class RedeemQRController extends GetxController {
  var isLoading = false.obs;
  var redeemData = Rxn<RedeemQRModel>();
  var errorMessage = "".obs;

  Future<void> fetchRedeemQR(int rewardID) async {
    try {
      isLoading(true);
      errorMessage.value = ""; // เคลียร์ error

      final response = await ApiService().post("/reward/redeem-qrcode", data: {
        "reward_id": rewardID,
      });

      redeemData.value = RedeemQRModel.fromJson(response?.data);
    } catch (error) {
      errorMessage.value = "ไม่สามารถแลกสิทธิ์ได้";
    } finally {
      isLoading(false);
    }
  }
}
