class Event {
  final int id;
  final String title;
  final String description;
  final List<SubEvent> subEvents;

  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.subEvents});

  factory Event.fromJson(Map<String, dynamic> json) {
    var list = json['sub_event'] as List;
    List<SubEvent> subEventList =
        list.map((i) => SubEvent.fromJson(i)).toList();

    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subEvents: subEventList,
    );
  }
}

class SubEvent {
  final int id;
  final String imagePath;

  SubEvent({required this.id, required this.imagePath});

  factory SubEvent.fromJson(Map<String, dynamic> json) {
    return SubEvent(
      id: json['id'],
      imagePath: json['img'][0]['path'],
    );
  }
}
