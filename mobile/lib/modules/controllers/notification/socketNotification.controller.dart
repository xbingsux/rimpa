import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketNotificationController extends GetxController {
  final String socketUrl = "ws://api-rimpa.nightbears.co/socket.io"; // ✅ เปลี่ยนเป็น URL จริง
  late IO.Socket socket;
  final String roomId = "LFAHPcCm-YqlvZHpAAAC"; // ✅ กำหนด Room ID

  var hasNewNotification = false.obs; // ✅ ใช้ RxBool สำหรับแสดงจุดสีแดง
  var notifications = <Map<String, dynamic>>[].obs; // ✅ เก็บรายการ Notification

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();
  }

  void connectWebSocket() {
    socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'], // ✅ ใช้ WebSocket เท่านั้น
      'autoConnect': false,
      'forceNew': true, // ✅ ป้องกันปัญหาการใช้ Connection เดิม
    });

    socket.connect();

    socket.onConnect((_) {
      print("✅ Connected to WebSocket");
      joinRoom(roomId); // ✅ เข้าร่วมห้องเมื่อเชื่อมต่อสำเร็จ
    });

    // ✅ รับข้อความจากห้อง
    socket.on("room_notification", (data) {
      print("📩 New Notification: $data");
      notifications.insert(0, data); // ✅ เพิ่ม Notification ใหม่ที่ด้านบน
      hasNewNotification(true); // ✅ แสดงจุดสีแดงที่กระดิ่ง
    });

    socket.onDisconnect((_) {
      print("🔌 Disconnected, reconnecting...");
      Future.delayed(Duration(seconds: 5), () => connectWebSocket()); // ✅ รีเชื่อมต่อเมื่อหลุด
    });

    socket.onError((error) {
      print("⚠️ WebSocket Error: $error");
    });
  }

  void joinRoom(String room) {
    socket.emit('join room', room);
    print("📌 Joined Room: $room");
  }

  void clearNotification() {
    hasNewNotification(false); // ✅ ซ่อนจุดสีแดงเมื่อกดปุ่ม
  }

  @override
  void onClose() {
    socket.disconnect();
    super.onClose();
  }
}
