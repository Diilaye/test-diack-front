import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';

class MenuFormulaireWidget extends StatelessWidget {
  final String title;
  final bool isActif;
  final Color color;
  final int menu;
  const MenuFormulaireWidget(
      {super.key,
      required this.title,
      required this.isActif,
      required this.color,
      required this.menu});

  @override
  Widget build(BuildContext context) {
    final formulaireBloc = Provider.of<FormulaireBloc>(context);

    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => formulaireBloc.setMenuForm(menu),
          child: Container(
              height: 36,
              decoration: BoxDecoration(
                  color: isActif ? color.withOpacity(.4) : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatedBox(
                    quarterTurns: isActif ? 2 : 1,
                    child: Icon(
                      CupertinoIcons.triangle_fill,
                      color: noir.withOpacity(.4),
                      size: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 10, color: noir, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}
