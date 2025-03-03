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
      print("API Response: $jsonString"); // Log the entire response
      var jsonResponse = json.decode(jsonString);

      if (jsonResponse['status'] == "success" && jsonResponse['banner'] != null) {
        var bannerList = jsonResponse['banner'] as List;
        print("Banner List: $bannerList"); // Log the parsed banner list
        return bannerList.map((data) => ListBanner.fromJson(data)).toList();
      } else {
        print("No banners found or incorrect response format.");
        return null;
      }
    } else {
      print("Failed to load banners. Status code: ${response.statusCode}");
      return null;
    }
  }
}
