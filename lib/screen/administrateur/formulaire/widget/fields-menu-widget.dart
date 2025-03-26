import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/utils/widget/padding-global.dart';

class FieldMenuWidget extends StatelessWidget {
  final String title;

  final IconData icon;

  final bool isSection;

  final Color color;

  final Function ontap;

  const FieldMenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      this.isSection = false,
      required this.ontap,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => ontap(),
          child: Row(
            children: [
              paddingHorizontalGlobal(8),
              Expanded(
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: color),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSection == false)
                        Icon(
                          icon,
                          size: 14,
                        ),
                      paddingHorizontalGlobal(6),
                      Text(title),
                    ],
                  ),
                ),
              ),
              paddingHorizontalGlobal(8),
            ],
          ),
        ),
      ),
    );
  }
}
