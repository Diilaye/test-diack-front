import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class TextFieldSettingWidget extends StatelessWidget {
  final String title;
  final Function onChanged;
  final double fontSize;
  const TextFieldSettingWidget(
      {super.key,
      required this.title,
      required this.onChanged,
      this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            paddingHorizontalGlobal(8),
            Text(title,
                style: TextStyle(
                    fontSize: fontSize,
                    color: noir,
                    fontWeight: FontWeight.bold))
          ],
        ),
        Row(
          children: [
            paddingHorizontalGlobal(8),
            Expanded(
                child: TextField(
              onChanged: (value) => onChanged(value),
              style: TextStyle(
                  fontSize: fontSize, color: noir, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(),
            )),
            paddingHorizontalGlobal(8),
          ],
        ),
      ],
    );
  }
}
