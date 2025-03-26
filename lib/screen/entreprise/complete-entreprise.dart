import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/entreprise-bloc.dart';
import 'package:form/screen/entreprise/widget/row-multi-reponse-widget.dart';
import 'package:form/screen/entreprise/widget/texfield-checbox-widget.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';

class CompleteEntreprise extends StatelessWidget {
  const CompleteEntreprise({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final entrepriseBloc = Provider.of<EntrepriseBloc>(context);

    return ListView(
      children: [
        SizedBox(
          height: size.height * .02,
        ),
        Row(
          children: [
            SizedBox(
              width: size.width * .01,
            ),
            const Text(
              "Questionnaire de maturité numérique",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(
          height: size.height * .02,
        ),
        GestureDetector(
          onTap: entrepriseBloc.showThemeatiqueEntreprise == 0
              ? () => entrepriseBloc.setShowThematiqueEntreprise(1)
              : () => entrepriseBloc.setShowThematiqueEntreprise(0),
          child: Container(
            color: bleu.withOpacity(.3),
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .01,
                ),
                const Text(
                  "A quelles thématiques touche votre mission  ?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(entrepriseBloc.showThemeatiqueEntreprise == 0
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down),
                SizedBox(
                  width: size.width * .05,
                ),
              ],
            ),
          ),
        ),
        if (entrepriseBloc.showThemeatiqueEntreprise == 1)
          Column(
            children: [
              TextFieldCheckboxWidget(
                  title: "Banques",
                  choix: 1,
                  isSelectTed: 1 == entrepriseBloc.selectThematiqueEntreprise,
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(1),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "Assurance",
                  isSelectTed: 2 == entrepriseBloc.selectThematiqueEntreprise,
                  choix: 2,
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(2),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "Environnement",
                  choix: 3,
                  isSelectTed: 3 == entrepriseBloc.selectThematiqueEntreprise,
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(3),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 4,
                  isSelectTed: 4 == entrepriseBloc.selectThematiqueEntreprise,
                  title: "Energie",
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(4),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 5,
                  isSelectTed: 5 == entrepriseBloc.selectThematiqueEntreprise,
                  title: "Commerce",
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(5),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 6,
                  isSelectTed: 6 == entrepriseBloc.selectThematiqueEntreprise,
                  title: "Santé",
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(6),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 7,
                  isSelectTed: 7 == entrepriseBloc.selectThematiqueEntreprise,
                  title: "Education",
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(7),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 8,
                  isSelectTed: 8 == entrepriseBloc.selectThematiqueEntreprise,
                  title: "Agro-industries",
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(8),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 9,
                  isSelectTed: 9 == entrepriseBloc.selectThematiqueEntreprise,
                  title: "Autres",
                  onSelect: () =>
                      entrepriseBloc.setSelectedThematiqueEntreprise(9),
                  haveTextField: entrepriseBloc.selectThematiqueEntreprise == 9,
                  onChange: (v) =>
                      entrepriseBloc.setReponseAutreThematiqueEntreprise(v)),
            ],
          ),
        SizedBox(
          height: size.height * .02,
        ),
        GestureDetector(
          onTap: entrepriseBloc.showCibleEntreprise == 0
              ? () => entrepriseBloc.setShowCibleEntreprise(1)
              : () => entrepriseBloc.setShowCibleEntreprise(0),
          child: Container(
            color: bleu.withOpacity(.3),
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .01,
                ),
                const Text(
                  "Quels sont les publics cibles en lien avec votre mission ?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(entrepriseBloc.showCibleEntreprise == 0
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down),
                SizedBox(
                  width: size.width * .05,
                ),
              ],
            ),
          ),
        ),
        if (entrepriseBloc.showCibleEntreprise == 1)
          Column(
            children: [
              TextFieldCheckboxWidget(
                  title: "le grand public",
                  choix: 1,
                  isSelectTed: 1 == entrepriseBloc.selectCibleEntreprise,
                  onSelect: () => entrepriseBloc.setSelectedCibleEntreprise(1),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "Organisations",
                  choix: 2,
                  isSelectTed: 2 == entrepriseBloc.selectCibleEntreprise,
                  onSelect: () => entrepriseBloc.setSelectedCibleEntreprise(2),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "Acteurs intitutionnels",
                  choix: 3,
                  isSelectTed: 3 == entrepriseBloc.selectCibleEntreprise,
                  onSelect: () => entrepriseBloc.setSelectedCibleEntreprise(3),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 4,
                  title: "entreprises ",
                  isSelectTed: 4 == entrepriseBloc.selectCibleEntreprise,
                  onSelect: () => entrepriseBloc.setSelectedCibleEntreprise(4),
                  onChange: () => null),
            ],
          ),
        SizedBox(
          height: size.height * .02,
        ),
        GestureDetector(
          onTap: entrepriseBloc.showSectionSalaire == 0
              ? () => entrepriseBloc.setShowSectionSalaire(1)
              : () => entrepriseBloc.setShowSectionSalaire(0),
          child: Container(
            color: bleu.withOpacity(.3),
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .01,
                ),
                const Text(
                  "Combien de salariés avez-vous?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(entrepriseBloc.showSectionSalaire == 0
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down),
                SizedBox(
                  width: size.width * .05,
                ),
              ],
            ),
          ),
        ),
        if (entrepriseBloc.showSectionSalaire == 1)
          Column(
            children: [
              TextFieldCheckboxWidget(
                  title: "femmes",
                  choix: 1,
                  haveTextField: 1 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 1 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(1),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "hommes",
                  choix: 2,
                  haveTextField: 2 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 2 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(2),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "Avez vous une DSI?",
                  choix: 3,
                  haveTextField: 3 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 3 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(3),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 4,
                  title: "Si oui, est internalisée ou externalisée ",
                  haveTextField: 4 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 4 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(4),
                  onChange: () => null),
            ],
          ),
        SizedBox(
          height: size.height * .02,
        ),
        GestureDetector(
          onTap: entrepriseBloc.showSectionSalaire == 0
              ? () => entrepriseBloc.setShowSectionSalaire(1)
              : () => entrepriseBloc.setShowSectionSalaire(0),
          child: Container(
            color: bleu.withOpacity(.3),
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .01,
                ),
                const Text(
                  "Combien de salariés avez-vous?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(entrepriseBloc.showSectionSalaire == 0
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down),
                SizedBox(
                  width: size.width * .05,
                ),
              ],
            ),
          ),
        ),
        if (entrepriseBloc.showSectionSalaire == 1)
          Column(
            children: [
              TextFieldCheckboxWidget(
                  title: "femmes",
                  choix: 1,
                  haveTextField: 1 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 1 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(1),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "hommes",
                  choix: 2,
                  haveTextField: 2 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 2 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(2),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  title: "Avez vous une DSI?",
                  choix: 3,
                  haveTextField: 3 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 3 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(3),
                  onChange: () => null),
              TextFieldCheckboxWidget(
                  choix: 4,
                  title: "Si oui, est internalisée ou externalisée ",
                  haveTextField: 4 == entrepriseBloc.sectionSalaire,
                  isSelectTed: 4 == entrepriseBloc.sectionSalaire,
                  onSelect: () => entrepriseBloc.setSectionSalaire(4),
                  onChange: () => null),
            ],
          ),
        SizedBox(
          height: size.height * .02,
        ),
        GestureDetector(
          onTap: entrepriseBloc.showSectionOutilsNumerique == 0
              ? () => entrepriseBloc.setShowSectionOutilsNumerique(1)
              : () => entrepriseBloc.setShowSectionOutilsNumerique(0),
          child: Container(
            color: vert.withOpacity(.3),
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * .01,
                ),
                const Text(
                  "Utilisez-vous des outils numériques dans vos relations avec vos clients/partenaires ?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(entrepriseBloc.showSectionOutilsNumerique == 0
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down),
                SizedBox(
                  width: size.width * .05,
                ),
              ],
            ),
          ),
        ),
        if (entrepriseBloc.showSectionOutilsNumerique == 1)
          Column(
            children: [
              RowMultiReponseWidget(
                title: "Mails",
                titleObject: "Outils",
                listeReponse: [
                  "Jamais",
                  "Moins d'une fois par mois",
                  "Plusieurs fois par mois",
                  "Toutes les semaines"
                ],
                nombreReponse: 4,
                ontap: () => null,
              )
            ],
          ),
      ],
    );
  }
}
