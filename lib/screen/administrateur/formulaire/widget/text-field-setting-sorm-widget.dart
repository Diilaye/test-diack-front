import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class TextFieldSettingFormWidget extends StatelessWidget {
  final String title;
  final TextEditingController value;
  final Function onChanged;
  final double fontSize;
  final int maxLine;
  const TextFieldSettingFormWidget(
      {super.key,
      required this.title,
      required this.onChanged,
      this.fontSize = 14,
      this.maxLine = 4,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        paddingHorizontalGlobal(8),
        Expanded(
            child: TextField(
          onChanged: (value) => onChanged(value),
          maxLines: maxLine,
          controller: value,
          style: TextStyle(
              fontSize: fontSize, color: noir, fontWeight: FontWeight.bold),
          decoration:
              InputDecoration(labelText: title, border: OutlineInputBorder()),
        )),
        paddingHorizontalGlobal(8),
      ],
    );
  }
}
