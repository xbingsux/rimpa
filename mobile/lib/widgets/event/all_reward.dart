import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/listreward/listreward.controller.dart';
import 'package:rimpa/modules/models/listreward.model.dart'; // ใช้ ListReward แทน ListEvent
import 'package:rimpa/modules/views/home/homedetail/home_detail_reward.dart';
import 'package:rimpa/widgets/card/event_card.dart';
import 'package:rimpa/widgets/loginWidget/shimmer_box.dart';

class AllReward extends StatefulWidget {
  final bool showTitle;
  final bool isScroll;
  final double? screenHigh;
  const AllReward({super.key, this.showTitle = true, this.isScroll = false, this.screenHigh});

  @override
  State<AllReward> createState() => _AllEventsState();
}

class _AllEventsState extends State<AllReward> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final listRewardController = Get.put(ListRewardController());
  bool isDesc = true;

  @override
  void initState() {
    super.initState();
    listRewardController.fetchRewards();
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
      if (listRewardController.isLoading.value) {
        return loadingEvent(context: context);
      } else {
        // รับข้อมูลรางวัลจาก listRewardController
        List<ListReward> sortedRewards = listRewardController.rewards.toList();

        // การเรียงลำดับรางวัล
        if (isDesc) {
          sortedRewards.sort((a, b) => b.id.compareTo(a.id));
        } else {
          sortedRewards.sort((a, b) => a.id.compareTo(b.id));
        }

        return Column(
          children: [
            Row(
              children: [
                if (widget.showTitle)
                  Expanded(
                    child: Text(
                      "รีวอร์ดทั้งหมด",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            if (widget.isScroll)
              SizedBox(
                height: widget.screenHigh,
                child: SingleChildScrollView(
                  child: dataList(sortedRewards),
                ),
              ),
            if (!(widget.isScroll)) dataList(sortedRewards),
          ],
        );
      }
    });
  }

  Widget dataList(sortedRewards) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2 / 2.5,
      ),
      padding: EdgeInsets.zero,
      itemCount: sortedRewards.length,
      itemBuilder: (context, index) {
        var reward = sortedRewards[index];
        return EventCard(
          title: reward.rewardName, // ใช้ชื่อรางวัล
          imageUrl: '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}', // ใช้ image path ของรางวัล
          onTap: () {
            Get.to(() => HomeDetailReward(reward: reward)); // ไปที่หน้ารายละเอียดของรางวัล
          },
          maxLines: 2,
        );
      },
    );
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
      Row(
        children: [
          shimmerBox(width: width / 2, height: 200),
          Gap(8),
          shimmerBox(width: width / 2, height: 200),
        ],
      ),
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
