class ListBanner {
  final int id;
  final String title;
  final String description;
  final String path;
  final DateTime startDate;
  final DateTime endDate;

  ListBanner({
    required this.id,
    required this.title,
    required this.description,
    required this.path,
    required this.startDate,
    required this.endDate,
  });

  factory ListBanner.fromJson(Map<String, dynamic> json) {
    return ListBanner(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      path: json['path'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
