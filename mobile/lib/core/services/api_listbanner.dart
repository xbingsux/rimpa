import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constant/app.constant.dart'; // Update this import
import '../../modules/models/listbanner.model.dart';

class ApiListBanner {
  static Future<List<ListBanner>?> fetchBanners() async {
    final response = await http
        .post(Uri.parse('${AppApi.urlApi}/list-banner')); // Use AppApi.urlApi

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonResponse = json.decode(jsonString);
      var bannerList = jsonResponse['banner'] as List;
      return bannerList.map((data) => ListBanner.fromJson(data)).toList();
    } else {
      // Handle error
      return null;
    }
  }
}
