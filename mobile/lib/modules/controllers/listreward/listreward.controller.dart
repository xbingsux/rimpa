import 'package:get/get.dart';
import '../../../core/services/api_listreward.dart';
import '../../models/listreward.model.dart';

class ListRewardController extends GetxController {
  var isLoading = true.obs;
  var rewards = <ListReward>[].obs;

  @override
  void onInit() {
    fetchRewards();
    super.onInit();
  }

  void fetchRewards() async {
    try {
      isLoading(true);
      var rewardList = await ApiListReward.fetchRewards();
      if (rewardList != null) {
        rewards.assignAll(rewardList);
        rewards.sort((a, b) => b.id.compareTo(a.id)); // Sort by latest first
      }
    } finally {
      isLoading(false);
    }
  }
}
