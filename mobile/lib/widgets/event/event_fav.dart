import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/listevent/listevent.controller.dart';
import 'package:rimpa/modules/views/home/homedetail/home_detail.dart';
import 'package:rimpa/modules/views/home/seeallcards/home_event_allcard.dart';
import 'package:rimpa/widgets/card/event_card.dart';

class EventFav extends StatelessWidget {
  EventFav({super.key});
  final listEventController = Get.put(ListEventController());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "กิจกรรมที่บันทึก",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(HomeEventAllcard());
                  },
                  child: Row(
                    children: [
                      Text(
                        "ดูทั้งหมด",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        " >",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(8),
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Gap(16),
                  ...listEventController.events.map((event) {
                    return GestureDetector(
                        onTap: () {
                          Get.to(() => HomeDetailPage(event: event));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: EventCard(
                            title: event.title,
                            imageUrl: '${AppApi.urlApi}${event.subEvents[0].imagePath}',
                            onTap: () {},
                          ),
                        )
                        // child: Container(
                        //   width: 150,
                        //   margin: EdgeInsets.only(right: 8),
                        //   child: AppCardComponent(
                        //     child: Column(
                        //       children: [
                        //         AppImageComponent(
                        //           imageType: AppImageType.network,
                        //           imageAddress: '${AppApi.urlApi}${event.subEvents[0].imagePath}',
                        //         ),
                        //         Gap(8),
                        //         Padding(
                        //           padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        //           child: Text(
                        //             event.title,
                        //             style: TextStyle(fontSize: 12),
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        );
                  }).toList(),
                  Gap(16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
