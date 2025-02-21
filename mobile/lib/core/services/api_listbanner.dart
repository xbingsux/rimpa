import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import '../../core/constant/app.constant.dart'; // Update this import

import '../../modules/models/listbanner.model.dart';

class ApiListBanner {
  static var client = http.Client();

  static Future<List<ListBanner>?> fetchBanners() async {
    var response = await client
        .post(Uri.parse('${AppApi.urlApi}/list-banner')); // Use AppApi.urlApi

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}'); // Log the response body

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
