import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class TitleOptionForm extends StatelessWidget {
  final Color color;
  final String text;
  final bool isActive;
  final Function onTap;
  const TitleOptionForm(
      {super.key,
      required this.color,
      required this.text,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Row(
          children: [
            paddingHorizontalGlobal(8),
            Icon(
              isActive
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.circle,
              size: 12,
              color: color,
            ),
            paddingHorizontalGlobal(4),
            Text(
              text,
              style: TextStyle(
                  fontSize: 8, fontWeight: FontWeight.bold, color: noir),
            ),
            paddingHorizontalGlobal(8),
          ],
        ),
      ),
    ));
  }
}
