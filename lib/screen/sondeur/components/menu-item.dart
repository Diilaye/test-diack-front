import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';

class MenuItem extends StatelessWidget {
  final String titre;
  final IconData icons;
  final int showbadge;
  final String badge;
  final double radius;
  final Color color;
  final bool hover;
  final Function onHover;
  final Function onOutHover;

  const MenuItem({
    super.key,
    required this.titre,
    required this.icons,
    required this.color,
    required this.onHover,
    required this.onOutHover,
    this.showbadge = 0,
    this.radius = 2,
    this.badge = "",
    showBadge = 0,
    this.hover = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => onHover(),
      onExit: (event) => onOutHover(),
      child: Container(
        height: 58,
        color: hover ? gris : blanc,
        child: Row(
          children: [
            paddingHorizontalGlobal(8),
            Icon(
              icons,
              size: 18,
            ),
            paddingHorizontalGlobal(8),
            Text(
              titre.toUpperCase(),
              style: TextStyle(
                color: noir,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            if (showbadge == 1)
              Container(
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(2)),
                child: Row(
                  children: [
                    paddingHorizontalGlobal(4),
                    Text(
                      badge,
                      style: TextStyle(
                        color: blanc,
                        fontSize: 12,
                      ),
                    ),
                    paddingHorizontalGlobal(4),
                  ],
                ),
              ),
            paddingHorizontalGlobal(8),
          ],
        ),
      ),
    );
  }
}
