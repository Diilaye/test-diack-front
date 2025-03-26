import 'package:flutter/material.dart';
import 'package:form/screen/view-form/reponse-widget/multi-choix.dart';
import 'package:form/screen/view-form/reponse-widget/one-choix.dart';
import 'package:form/screen/view-form/reponse-widget/textfield-response.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/blocs/champs-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/utils/response-ui.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class ViewFormSondeScreen extends StatelessWidget {
  const ViewFormSondeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final champsBloc = Provider.of<ChampsBloc>(context);
    Size size = MediaQuery.of(context).size;
    double w = deviceName(size) == ScreenType.Desktop
        ? size.width * .4
        : deviceName(size) == ScreenType.Tablet
            ? size.width * .4
            : size.width;
    return Scaffold(
        backgroundColor: gris,
        appBar: AppBar(
          toolbarHeight: .0,
          elevation: .0,
          backgroundColor: blanc,
        ),
        body: ListView(
          children: [
            paddingVerticalGlobal(),
            Center(
              child: Container(
                // height: 150,
                width: w,
                decoration: BoxDecoration(
                    color: blanc,
                    boxShadow: [BoxShadow(blurRadius: 2, color: gris)],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    border: Border(
                        top: BorderSide(
                      color: vert,
                      width: 8,
                    ))),
                child: Column(
                  children: [
                    paddingVerticalGlobal(8),
                    Row(
                      children: [
                        paddingHorizontalGlobal(8),
                        Expanded(
                          child: Text(
                            formulaireSondeur.formulaireSondeurModel!.titre!,
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 1.5,
                                color: noir),
                          ),
                        ),
                        paddingHorizontalGlobal(8),
                      ],
                    ),
                    paddingVerticalGlobal(8),
                    Container(
                      height: .5,
                      color: noir.withOpacity(.4),
                    ),
                    paddingVerticalGlobal(8),
                    Row(
                      children: [
                        paddingHorizontalGlobal(8),
                        Expanded(
                          child: Text(
                            formulaireSondeur
                                .formulaireSondeurModel!.description!,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                wordSpacing: 1.5,
                                color: noir),
                          ),
                        ),
                        paddingHorizontalGlobal(8),
                      ],
                    ),
                    paddingVerticalGlobal(8),
                    Container(
                      height: .5,
                      color: noir.withOpacity(.4),
                    ),
                    paddingVerticalGlobal(8),
                    Row(
                      children: [
                        paddingHorizontalGlobal(8),
                        Icon(
                          Icons.star,
                          color: rouge,
                          size: 14,
                        ),
                        Text(
                          ' Indique une question obligatoire',
                          style: TextStyle(fontSize: 13, color: rouge),
                        )
                      ],
                    ),
                    paddingVerticalGlobal(8),
                  ],
                ),
              ),
            ),
            paddingVerticalGlobal(),
            ...formulaireSondeur.listeChampForm
                .map((e) => Column(
                      children: [
                        Center(
                          child: Container(
                            width: w,
                            decoration: BoxDecoration(
                              color: blanc,
                              boxShadow: [
                                BoxShadow(blurRadius: 2, color: gris)
                              ],
                            ),
                            child: e.type! == 'multiChoice'
                                ? MultiChoiceWidget(champ: e)
                                : e.type! == 'checkBox'
                                    ? OneChoixReponseWidget(
                                        champ: e,
                                      )
                                    : TextFieldResponseWidget(champ: e),
                          ),
                        ),
                        paddingVerticalGlobal(),
                      ],
                    ))
                .toList(),
            paddingVerticalGlobal(),
            Row(
              children: [
                Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    // onTap: () => context.go(
                    //     '/formulaire-sondeur/${formulaireSondeur.formulaireSondeurModel!.id!}'),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: vert,
                      ),
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(8),
                          Text(
                            'Envoyer',
                            style: TextStyle(fontSize: 14, color: blanc),
                          ),
                          paddingHorizontalGlobal(8),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * .3,
                ),
                // paddingHorizontalGlobal(32),
                // MouseRegion(
                //   cursor: SystemMouseCursors.click,
                //   child: GestureDetector(
                //     onTap: () => getFile(),
                //     child: Container(
                //       height: 40,
                //       color: rouge,
                //       child: Row(
                //         children: [
                //           paddingHorizontalGlobal(8),
                //           Text(
                //             'File',
                //             style: TextStyle(fontSize: 14, color: blanc),
                //           ),
                //           paddingHorizontalGlobal(8),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            paddingVerticalGlobal(64),
            paddingVerticalGlobal(200),
          ],
        ));
  }
}
