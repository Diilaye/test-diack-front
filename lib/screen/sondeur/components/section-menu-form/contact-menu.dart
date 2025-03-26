import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/screen/sondeur/components/menu-textfield.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class ContactSectionMenu extends StatefulWidget {
  const ContactSectionMenu({super.key});

  @override
  State<ContactSectionMenu> createState() => _ContactSectionMenuState();
}

class _ContactSectionMenuState extends State<ContactSectionMenu> {
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
                  "${"c".toUpperCase()}oordonnées",
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
                text: "Nom complet",
                iconData: "assets/images/person.svg",
                color: bleu,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "nomComplet");
                },
              ),
              MenuTexftField(
                text: "Email",
                iconData: "assets/images/email.svg",
                color: jaune,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!, "email");
                },
              ),
              MenuTexftField(
                text: "Addresse",
                iconData: "assets/images/address.svg",
                color: meuveFonce,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "addresse");
                },
              ),
              MenuTexftField(
                text: "Téléphone",
                iconData: "assets/images/telephone.svg",
                color: noir,
                onpress: () async {
                  formulaireSondeur.addChampFormulaireType(
                      formulaireSondeur.formulaireSondeurModel!.id!,
                      "telephone");
                },
              ),
            ],
          )
      ],
    );
  }
}
