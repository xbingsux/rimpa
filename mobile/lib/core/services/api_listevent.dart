import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constant/app.constant.dart'; 
import '../../modules/models/listevent.model.dart';

class ApiListEvent {
  static Future<List<ListEvent>> fetchEvents() async {
    final response = await http.get(
        Uri.parse('${AppApi.urlApi}/event/list-event'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var eventList = (jsonData['event'] as List)
          .map((e) => ListEvent.fromJson(e))
          .toList();
      return eventList;
    } else {
      throw Exception('Failed to load events');
    }
  }

  static Future<List<ListEvent>> fetchRecommendEvents() async { //NOTE
    final response = await http.get(
        Uri.parse('${AppApi.urlApi}/event/list-event?popular=desc&limit=5')); 

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var eventList = (jsonData['event'] as List)
          .map((e) => ListEvent.fromJson(e))
          .toList();
      return eventList;
    } else {
      throw Exception('Failed to load events');
    }
  }
}