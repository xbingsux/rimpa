import 'package:flutter/material.dart';

class AppDropdownV2Component extends StatelessWidget {
  final List<String> choices;
  final String selected;
  final Function onchanged;
  const AppDropdownV2Component({super.key, required this.choices, required this.selected, required this.onchanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => onchanged(value),
      itemBuilder: (BuildContext context) => choices.map((item) => PopupMenuItem(
        value: item,
        child: Text(item)
      )).toList()
    );
  }
}