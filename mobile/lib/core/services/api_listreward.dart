import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constant/app.constant.dart'; // Update this import
import '../../modules/models/listreward.model.dart';

class ApiListReward {
  static Future<List<ListReward>?> fetchRewards() async {
    final response = await http.get(
        Uri.parse('${AppApi.urlApi}/reward/list-reward'));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonResponse = json.decode(jsonString);
      var rewardList = jsonResponse['reward'] as List;
      return rewardList.map((data) => ListReward.fromJson(data)).toList();
    } else {
      // Handle error
      return null;
    }
  }

  static Future<List<ListReward>?> fetchRecommendRewards() async { //NOTE
    final response = await http.get(
        Uri.parse('${AppApi.urlApi}/reward/list-reward?popular=desc&limit=5'));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonResponse = json.decode(jsonString);
      var rewardList = jsonResponse['reward'] as List;
      return rewardList.map((data) => ListReward.fromJson(data)).toList();
    } else {
      // Handle error
      return null;
    }
  }
}
