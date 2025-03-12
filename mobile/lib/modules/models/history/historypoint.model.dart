
class HistoryPointModels {
  final int id;
  final String title;
  final String message;
  final String? type;
  final bool read;
  final bool delete;
  final DateTime createdAt;
  final String notiRoomId;

  HistoryPointModels({
    required this.id,
    required this.title,
    required this.message,
    this.type,
    required this.read,
    required this.delete,
    required this.createdAt,
    required this.notiRoomId,
  });

  factory HistoryPointModels.fromJson(Map<String, dynamic> json) {
    return HistoryPointModels(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String?,
      read: json['read'] as bool? ?? false,
      delete: json['delete'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      notiRoomId: json['noti_roomId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'message' : message,
      'type' : type,
      'read' : read,
      'delete' : delete,
      'createdAt' : createdAt,
      'notiRoomId' : notiRoomId
    };
  }
}