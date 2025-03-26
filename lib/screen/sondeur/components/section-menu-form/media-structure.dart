import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/screen/sondeur/components/menu-textfield.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class MediaStructureSectionMenu extends StatefulWidget {
  const MediaStructureSectionMenu({super.key});

  @override
  State<MediaStructureSectionMenu> createState() =>
      _MediaStructureSectionMenuState();
}

class _MediaStructureSectionMenuState extends State<MediaStructureSectionMenu> {
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
                  "${"M".toUpperCase()}édia & Structure",
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
                text: "Séparateur",
                iconData: "assets/images/separator.svg",
                color: jaune,
                onpress: () async {
                  formulaireSondeur.addChampFormulaire(
                      formulaireSondeur.formulaireSondeurModel!.id!);

                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "separator");
                },
              ),
              MenuTexftField(
                text: "Séparateur avec Titre",
                iconData: "assets/images/separator.svg",
                color: jaune,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "separator-title");
                },
              ),
              MenuTexftField(
                text: "Explication",
                iconData: "assets/images/description.svg",
                color: vertFonce,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "explication");
                },
              ),
            ],
          )
      ],
    );
  }
}
