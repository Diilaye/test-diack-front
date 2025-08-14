import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/get-date-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js' as js;

import 'dart:html';

class HomePageSondeur extends StatelessWidget {
  const HomePageSondeur({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);

    return Scaffold(
      backgroundColor: blanc,
      appBar: AppBar(
        elevation: .0,
        toolbarHeight: .0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => formulaireSondeur.addFormSondeur(""),
        child: formulaireSondeur.chargement
            ? CircularProgressIndicator(
                color: blanc,
                backgroundColor: noir,
              )
            : Icon(
                Icons.add,
                color: blanc,
              ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: blanc,
        child: Column(
          children: [
            Center(
              child: Container(
                height: 60,
                width: size.width,
                color: noir,
                child: Row(
                  children: [
                    paddingHorizontalGlobal(),
                    IconButton(
                        onPressed: () => context.go('/'),
                        icon: Icon(
                          CupertinoIcons.folder,
                          size: 24,
                          color: blanc,
                        )),
                    paddingHorizontalGlobal(8),
                    Text(
                      'formulaire'.toUpperCase(),
                      style: TextStyle(fontSize: 24, color: blanc),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      backgroundColor: rouge,
                      child: Center(
                        child: Text(
                          'S',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: blanc),
                        ),
                      ),
                    ),
                    paddingHorizontalGlobal(),
                    IconButton(
                        tooltip: 'Déconexion',
                        onPressed: () =>
                            SharedPreferences.getInstance().then((prefs) {
                              prefs.clear().then((value) {
                                print(value);
                                if (value) {
                                  js.context.callMethod('open', [
                                    'https://test-diag.saharux.com/',
                                    '_self'
                                  ]);
                                }
                              });
                            }),
                        icon: Icon(
                          Icons.logout_outlined,
                          color: blanc,
                        )),
                    paddingHorizontalGlobal(),
                  ],
                ),
              ),
            ),
            paddingVerticalGlobal(),
            Center(
              child: SizedBox(
                width: size.width * .8,
                child: Row(
                  children: [
                    Text(
                      "Audjourd'hui".toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          color: noir,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            paddingVerticalGlobal(),
            Column(
              children: formulaireSondeur.formulaires
                  .where((e) => isSameDate(e.date!))
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Center(
                          child: Container(
                            height: 45,
                            width: size.width * .8,
                            child: Row(
                              children: [
                                Expanded(child: Text(e.titre!)),
                                Expanded(child: Text(e.description!)),
                                Expanded(child: Text(showDate(e.date!))),
                                Expanded(
                                    child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        formulaireSondeur
                                            .setSelectedFormSondeurModel(e);

                                        context
                                            .go('/formulaire-sondeur/${e.id!}');
                                      },
                                      icon: Icon(
                                        CupertinoIcons.eye,
                                        color: noir,
                                      ),
                                    ),
                                    paddingHorizontalGlobal(8),
                                    IconButton(
                                      onPressed: () async => dialogRequest(
                                              context: context,
                                              title:
                                                  'Etes-vous sure de vouloir supprimer le formulaire ?')
                                          .then((v) async {
                                        if (v) {
                                          await formulaireSondeur
                                              .deleteFformulaire(e.id!);

                                          if (formulaireSondeur.resultDelete !=
                                              null) {
                                            window.location.reload();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Ce formulaire ne peut pas etre supprimé",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    Colors.redAccent,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }
                                      }),
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        color: noir,
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            paddingVerticalGlobal(),
            Center(
              child: SizedBox(
                width: size.width * .8,
                child: Row(
                  children: [
                    Text(
                      "Le reste des formulaires".toUpperCase(),
                      style: TextStyle(
                          fontSize: 18,
                          color: noir,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            paddingVerticalGlobal(),
            Expanded(
                child: ListView(
              children: formulaireSondeur.formulaires
                  .where((e) => !isSameDate(e.date!))
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Center(
                          child: Container(
                            height: 45,
                            width: size.width * .8,
                            child: Row(
                              children: [
                                Expanded(child: Text(e.titre!)),
                                Expanded(child: Text(e.description!)),
                                Expanded(child: Text(showDate(e.date!))),
                                Expanded(
                                    child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        formulaireSondeur
                                            .setSelectedFormSondeurModel(e);
                                        context
                                            .go('/formulaire-sondeur/${e.id!}');
                                      },
                                      icon: Icon(
                                        CupertinoIcons.eye,
                                        color: noir,
                                      ),
                                    ),
                                    paddingHorizontalGlobal(8),
                                    IconButton(
                                      onPressed: () async => dialogRequest(
                                              context: context,
                                              title:
                                                  'Etes-vous sure de vouloir supprimer le formulaire ?')
                                          .then((v) async {
                                        if (v) {
                                          await formulaireSondeur
                                              .deleteFformulaire(e.id!);

                                          if (formulaireSondeur.resultDelete !=
                                              null) {
                                            window.location.reload();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Ce formulaire ne peut pas etre supprimé",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    Colors.redAccent,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        }
                                      }),
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        color: noir,
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ))
          ],
        ),
      ),
    );
  }
}
