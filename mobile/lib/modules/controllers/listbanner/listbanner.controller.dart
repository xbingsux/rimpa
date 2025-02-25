import 'package:get/get.dart';
import '../../../core/services/api_listbanner.dart';
import '../../models/listbanner.model.dart';

class ListBannerController extends GetxController {
  var isLoading = true.obs;
  var banners = <ListBanner>[].obs;

  @override
  void onInit() {
    fetchBanners();
    super.onInit();
  }

  void fetchBanners() async {
    try {
      isLoading(true);
      var bannerList = await ApiListBanner.fetchBanners();
      if (bannerList != null) {
        banners.assignAll(bannerList);
        banners.sort((a, b) => b.id.compareTo(a.id)); // Sort by latest first
      }
    } finally {
      isLoading(false);
    }
  }
}
