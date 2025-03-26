import 'package:flutter/material.dart';
import 'package:form/blocs/champs-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/response-ui.dart';
import 'package:form/utils/upload-file.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewFormulaireScreen extends StatelessWidget {
  const ViewFormulaireScreen({super.key});

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
                      color: rouge,
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
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Text(
                                              e.nom!,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            paddingHorizontalGlobal(8),
                                            if (e.isObligatoire == '1')
                                              Icon(
                                                Icons.star,
                                                size: 10,
                                                color: rouge,
                                              ),
                                            const Spacer(),
                                            Text('(${e.notes!})')
                                          ],
                                        ),
                                        paddingHorizontalGlobal(32),
                                        ...e.listeOptions!
                                            .map(
                                              (el) => Row(
                                                children: [
                                                  const Icon(
                                                    Icons.circle_outlined,
                                                    size: 14,
                                                  ),
                                                  paddingHorizontalGlobal(8),
                                                  Text(el.option!)
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  )
                                : e.type! == 'checkBox'
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  e.nom!,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                paddingHorizontalGlobal(8),
                                                if (e.isObligatoire == '1')
                                                  Icon(
                                                    Icons.star,
                                                    size: 10,
                                                    color: rouge,
                                                  ),
                                                const Spacer(),
                                                Text('(${e.notes!})')
                                              ],
                                            ),
                                            paddingVerticalGlobal(),
                                            ...e.listeOptions!
                                                .map((el) => Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.square_outlined,
                                                          size: 14,
                                                        ),
                                                        paddingHorizontalGlobal(
                                                            8),
                                                        Text(el.option!)
                                                      ],
                                                    ))
                                                .toList(),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  e.nom!,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                paddingHorizontalGlobal(8),
                                                if (e.isObligatoire == '1')
                                                  Icon(
                                                    Icons.star,
                                                    size: 10,
                                                    color: rouge,
                                                  ),
                                                const Spacer(),
                                                Text('(${e.notes!})')
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: w - 32,
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: noir),
                                                    cursorColor: blanc,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            e.description!),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                          ),
                        ),
                        paddingVerticalGlobal(),
                      ],
                    ))
                .toList(),
            paddingVerticalGlobal(),
            Row(
              children: [
                SizedBox(
                  width: size.width * .3,
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go(
                        '/formulaire-sondeur/${formulaireSondeur.formulaireSondeurModel!.id!}'),
                    child: Container(
                      height: 40,
                      color: rouge,
                      child: Row(
                        children: [
                          paddingHorizontalGlobal(8),
                          Text(
                            'Retour',
                            style: TextStyle(fontSize: 14, color: blanc),
                          ),
                          paddingHorizontalGlobal(8),
                        ],
                      ),
                    ),
                  ),
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
