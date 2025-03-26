import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/screen/administrateur/formulaire/form-style-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/text-field-setting-sorm-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/text-field-setting-widget.dart';
import 'package:form/screen/administrateur/formulaire/widget/title-option-form.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class ThreeMenuForm extends StatelessWidget {
  const ThreeMenuForm({super.key});

  @override
  Widget build(BuildContext context) {
    final formulaireBloc = Provider.of<FormulaireBloc>(context);

    return Column(
      children: [
        paddingVerticalGlobal(16),
        TextFieldSettingWidget(
            title: 'Titre formulaire',
            onChanged: (v) => formulaireBloc.setTitleform(v)),
        paddingVerticalGlobal(),
        TextFieldSettingWidget(
            title: 'Description formulaire',
            onChanged: (v) => formulaireBloc.setdescform(v)),
        paddingVerticalGlobal(),
        FromStyleWidget(
          title: "Alignement du titre du formulaire (?)",
          value: formulaireBloc.styleTitreForm,
          onchange: (v) => formulaireBloc.setStyleTitreForm(v),
        ),
        paddingVerticalGlobal(),
        FromStyleWidget(
          title: "Alignement du description du formulaire (?)",
          value: formulaireBloc.styleDescForm,
          onchange: (v) => formulaireBloc.setStyleDescForm(v),
        ),
        paddingVerticalGlobal(),
        SizedBox(
          height: 250,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    paddingHorizontalGlobal(8),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: jaune.withOpacity(.7),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          )),
                      child: Center(
                        child: Text(
                          'Options de confirmation',
                          style: TextStyle(
                              fontSize: 10,
                              color: noir,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    )),
                    Expanded(flex: 2, child: SizedBox()),
                  ],
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      paddingHorizontalGlobal(8),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: jaune.withOpacity(.7),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  )),
                              child: Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  Row(
                                    children: [
                                      TitleOptionForm(
                                        color: vert,
                                        text: 'Pas de message',
                                        isActive:
                                            formulaireBloc.noSendText == 0,
                                        onTap: () =>
                                            formulaireBloc.setNoSendText(0),
                                      ),
                                      TitleOptionForm(
                                          color: vert,
                                          text: 'Message d\'email',
                                          isActive:
                                              formulaireBloc.noSendText == 1,
                                          onTap: () =>
                                              formulaireBloc.setNoSendText(1)),
                                      TitleOptionForm(
                                          color: vert,
                                          text: 'Message de sms',
                                          isActive:
                                              formulaireBloc.noSendText == 2,
                                          onTap: () =>
                                              formulaireBloc.setNoSendText(2)),
                                    ],
                                  ),
                                  Expanded(
                                    child: TextFieldSettingFormWidget(
                                        title: 'Message',
                                        value: formulaireBloc
                                            .controllerEmailMessage,
                                        fontSize: 10,
                                        onChanged: (v) => formulaireBloc
                                            .setMessageEmailForm(v)),
                                  ),
                                  paddingVerticalGlobal(8),
                                  Row(
                                    children: [
                                      paddingHorizontalGlobal(8),
                                      Expanded(
                                          child: Container(
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: blanc.withOpacity(.4),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          children: [
                                            paddingHorizontalGlobal(8),
                                            IconButton(
                                              onPressed: () => formulaireBloc
                                                  .setNoSendConfirm(),
                                              icon: Icon(
                                                formulaireBloc.noSendConfirm ==
                                                        0
                                                    ? CupertinoIcons.square
                                                    : CupertinoIcons
                                                        .checkmark_square_fill,
                                                color: vert,
                                                size: 20,
                                              ),
                                            ),
                                            paddingHorizontalGlobal(8),
                                            Text(
                                              'Envoyer un message de confirmation à l\'utilisateur',
                                              style: TextStyle(
                                                  fontSize: 10, color: noir),
                                            )
                                          ],
                                        ),
                                      )),
                                      paddingHorizontalGlobal(8),
                                    ],
                                  ),
                                  paddingVerticalGlobal()
                                ],
                              ))),
                      paddingHorizontalGlobal(8),
                    ],
                  ))
            ],
          ),
        ),
        paddingVerticalGlobal(),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    paddingHorizontalGlobal(8),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: jaune.withOpacity(.7),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          )),
                      child: Center(
                        child: Text(
                          'Partager formulaire',
                          style: TextStyle(
                              fontSize: 10,
                              color: noir,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    )),
                    Expanded(flex: 2, child: SizedBox()),
                  ],
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      paddingHorizontalGlobal(8),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: jaune.withOpacity(.7),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  )),
                              child: Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  Row(
                                    children: [
                                      TitleOptionForm(
                                        color: vert,
                                        text: 'Formulaire Privée',
                                        isActive:
                                            formulaireBloc.noSendText == 0,
                                        onTap: () =>
                                            formulaireBloc.setNoSendText(0),
                                      ),
                                      TitleOptionForm(
                                          color: vert,
                                          text: 'Formulaire Public',
                                          isActive:
                                              formulaireBloc.noSendText == 1,
                                          onTap: () =>
                                              formulaireBloc.setNoSendText(1)),
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  Expanded(
                                    child: TextFieldSettingFormWidget(
                                        title: 'Code formulaire',
                                        maxLine: 2,
                                        value: formulaireBloc
                                            .controllerCodeFormulaire,
                                        fontSize: 10,
                                        onChanged: (v) =>
                                            formulaireBloc.setCodeFormForm(v)),
                                  ),
                                  paddingVerticalGlobal(8),
                                  Row(
                                    children: [
                                      paddingHorizontalGlobal(8),
                                      Expanded(
                                          child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: vert.withOpacity(.4),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Partager le lien',
                                              style: TextStyle(
                                                  fontSize: 10, color: noir),
                                            )
                                          ],
                                        ),
                                      )),
                                      paddingHorizontalGlobal(8),
                                    ],
                                  ),
                                  paddingVerticalGlobal()
                                ],
                              ))),
                      paddingHorizontalGlobal(8),
                    ],
                  ))
            ],
          ),
        ),
      ],
    );
  }
}
