import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rimpa/core/constant/app.constant.dart';
import 'package:rimpa/modules/controllers/listreward/listreward.controller.dart';
import 'package:rimpa/modules/views/home/homedetail/home_detail_reward.dart';

import 'package:rimpa/modules/views/home/seeallcards/home_event_allcard.dart';
import 'package:rimpa/widgets/card/event_card.dart';
import 'package:rimpa/widgets/loginWidget/shimmer_box.dart';

class RewardRecommend extends StatelessWidget {
  RewardRecommend({super.key});
  final listRewardController = Get.put(ListRewardController());

  @override
  Widget build(BuildContext context) {
    listRewardController.fetchRecommendRewards(); //NOTE
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "รางวัลยอดนิยม",
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
          child: Obx(() {
            if (listRewardController.isLoading.value ) {
              return loadingEvent(context: context);
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Gap(16),
                    ...listRewardController.recommendRewards.map((reward) {
                      return GestureDetector(
                        onTap: () {
                          print("Going to reward: ${reward.rewardName}");
                          Get.to(() => HomeDetailReward(reward: reward));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: EventCard(
                            title: reward.rewardName,
                            imageUrl:
                                '${AppApi.urlApi}${reward.img.replaceAll("\\", "/")}',
                            onTap: () =>
                                Get.to(() => HomeDetailReward(reward: reward)),
                          ),
                        ),
                      );
                    }).toList(),
                    Gap(16),
                  ],
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}

Widget loadingEvent({required BuildContext context}) {
  double width = MediaQuery.of(context).size.width - 32 - 8;
  return Column(
    children: [
     
      Row(
        children: [
          Gap(15),
          shimmerBox(width: 150, height: 195),
          Gap(16),
          shimmerBox(width: 150, height: 195),
          Gap(16),
          shimmerBox(width: 150, height: 195),
        ],
      )
    ],
  );
}
