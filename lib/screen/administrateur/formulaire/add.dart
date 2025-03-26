import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/screen/administrateur/formulaire/menu-form/one.dart';
import 'package:form/screen/administrateur/formulaire/menu-form/three.dart';
import 'package:form/screen/administrateur/formulaire/menu-form/two.dart';
import 'package:form/screen/administrateur/formulaire/widget/form-settings-top.dart';
import 'package:form/screen/administrateur/formulaire/widget/menu-form.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class AddFormulaireScreen extends StatelessWidget {
  const AddFormulaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireBloc = Provider.of<FormulaireBloc>(context);

    return Column(
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
              'Ajouter Formulaire',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: size.height * .02,
        ),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 4,
              ),
              Expanded(
                  child: Column(
                children: [
                  Container(
                    height: 40,
                    // color: jaune.withOpacity(.8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 4,
                        ),
                        MenuFormulaireWidget(
                          title: "Ajouter champs",
                          isActif: formulaireBloc.menuForm == 0,
                          menu: 0,
                          color: jaune,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        MenuFormulaireWidget(
                          title: "Parametre champs",
                          isActif: formulaireBloc.menuForm == 1,
                          color: meuveFonce,
                          menu: 1,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        MenuFormulaireWidget(
                          title: "Parametre Form",
                          isActif: formulaireBloc.menuForm == 2,
                          color: vert,
                          menu: 2,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: formulaireBloc.menuForm == 0
                        ? jaune.withOpacity(.4)
                        : formulaireBloc.menuForm == 1
                            ? meuveFonce.withOpacity(.4)
                            : bleu.withOpacity(.4),
                    child: formulaireBloc.menuForm == 0
                        ? const OneMenuForm()
                        : formulaireBloc.menuForm == 1
                            ? const TwoMenuForm()
                            : const ThreeMenuForm(),
                  ))
                ],
              )),
              SizedBox(
                width: 4,
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * .05,
                      ),
                      const FormSettingTop(),
                      paddingVerticalGlobal(),
                      Expanded(
                        child: ListView(
                          children: formulaireBloc.formChild
                              .map((e) => e['widget'] == 'texte'
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () =>
                                              formulaireBloc.setChildForm({}),
                                          child: Container(
                                            height: 45,
                                            color: blanc,
                                            child: Column(
                                              children: [
                                                paddingVerticalGlobal(8),
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    paddingHorizontalGlobal(),
                                                    e['crypte'] != null
                                                        ? Icon(
                                                            Icons.security,
                                                            size: 12,
                                                          )
                                                        : Text(''),
                                                    paddingHorizontalGlobal(4),
                                                    Text(e['titre']),
                                                    paddingHorizontalGlobal(4),
                                                    e['requis'] != null
                                                        ? Icon(
                                                            Icons.star,
                                                            size: 12,
                                                          )
                                                        : Text(''),
                                                    paddingHorizontalGlobal(),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        height: 45,
                                                        color: gris,
                                                        child: Row(
                                                          children: [
                                                            paddingHorizontalGlobal(
                                                                4),
                                                            e['placeholder'] !=
                                                                        null &&
                                                                    e['valeur_predefini'] ==
                                                                        null
                                                                ? Text(e[
                                                                    'placeholder'])
                                                                : e['valeur_predefini'] !=
                                                                        null
                                                                    ? Text(e[
                                                                        'valeur_predefini'])
                                                                    : Text(''),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    paddingHorizontalGlobal(),
                                                    paddingHorizontalGlobal(),
                                                  ],
                                                )),
                                                paddingVerticalGlobal(8),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox())
                              .toList(),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                width: 4,
              ),
            ],
          ),
        )
      ],
    );
  }
}
