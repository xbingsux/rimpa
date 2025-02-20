import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../modules/models/listevent.model.dart';

class ApiListEvent {
  static Future<List<Event>> fetchEvents() async {
    final response =
        await http.post(Uri.parse('http://localhost:3001/event/list-event'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var eventList =
          (jsonData['event'] as List).map((e) => Event.fromJson(e)).toList();
      return eventList;
    } else {
      throw Exception('Failed to load events');
    }
  }
}
