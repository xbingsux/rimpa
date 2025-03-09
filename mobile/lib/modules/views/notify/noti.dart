// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// // class NotificationController extends GetxController {
// //   var notifications = <String>[].obs;

// //   void addNotification(String message) {
// //     notifications.add(message);
// //   }

// //   void clearNotifications() {
// //     notifications.clear();
// //   }
// // }

// class NotificationScreen extends StatelessWidget {
//   // final NotificationController controller = Get.put(NotificationController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('การแจ้งเตือน', style: TextStyle(color: Colors.blue)),
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: Colors.blue),
//         elevation: 0,
//       ),
//       body: Obx(() => controller.notifications.isEmpty ? _buildEmptyState() : _buildNotificationList()),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           controller.addNotification("Lorem Ipsum: แจ้งเตือนใหม่");
//         },
//         child: Icon(Icons.add_alert),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.notifications_off, size: 50, color: Colors.blue),
//           SizedBox(height: 10),
//           Text("ยังไม่มีการแจ้งเตือน", style: TextStyle(fontSize: 18)),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationList() {
//     return ListView.builder(
//       padding: EdgeInsets.all(10),
//       itemCount: controller.notifications.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.only(bottom: 10),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.blue.shade50,
//                 child: Icon(Icons.notifications, color: Colors.blue),
//               ),
//               SizedBox(width: 10),
//               Expanded(
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(color: Colors.grey.shade300),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Lorem Ipsum",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                       SizedBox(height: 5),
//                       Text(
//                         "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       SizedBox(height: 5),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Text(
//                           "วันนี้ 12:00",
//                           style: TextStyle(color: Colors.grey, fontSize: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
