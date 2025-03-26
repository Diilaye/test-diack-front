import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/screen/administrateur/formulaire/widget/fields-menu-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/text-field-setting-sorm-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/text-field-setting-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/title-option-form.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class TwoMenuForm extends StatelessWidget {
  const TwoMenuForm({super.key});

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
              'Parametre champ',
              style: TextStyle(fontWeight: FontWeight.bold, color: noir),
            ),
          ],
        ),
        paddingVerticalGlobal(),
        TextFieldSettingWidget(
            title: "Titre du champ",
            onChanged: (v) => formulaireBloc.updateFielForm("titre", v)),
        paddingVerticalGlobal(),
        SizedBox(
          height: 100,
          child: Row(
            children: [
              paddingHorizontalGlobal(8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(8),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: noir.withOpacity(.7),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                )),
                            child: Center(
                              child: Text(
                                'Options champ',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: blanc,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            paddingHorizontalGlobal(8),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: noir.withOpacity(.7),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    )),
                                child: Column(
                                  children: [
                                    paddingVerticalGlobal(8),
                                    GestureDetector(
                                      onTap: () => formulaireBloc
                                          .updateFielForm('requis', true),
                                      child: Row(
                                        children: [
                                          paddingHorizontalGlobal(8),
                                          formulaireBloc.childForm['requis'] ==
                                                  true
                                              ? Icon(
                                                  CupertinoIcons
                                                      .checkmark_square,
                                                  color: blanc,
                                                  size: 18,
                                                )
                                              : Icon(
                                                  CupertinoIcons.square,
                                                  color: blanc,
                                                  size: 18,
                                                ),
                                          paddingHorizontalGlobal(8),
                                          Text(
                                            "Requis *",
                                            style: TextStyle(color: blanc),
                                          )
                                        ],
                                      ),
                                    ),
                                    paddingVerticalGlobal(8),
                                    GestureDetector(
                                      onTap: () => formulaireBloc
                                          .updateFielForm('crypte', true),
                                      child: Row(
                                        children: [
                                          paddingHorizontalGlobal(8),
                                          formulaireBloc.childForm['crypte'] ==
                                                  true
                                              ? Icon(
                                                  CupertinoIcons
                                                      .checkmark_square,
                                                  color: blanc,
                                                  size: 18,
                                                )
                                              : Icon(
                                                  CupertinoIcons.square,
                                                  color: blanc,
                                                  size: 18,
                                                ),
                                          paddingHorizontalGlobal(8),
                                          Text(
                                            "Crypté *",
                                            style: TextStyle(color: blanc),
                                          )
                                        ],
                                      ),
                                    ),
                                    paddingVerticalGlobal(8),
                                    // GestureDetector(
                                    //   onTap: () => formulaireBloc
                                    //       .updateFielForm('doublons', true),
                                    //   child: Row(
                                    //     children: [
                                    //       paddingHorizontalGlobal(8),
                                    //       formulaireBloc
                                    //                   .childForm['doublons'] ==
                                    //               true
                                    //           ? Icon(
                                    //               CupertinoIcons
                                    //                   .checkmark_square,
                                    //               color: blanc,
                                    //               size: 18,
                                    //             )
                                    //           : Icon(
                                    //               CupertinoIcons.square,
                                    //               color: blanc,
                                    //               size: 18,
                                    //             ),
                                    //       paddingHorizontalGlobal(8),
                                    //       Text(
                                    //         "Pas de doublons",
                                    //         style: TextStyle(color: blanc),
                                    //       )
                                    //     ],
                                    //   ),
                                    //),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              paddingHorizontalGlobal(8),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(8),
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                color: noir.withOpacity(.7),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                )),
                            child: Center(
                              child: Text(
                                'Afficher le champ à',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: blanc,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            paddingHorizontalGlobal(8),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: noir.withOpacity(.7),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    )),
                                child: Column(
                                  children: [
                                    paddingVerticalGlobal(8),
                                    GestureDetector(
                                      onTap: () => formulaireBloc
                                          .updateFielForm('monde', true),
                                      child: Row(
                                        children: [
                                          paddingHorizontalGlobal(8),
                                          formulaireBloc.childForm['monde'] ==
                                                  true
                                              ? Icon(
                                                  CupertinoIcons
                                                      .checkmark_square,
                                                  color: blanc,
                                                  size: 18,
                                                )
                                              : Icon(
                                                  CupertinoIcons.square,
                                                  color: blanc,
                                                  size: 18,
                                                ),
                                          paddingHorizontalGlobal(4),
                                          Expanded(
                                            child: Text(
                                              "Tout le monde",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: blanc,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    paddingVerticalGlobal(8),
                                    GestureDetector(
                                      onTap: () => formulaireBloc
                                          .updateFielForm('admin_unique', true),
                                      child: Row(
                                        children: [
                                          paddingHorizontalGlobal(8),
                                          formulaireBloc.childForm[
                                                      'admin_unique'] ==
                                                  true
                                              ? Icon(
                                                  CupertinoIcons
                                                      .checkmark_square,
                                                  color: blanc,
                                                  size: 18,
                                                )
                                              : Icon(
                                                  CupertinoIcons.square,
                                                  color: blanc,
                                                  size: 18,
                                                ),
                                          paddingHorizontalGlobal(4),
                                          Expanded(
                                            child: Text(
                                              "Administrateur uniquement",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: blanc,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              paddingHorizontalGlobal(8),
            ],
          ),
        ),
        paddingVerticalGlobal(),
        TextFieldSettingWidget(
            title: "Valeur prédéfinie ",
            onChanged: (v) =>
                formulaireBloc.updateFielForm("valeur_predefini", v)),
        paddingVerticalGlobal(),
        TextFieldSettingWidget(
            title: "Placeholder Text ",
            onChanged: (v) => formulaireBloc.updateFielForm("placeholder", v)),
        paddingVerticalGlobal(),
        TextFieldSettingWidget(
            title: "Instructions pour l'utilisateur ",
            onChanged: (v) => formulaireBloc.updateFielForm("instructor", v)),
        paddingVerticalGlobal(),
        Row(
          children: [
            paddingHorizontalGlobal(8),
            Expanded(
                child: GestureDetector(
              onTap: () => formulaireBloc.deleteChildForm(),
              child: Container(
                height: 35,
                color: rouge.withOpacity(.8),
                child: Center(
                  child: Text(
                    'Suprimer champ',
                    style: TextStyle(fontSize: 12, color: blanc),
                  ),
                ),
              ),
            )),
            paddingHorizontalGlobal(8),
            Expanded(
                child: GestureDetector(
              onTap: () => formulaireBloc.setMenuForm(0),
              child: Container(
                height: 35,
                color: vertFonce.withOpacity(.8),
                child: Center(
                  child: Text(
                    'Ajouter champ',
                    style: TextStyle(fontSize: 12, color: blanc),
                  ),
                ),
              ),
            )),
            paddingHorizontalGlobal(8),
          ],
        )
      ],
    );
  }
}
