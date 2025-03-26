import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class MenuTexftField extends StatelessWidget {
  final String text;
  final String iconData;
  final Color color;
  final Function onpress;
  const MenuTexftField(
      {super.key,
      required this.text,
      required this.iconData,
      required this.color,
      required this.onpress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onpress(),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: .2, color: noir))),
        child: Row(
          children: [
            paddingHorizontalGlobal(),
            SvgPicture.asset(
              iconData,
              color: color,
              width: 18,
            ),
            paddingHorizontalGlobal(),
            Text(
              text,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: noir),
            )
          ],
        ),
      ),
    );
  }
}
