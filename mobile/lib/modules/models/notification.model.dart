class NotificationResponse {
  final String status;
  final List<NotificationItem> noti;

  NotificationResponse({required this.status, required this.noti});

  // ฟังก์ชันแปลง JSON -> Object
  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'],
      noti: (json['noti'] as List).map((item) => NotificationItem.fromJson(item)).toList(),
    );
  }

  // ฟังก์ชันแปลง Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'noti': noti.map((item) => item.toJson()).toList(),
    };
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String? type;
  final bool read;
  final bool delete;
  final DateTime createdAt;
  final String notiRoomId;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    this.type,
    required this.read,
    required this.delete,
    required this.createdAt,
    required this.notiRoomId,
  });

  // ฟังก์ชันแปลง JSON -> Object
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      read: json['read'],
      delete: json['delete'],
      createdAt: DateTime.parse(json['createdAt']),
      notiRoomId: json['noti_roomId'],
    );
  }

  // ฟังก์ชันแปลง Object -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'read': read,
      'delete': delete,
      'createdAt': createdAt,
      'noti_roomId': notiRoomId,
    };
  }
}
