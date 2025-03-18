import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rimpa/components/cards/app-card.component.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final int maxLines;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.title, required this.imageUrl, this.onTap, this.maxLines = 2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: AspectRatio(
        aspectRatio: 2 / 2.6,
        child: InkWell(
          onTap: onTap,
          child: AppCardComponent(
            child: Container(
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppImageComponent(
                    imageType: AppImageType.network,
                    imageAddress: imageUrl,
                  ),
                  Gap(4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      title,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.start,
                      maxLines: maxLines, // จำกัดที่ 2 บรรทัด
                      overflow: TextOverflow.ellipsis, // ถ้าเกิน 2 บรรทัดให้เติม ...
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
