import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/components/cards/app-card.component.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/listevent/listevent.controller.dart';
import 'package:rimpa/modules/models/listevent.model.dart';
import 'package:rimpa/modules/views/home/homedetail/home_detail.dart';
import 'package:rimpa/widgets/button/sort_button.dart';
import 'package:rimpa/widgets/loginWidget/shimmer_box.dart';

class AllEvents extends StatefulWidget {
  final showTitle;
  AllEvents({super.key, this.showTitle = true});
  // Add this line

  @override
  State<AllEvents> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllEvents> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final listEventController = Get.put(ListEventController());
  bool isDesc = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (listEventController.isLoading.value) {
        return loadingEvent(context: context);
      } else {
        List<ListEvent> sortedEvents = listEventController.events.toList();
        if (isDesc) {
          sortedEvents.sort((a, b) => b.id.compareTo(a.id));
        } else {
          sortedEvents.sort((a, b) => a.id.compareTo(b.id));
        }
        return Column(
          children: [
            Row(
              children: [
                if (widget.showTitle)
                  Expanded(
                    child: Text(
                      "กิจกรรมทั้งหมด",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                SortButton(
                  isDesc: isDesc,
                  onChanged: (value) {
                    setState(() {
                      isDesc = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2 / 3,
              ),
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                var event = sortedEvents[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => HomeDetailPage(event: event));
                  },
                  child: AppCardComponent(
                    child: Column(
                      children: [
                        AppImageComponent(
                          imageType: AppImageType.network,
                          imageAddress: '${AppApi.urlApi}${event.subEvents[0].imagePath}',
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            event.title,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }
    });
  }
}

Widget loadingEvent({required BuildContext context}) {
  double width = MediaQuery.of(context).size.width - 32 - 8;
  return Column(
    children: [
      Align(alignment: Alignment.centerLeft, child: shimmerBox(width: 100, height: 32)),
      Gap(8),
      Row(
        children: [
          shimmerBox(width: width / 2, height: 200),
          Gap(8),
          shimmerBox(width: width / 2, height: 200),
        ],
      ),
    ],
  );
}
