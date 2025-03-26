import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/screen/administrateur/formulaire/widget/fields-menu-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/text-field-setting-widget.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class OneMenuForm extends StatelessWidget {
  const OneMenuForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formulaireBloc = Provider.of<FormulaireBloc>(context);

    return Column(
      children: [
        paddingVerticalGlobal(16),
        Row(
          children: [
            paddingHorizontalGlobal(8),
            Text(
              'Standard',
              style: TextStyle(fontWeight: FontWeight.bold, color: noir),
            ),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
              title: "Texte",
              icon: Icons.abc,
              ontap: () => formulaireBloc.addFormChild({
                "widget": "texte",
                "titre": "Titre du champs",
                "reponse": "",
                "logique-attendu": "",
                "index": formulaireBloc.indexFromChild,
                "monde": true,
              }),
            ),
            FieldMenuWidget(
              title: "Nombre",
              icon: Icons.numbers,
              ontap: () => null,
            ),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
                title: "Paragraphe",
                icon: Icons.pages_sharp,
                ontap: () => null),
            FieldMenuWidget(
                title: "CheckBox", icon: Icons.check_box, ontap: () => null),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
                title: "Multiple choix", icon: Icons.circle, ontap: () => null),
            FieldMenuWidget(
                title: "Dropdown",
                icon: Icons.arrow_drop_down,
                ontap: () => null),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
                title: "section break",
                icon: Icons.circle,
                isSection: true,
                color: vert.withOpacity(.3),
                ontap: () => null),
          ],
        ),
        paddingVerticalGlobal(48),
        Row(
          children: [
            paddingHorizontalGlobal(8),
            Text(
              'Avacées',
              style: TextStyle(fontWeight: FontWeight.bold, color: noir),
            ),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
                title: "Nom complet", icon: Icons.abc, ontap: () => null),
            FieldMenuWidget(
                title: "uploader file",
                icon: Icons.file_download,
                ontap: () => null),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
              title: "Addresse",
              icon: Icons.web_rounded,
              ontap: () => null,
            ),
            FieldMenuWidget(
              title: "Date",
              icon: Icons.calendar_month,
              ontap: () => null,
            ),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
              title: "Email",
              icon: Icons.email,
              ontap: () => null,
            ),
            FieldMenuWidget(
              title: "Heure",
              icon: Icons.timer,
              ontap: () => null,
            ),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
              title: "Téléphone",
              icon: Icons.phone,
              ontap: () => null,
            ),
            FieldMenuWidget(
              title: "Prix",
              icon: Icons.price_change,
              ontap: () => null,
            ),
          ],
        ),
        paddingVerticalGlobal(),
        Row(
          children: [
            FieldMenuWidget(
              title: "notation ",
              icon: Icons.star,
              isSection: false,
              ontap: () => null,
            ),
          ],
        ),
      ],
    );
  }
}
