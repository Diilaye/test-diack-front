import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/champs-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/blocs/folder-bloc.dart';

class ParamsFormSondeurScreen extends StatelessWidget {
  const ParamsFormSondeurScreen({super.key});

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);
    final champsBloc = Provider.of<ChampsBloc>(context);

    return Scaffold(
      backgroundColor: gris,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 70,
        elevation: 3,
        backgroundColor: blanc,
        shadowColor: noir,
        title: Row(
          children: [
            paddingHorizontalGlobal(8),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (formulaireSondeur.formulaireSondeurModel!.folderForm ==
                      null) {
                    folderBloc.setFolder(null);
                    context.go("/");
                  } else {
                    FolderModel f = folderBloc.folders
                        .where((e) =>
                            e.id! ==
                            formulaireSondeur
                                .formulaireSondeurModel!.folderForm!.id!)
                        .first;
                    folderBloc.setFolder(f);
                    context.go("/");
                  }
                },
                child: Text(
                  formulaireSondeur.formulaireSondeurModel!.folderForm == null
                      ? "Mes formulaires"
                      : formulaireSondeur
                          .formulaireSondeurModel!.folderForm!.titre!,
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w300, color: noir),
                ),
              ),
            ),
            paddingHorizontalGlobal(4),
            Icon(
              Icons.chevron_right,
              color: noir,
              size: 10,
            ),
            paddingHorizontalGlobal(4),
            Text(formulaireSondeur.formulaireSondeurModel!.titre!,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: noir,
                    fontFamily: 'Rubik')),
          ],
        ),
        actions: [
          paddingHorizontalGlobal(8),
          SizedBox(
            height: 80,
            width: 80,
            // color: btnColor.withOpacity(.3),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  CupertinoIcons.building_2_fill,
                  color: noir,
                  size: 24,
                ),
                paddingVerticalGlobal(4),
                Text("Construire",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: noir,
                        fontFamily: 'Rubik')),
                const Spacer(),
              ],
            ),
          ),
          paddingHorizontalGlobal(8),
          Container(
            height: 80,
            width: 80,
            color: btnColor.withOpacity(.3),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  CupertinoIcons.settings,
                  color: blanc,
                  size: 24,
                ),
                paddingVerticalGlobal(4),
                Text("Parametres",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: blanc,
                        fontFamily: 'Rubik')),
                const Spacer(),
                Container(
                  height: 4,
                  color: btnColor,
                )
              ],
            ),
          ),
          paddingHorizontalGlobal(8),
          SizedBox(
            height: 80,
            width: 80,
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  CupertinoIcons.share,
                  color: noir,
                  size: 24,
                ),
                paddingVerticalGlobal(4),
                Text("Partager",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: noir,
                        fontFamily: 'Rubik')),
                const Spacer(),
              ],
            ),
          ),
          paddingHorizontalGlobal(8),
          Container(
            width: 2,
            height: 50,
            color: blanc,
          ),
          paddingHorizontalGlobal(8),
          SizedBox(
            height: 80,
            width: 80,
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  CupertinoIcons.mail,
                  color: noir,
                  size: 24,
                ),
                paddingVerticalGlobal(4),
                Text("Resultats",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: noir,
                        fontFamily: 'Rubik')),
                const Spacer(),
              ],
            ),
          ),
          paddingHorizontalGlobal(300),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: blanc,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                      color: noir.withOpacity(.2),
                      blurRadius: .2,
                      offset: Offset(1, 2))
                ]),
            child: Center(
              child: IconButton(
                  onPressed: () => null,
                  icon: Icon(
                    CupertinoIcons.eye,
                    color: noir,
                    size: 20,
                  )),
            ),
          ),
          paddingHorizontalGlobal(8),
          Container(
            height: 40,
            width: 120,
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                    color: noir.withOpacity(.2),
                    blurRadius: .2,
                    offset: Offset(1, 2))
              ],
            ),
            child: Row(
              children: [
                const Spacer(),
                Icon(
                  Icons.save,
                  color: blanc,
                  size: 14,
                ),
                paddingHorizontalGlobal(4),
                Text(
                  'Sauvegarder',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold, color: blanc),
                ),
                const Spacer(),
              ],
            ),
          ),
          paddingHorizontalGlobal(32),
        ],
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            paddingVerticalGlobal(size.height * .05),
            SizedBox(
              height: 800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 300,
                        height: 282,
                        decoration: BoxDecoration(
                            color: blanc,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: noir.withOpacity(.3))),
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: btnColor.withOpacity(.4),
                                  border: Border(
                                      bottom: BorderSide(
                                          color: noir.withOpacity(.3))),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  paddingHorizontalGlobal(8),
                                  Icon(
                                    CupertinoIcons.gear_alt,
                                    color: noir,
                                  ),
                                  paddingHorizontalGlobal(8),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Paramètres généraux".toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          color: noir,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: blanc,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: noir.withOpacity(.3))),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  paddingHorizontalGlobal(8),
                                  Icon(CupertinoIcons.bell),
                                  paddingHorizontalGlobal(8),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Paramètres de notifications"
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          color: noir,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: blanc,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: noir.withOpacity(.3))),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  paddingHorizontalGlobal(8),
                                  Icon(CupertinoIcons.calendar),
                                  paddingHorizontalGlobal(8),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Paramètres de planiication"
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          color: noir,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                  color: blanc,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: noir.withOpacity(.3))),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  paddingHorizontalGlobal(8),
                                  Icon(CupertinoIcons.globe),
                                  paddingHorizontalGlobal(8),
                                  SizedBox(
                                    width: 250,
                                    child: Text(
                                      "Paramètres de localisation"
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          color: noir,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  paddingHorizontalGlobal(20),
                  Container(
                    width: 700,
                    height: 800,
                    decoration: BoxDecoration(
                        color: blanc,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(2, 2),
                              color: noir.withOpacity(.4),
                              blurRadius: .5)
                        ]),
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 700,
                          decoration: BoxDecoration(
                              color: blanc,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              paddingHorizontalGlobal(20),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  "Paramètres généraux".toUpperCase(),
                                  style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 13,
                                      color: noir,
                                      fontWeight: FontWeight.w900),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: .5,
                          width: 660,
                          color: noir,
                        ),
                        Container(
                          height: 70,
                          width: 700,
                          decoration: BoxDecoration(
                              color: blanc,
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              paddingHorizontalGlobal(20),
                              SizedBox(
                                height: 10,
                                width: 45,
                                child: Transform.scale(
                                  transformHitTests: false,
                                  scale: .7,
                                  child: CupertinoSwitch(
                                    value: false,
                                    activeColor: btnColor,
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                              paddingHorizontalGlobal(8),
                              Text(
                                "Conexion requise pour la soumission"
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: noir),
                              ),
                              paddingHorizontalGlobal(20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
