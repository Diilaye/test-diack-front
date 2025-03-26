import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/screen/sondeur/components/menu-textfield.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class TelechargementSectionMenu extends StatefulWidget {
  const TelechargementSectionMenu({super.key});

  @override
  State<TelechargementSectionMenu> createState() =>
      _TelechargementSectionMenuState();
}

class _TelechargementSectionMenuState extends State<TelechargementSectionMenu> {
  bool isOpen = true;
  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() {
            isOpen = !isOpen;
          }),
          child: Container(
            height: 40,
            color: gris,
            child: Row(
              children: [
                paddingHorizontalGlobal(8),
                Text(
                  "${"T".toUpperCase()}éléchargements",
                  style: TextStyle(
                      color: noir,
                      fontSize: 14,
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(
                  isOpen
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 12,
                ),
                paddingHorizontalGlobal(8),
              ],
            ),
          ),
        ),
        if (isOpen)
          Column(
            children: [
              MenuTexftField(
                text: "Image",
                iconData: "assets/images/image-plus.svg",
                color: vertFonce,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!, "image");
                },
              ),
              MenuTexftField(
                text: "Fichier",
                iconData: "assets/images/file-plus.svg",
                color: rouge,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!, "file");
                },
              ),
            ],
          )
      ],
    );
  }
}
