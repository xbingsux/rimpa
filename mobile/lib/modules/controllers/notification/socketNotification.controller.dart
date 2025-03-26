// import 'package:get/get.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

// class SocketNotificationController extends GetxController {
//   final String socketUrl = "https://gocon-api.newdice.co"; // เปลี่ยนเป็น WebSocket จริง
//   late WebSocketChannel channel;

//   var hasNewNotification = false.obs; // ✅ ใช้ RxBool สำหรับอัปเดต Badge

//   @override
//   void onInit() {
//     super.onInit();
//     // connectWebSocket();
//   }

//   void connectWebSocket() {
//     channel = WebSocketChannel.connect(Uri.parse(socketUrl));

//     channel.stream.listen(
//       (message) {
//         print("📩 New Message: $message");

//         // ✅ ตรวจสอบเงื่อนไขว่าข้อความนี้เป็นการแจ้งเตือนใหม่หรือไม่
//         if (message.contains("new_notification")) {
//           hasNewNotification(true); // ✅ อัปเดตให้มีจุดสีแดงที่กระดิ่ง
//         }
//       },
//       onDone: () {
//         print("🔌 WebSocket Disconnected, reconnecting...");
//         Future.delayed(Duration(seconds: 5), () => connectWebSocket()); // ✅ รีเชื่อมต่อเมื่อหลุด
//       },
//       onError: (error) {
//         print("⚠️ WebSocket Error: $error");
//       },
//     );
//   }

//   void clearNotification() {
//     hasNewNotification(false); // ✅ กดปุ่มแล้วซ่อนจุดสีแดง
//   }

//   @override
//   void onClose() {
//     channel.sink.close(status.goingAway);
//     super.onClose();
//   }
// }
