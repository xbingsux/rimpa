import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import '../../core/constant/app.constant.dart'; // Update this import
import '../../modules/models/listreward.model.dart';

class ApiListReward {
  static var client = http.Client();

  static Future<List<ListReward>?> fetchRewards() async {
    var response = await client.post(
        Uri.parse('${AppApi.urlApi}/reward/list-reward')); // Use AppApi.urlApi

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
