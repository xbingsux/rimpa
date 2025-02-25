class ListEvent {
  final int id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final List<SubEvent> subEvents;

  ListEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.subEvents,
  });

  factory ListEvent.fromJson(Map<String, dynamic> json) {
    var list = json['sub_event'] as List;
    List<SubEvent> subEventList =
        list.map((i) => SubEvent.fromJson(i)).toList();

    return ListEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      subEvents: subEventList,
    );
  }
}

class SubEvent {
  final int id;
  final String imagePath;
  final String map;

  SubEvent({
    required this.id,
    required this.imagePath,
    required this.map,
  });

  factory SubEvent.fromJson(Map<String, dynamic> json) {
    return SubEvent(
      id: json['id'],
      imagePath: json['img'][0]['path'],
      map: json['map'],
    );
  }
}
