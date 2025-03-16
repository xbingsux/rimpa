import 'package:flutter/material.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AppDropdownV2Component extends StatelessWidget {
  final List<String> choices;
  final String? selected;
  final Function onchanged;
  final String defaultText;
  const AppDropdownV2Component({super.key, required this.choices, required this.selected, required this.onchanged, required this.defaultText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xs)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: choices.map((choice) {
                  return ListTile(
                    title: Text(
                      choice,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: AppTextSize.md,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    onTap: () {
                      onchanged(choice);
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
        child: Text(
          (selected == null || selected!.isEmpty) ? defaultText : selected!,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: AppTextSize.md,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
