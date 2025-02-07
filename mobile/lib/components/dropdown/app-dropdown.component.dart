import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AppDropdown extends StatelessWidget {
  final Function(String data) onChanged;
  final List<String> choices;
  final String active;
  final Border border;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final double width; // Add this property
  final double height; // Add this property

  const AppDropdown({
    super.key,
    required this.onChanged,
    required this.choices,
    required this.active,
    this.border = const Border.fromBorderSide(
        BorderSide(width: 1, color: AppColors.dark)),
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.sm)),
    this.backgroundColor = AppColors.background_main,
    this.textColor = AppTextColors.primary,
    this.width = 98, // Default width
    this.height = 32, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xs)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: choices.map((choice) {
                  return ListTile(
                    title: Text(choice,
                        style: TextStyle(
                          fontSize: AppTextSize.md,
                        )),
                    onTap: () {
                      onChanged(choice);
                      Navigator.pop(context); // ปิด Popup หลังจากเลือกค่า
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
      child: Container(
        width: width, // Set width
        height: height, // Set height
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, 
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(active,
                style: TextStyle(
                  fontSize: AppTextSize.md,
                )),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: AppTextSize.lg,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: AppTextSize.lg,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
