import 'package:get/get.dart';
import '../../models/listevent.model.dart';
import '../../../core/services/api_listevent.dart';

class ListEventController extends GetxController {
  var events = <ListEvent>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  void fetchEvents() async {
    try {
      isLoading(true);
      var eventList = await ApiListEvent.fetchEvents();
      events.assignAll(eventList);
      events.sort((a, b) => b.id.compareTo(a.id)); // Sort by latest first
    } finally {
      isLoading(false);
    }
  }
}
