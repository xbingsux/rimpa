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
      print("Fetching banners...");

      var bannerList = await ApiListBanner.fetchBanners();
      
      if (bannerList != null) {
        print("Banners fetched successfully: $bannerList");

        banners.assignAll(bannerList);

        // Sorting the banners
        banners.sort((a, b) => b.id.compareTo(a.id)); // Sort by latest first
        print("Sorted banners: $banners");
      } else {
        print("No banners found.");
      }
    } catch (e) {
      print("Error fetching banners: $e");
    } finally {
      isLoading(false);
      print("Finished fetching banners.");
    }
  }
}
