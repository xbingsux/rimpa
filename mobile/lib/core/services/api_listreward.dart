import 'package:http/http.dart' as http;
import 'package:rimpa/core/constant/shared_pref.dart';
import 'package:rimpa/modules/controllers/getusercontroller/auth_service.dart';
import 'dart:convert';
import '../../core/constant/app.constant.dart'; // Update this import
import '../../modules/models/listreward.model.dart';

class ApiListReward {
  static Future<List<ListReward>?> fetchRewards() async {
    final String token = await SharedPrefService().getToken() ?? "";
    final response = await http
        .get(Uri.parse('${AppApi.urlApi}/reward/list-reward?token=${token}'));

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

  static Future<List<ListReward>?> fetchRecommendRewards() async {
    //NOTE
    final String token = await SharedPrefService().getToken() ??
        ""; // Get the token from your method
    final response = await http.get(Uri.parse(
        '${AppApi.urlApi}/reward/list-reward?popular=desc&limit=5&&token=${token}'));

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
