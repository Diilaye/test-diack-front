import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/screen/sondeur/components/menu-textfield.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class EssentielSectionMenu extends StatefulWidget {
  const EssentielSectionMenu({super.key});

  @override
  State<EssentielSectionMenu> createState() => _EssentielSectionMenuState();
}

class _EssentielSectionMenuState extends State<EssentielSectionMenu> {
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
                  "${"é".toUpperCase()}ssentiels",
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
              // MenuTexftField(
              //   text: "Cover",
              //   iconData: "assets/images/image-cover.svg",
              //   color: jaune,
              // ),
              // MenuTexftField(
              //   text: "Logo",
              //   iconData: "assets/images/logo.svg",
              //   color: noir,
              // ),
              MenuTexftField(
                text: "TextField",
                iconData: "assets/images/text-fields.svg",
                color: orange,
                onpress: () async {
                  formulaireSondeur.addChampFormulaire(
                      formulaireSondeur.formulaireSondeurModel!.id!);
                },
              ),
              MenuTexftField(
                text: "TextArea",
                iconData: "assets/images/description.svg",
                color: bleu,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "textArea");
                },
              ),
              MenuTexftField(
                text: "Singleton",
                iconData: "assets/images/cercle.svg",
                color: rouge,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "singleChoice");
                },
              ),
              MenuTexftField(
                text: "Oui/Non",
                iconData: "assets/images/yin-yang.svg",
                color: rouge,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!, "yesno");
                },
              ),
              MenuTexftField(
                text: "Selection multiple",
                iconData: "assets/images/shapes.svg",
                color: vert,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "multiChoice");
                },
              ),
            ],
          )
      ],
    );
  }
}
