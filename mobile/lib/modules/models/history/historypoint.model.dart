class HistoryPointModel {
  final int id;
  final String type;
  final String points;
  final String description;
  final int profileId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool active;

  HistoryPointModel({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.profileId,
    required this.createdAt,
    required this.updatedAt,
    required this.active,
  });

  factory HistoryPointModel.fromJson(Map<String, dynamic> json) {
    return HistoryPointModel(
      id: json['id'] as int,
      type: json['type'] as String,
      points: json['points'] as String,
      description: json['description'] as String,
      profileId: json['profileId'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'points': points,
      'description': description,
      'profileId': profileId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'active': active,
    };
  }
}