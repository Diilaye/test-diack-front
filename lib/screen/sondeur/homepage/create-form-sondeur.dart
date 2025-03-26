import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/champs-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/screen/sondeur/components/questions/Explication-Form.dart';
import 'package:form/screen/sondeur/components/questions/addresse-Form.dart';
import 'package:form/screen/sondeur/components/questions/email-Form.dart';
import 'package:form/screen/sondeur/components/questions/file-field-Form.dart';
import 'package:form/screen/sondeur/components/questions/full-Name-Form.dart';
import 'package:form/screen/sondeur/components/questions/image-field-Form.dart';
import 'package:form/screen/sondeur/components/questions/multi-selection-Form.dart';
import 'package:form/screen/sondeur/components/questions/separator-field-Form.dart';
import 'package:form/screen/sondeur/components/questions/separator-field-with-title-Form.dart';
import 'package:form/screen/sondeur/components/questions/single-selection-Form.dart';
import 'package:form/screen/sondeur/components/questions/telephone-Form.dart';
import 'package:form/screen/sondeur/components/questions/textArea-Form%20.dart';
import 'package:form/screen/sondeur/components/questions/textField-Form.dart';
import 'package:form/screen/sondeur/components/questions/yes-or-no-Form.dart';
import 'package:form/screen/sondeur/components/section-menu-form/contact-menu.dart';
import 'package:form/screen/sondeur/components/section-menu-form/essentiel-menu.dart';
import 'package:form/screen/sondeur/components/section-menu-form/media-structure.dart';
import 'package:form/screen/sondeur/components/section-menu-form/telechargement-menu.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/requette-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/blocs/folder-bloc.dart';

class CreateFormSondeurScreen extends StatelessWidget {
  const CreateFormSondeurScreen({super.key});

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);
    final champsBloc = Provider.of<ChampsBloc>(context);

    return Scaffold(
      backgroundColor: blanc,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 70,
        elevation: 3,
        backgroundColor: blanc,
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
          Container(
            height: 80,
            width: 80,
            color: btnColor.withOpacity(.3),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  CupertinoIcons.building_2_fill,
                  color: blanc,
                  size: 24,
                ),
                paddingVerticalGlobal(4),
                Text("Construire",
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
          GestureDetector(
            onTap: () => context.go(
                '/formulaire/${formulaireSondeur.formulaireSondeurModel!.id!}/params'),
            child: SizedBox(
              height: 80,
              width: 80,
              // color: gris,
              child: Column(
                children: [
                  const Spacer(),
                  Icon(
                    CupertinoIcons.settings,
                    color: noir,
                    size: 24,
                  ),
                  paddingVerticalGlobal(4),
                  Text("Parametres",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: noir,
                          fontFamily: 'Rubik')),
                  const Spacer(),
                ],
              ),
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
        child: Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(color: blanc, boxShadow: [
                BoxShadow(
                    offset: const Offset(2, 2),
                    color: noir.withOpacity(.4),
                    blurRadius: 2)
              ]),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 230,
                    decoration: BoxDecoration(
                        color: blanc,
                        border: Border(
                            right: BorderSide(color: btnColor, width: 5))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/shapes.svg",
                          height: 20,
                          width: 20,
                          color: btnColor,
                        ),
                        paddingVerticalGlobal(8),
                        Text(
                          "Champs",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: btnColor),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 230,
                    decoration: BoxDecoration(
                        color: blanc,
                        border:
                            Border(right: BorderSide(color: blanc, width: 5))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/design.svg",
                          height: 20,
                          width: 20,
                          color: noir,
                        ),
                        paddingVerticalGlobal(8),
                        Text(
                          "Design",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: noir),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 230,
                    decoration: BoxDecoration(
                        color: blanc,
                        border:
                            Border(right: BorderSide(color: blanc, width: 5))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/logic.svg",
                          height: 20,
                          width: 20,
                          color: noir,
                        ),
                        paddingVerticalGlobal(8),
                        Text(
                          "Logic",
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: noir),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
            paddingHorizontalGlobal(1),
            Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(color: blanc, boxShadow: [
                    BoxShadow(
                        offset: const Offset(2, 2),
                        color: noir.withOpacity(.4),
                        blurRadius: 2)
                  ]),
                  child: Column(
                    children: [
                      //paddingVerticalGlobal(),
                      // Row(
                      //   children: [
                      //     paddingHorizontalGlobal(8),
                      //     const Expanded(
                      //       child: SizedBox(
                      //         height: 40,
                      //         child: TextField(
                      //           decoration: InputDecoration(
                      //               hintText: 'Recherche',
                      //               border: InputBorder.none,
                      //               enabledBorder: InputBorder.none),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // paddingVerticalGlobal(8),
                      Expanded(
                          child: ListView(
                        children: [
                          const EssentielSectionMenu(),
                          const ContactSectionMenu(),
                          const TelechargementSectionMenu(),
                          const MediaStructureSectionMenu(),
                          paddingVerticalGlobal(32),
                        ],
                      ))
                    ],
                  ),
                )),
            paddingHorizontalGlobal(1),
            Expanded(
              flex: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: size.height,
                      child: ListView(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () => formulaireSondeur.upadteCover(),
                                child: Container(
                                  height: 250,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                          child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: formulaireSondeur
                                                      .formulaireSondeurModel!
                                                      .cover ==
                                                  null
                                              ? gris.withOpacity(.6)
                                              : blanc,
                                        ),
                                        child: formulaireSondeur
                                                    .formulaireSondeurModel!
                                                    .cover ==
                                                null
                                            ? Column(
                                                children: [
                                                  paddingVerticalGlobal(),
                                                  Row(
                                                    children: [
                                                      const Spacer(),
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: blanc,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          2, 2),
                                                                  blurRadius: 2,
                                                                  color: noir
                                                                      .withOpacity(
                                                                          .4))
                                                            ]),
                                                        child: Center(
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .delete,
                                                            size: 14,
                                                            color: noir,
                                                          ),
                                                        ),
                                                      ),
                                                      paddingHorizontalGlobal(),
                                                    ],
                                                  ),
                                                  paddingVerticalGlobal(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/images/upload-minimalistic.svg",
                                                        height: 24,
                                                        width: 24,
                                                        color: noir,
                                                      )
                                                    ],
                                                  ),
                                                  paddingVerticalGlobal(4),
                                                  const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          "Cliquez ici pour télécharger une image. Dimensions recommandées : 2400*240")
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                ],
                                              )
                                            : CachedNetworkImage(
                                                height: 200,
                                                width: size.width,
                                                fit: BoxFit.contain,
                                                imageUrl: BASE_URL_ASSET +
                                                    formulaireSondeur
                                                        .formulaireSondeurModel!
                                                        .cover!
                                                        .url!,
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                      )),
                                      Positioned(
                                          top: 150,
                                          left: 75,
                                          child: GestureDetector(
                                            onTap: () =>
                                                formulaireSondeur.upadteLogo(),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color: blanc,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(2, 2),
                                                        blurRadius: 2,
                                                        color: noir
                                                            .withOpacity(.4))
                                                  ]),
                                              child: formulaireSondeur
                                                          .formulaireSondeurModel!
                                                          .logo ==
                                                      null
                                                  ? Center(
                                                      child: SvgPicture.asset(
                                                        "assets/images/upload-minimalistic.svg",
                                                        height: 24,
                                                        width: 24,
                                                        color: noir,
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.contain,
                                                      imageUrl: BASE_URL_ASSET +
                                                          formulaireSondeur
                                                              .formulaireSondeurModel!
                                                              .logo!
                                                              .url!,
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 250,
                            child: Column(
                              children: [
                                paddingVerticalGlobal(),
                                Row(
                                  children: [
                                    paddingHorizontalGlobal(size.width * .05),
                                    Expanded(
                                      child: TextField(
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: noir),
                                        onChanged: (value) => formulaireSondeur
                                            .updateTitreForm(value),
                                        controller: formulaireSondeur.titreCtrl,
                                        cursorColor: noir,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: formulaireSondeur
                                                .formulaireSondeurModel!
                                                .titre!),
                                      ),
                                    ),
                                    paddingHorizontalGlobal(size.width * .05),
                                  ],
                                ),
                                Row(
                                  children: [
                                    paddingHorizontalGlobal(size.width * .05),
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        decoration: DottedDecoration(),
                                      ),
                                    ),
                                    paddingHorizontalGlobal(size.width * .05),
                                  ],
                                ),
                                paddingVerticalGlobal(8),
                                paddingVerticalGlobal(),
                                Row(
                                  children: [
                                    paddingHorizontalGlobal(size.width * .05),
                                    Expanded(
                                      child: SizedBox(
                                        child: TextFormField(
                                          minLines:
                                              6, // any number you need (It works as the rows for the textarea)
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,

                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: noir),
                                          onChanged: (value) =>
                                              formulaireSondeur
                                                  .updateDescrForm(value),
                                          controller:
                                              formulaireSondeur.descCtrl,
                                          cursorColor: noir,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              enabledBorder:
                                                  OutlineInputBorder(),
                                              labelText:
                                                  'Description formulaire',
                                              hintText: formulaireSondeur
                                                  .formulaireSondeurModel!
                                                  .description),
                                        ),
                                      ),
                                    ),
                                    paddingHorizontalGlobal(size.width * .05),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ...formulaireSondeur.listeChampForm.map((e) {
                            if (e.type! == 'textField') {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  TextFieldForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "textArea") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  TextAreaForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "singleChoice") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  SingleSelectionForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "yesno") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  YesOrnOForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "multiChoice") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  MultiSelectionForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "nomComplet") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  FullNameForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "email") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  EmailForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "addresse") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  AddresseForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "telephone") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  TelephoneForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "image") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  ImageFieldForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "file") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  FileFieldForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "separator") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  SeparatorFielForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "separator-title") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  SeparatorFielWithTitleForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else if (e.type! == "explication") {
                              return Column(
                                children: [
                                  paddingVerticalGlobal(),
                                  ExplicationForm(
                                    champ: e,
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }).toList(),
                          paddingVerticalGlobal(200),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: size.height,
                  //   width: size.width * .05,
                  //   child: Column(
                  //     children: [
                  //       paddingVerticalGlobal(8),
                  //       CircleAvatar(
                  //         backgroundColor: rouge,
                  //         child: IconButton(
                  // onPressed: () async {
                  //   formulaireSondeur.addChampFormulaire(
                  //       formulaireSondeur
                  //           .formulaireSondeurModel!.id!);
                  // },
                  //             icon: Icon(
                  //               CupertinoIcons.add_circled,
                  //               color: blanc,
                  //             ),
                  //             tooltip: 'Ajouter une question'),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
  //   final champsBloc = Provider.of<ChampsBloc>(context);
  //   return Scaffold(
  //     backgroundColor: blanc,
  //     appBar: AppBar(
  //       elevation: .0,
  //       toolbarHeight: .0,
  //     ),
  //     body: Stack(
  //       children: [
  //         Positioned(
  //             top: 0,
  //             child: Container(
  //               height: 120,
  //               width: size.width,
  //               color: rouge,
  //               child: Column(
  //                 children: [
  //                   const Spacer(),
  //                   SizedBox(
  //                     height: 60,
  //                     width: size.width,
  //                     child: Row(
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         IconButton(
  //                             onPressed: () => context.go('/'),
  //                             icon: Icon(
  //                               CupertinoIcons.folder,
  //                               size: 24,
  //                               color: blanc,
  //                             )),
  //                         paddingHorizontalGlobal(8),
  //                         SizedBox(
  //                           width: 300.0,
  //                           child: TextField(
  //                             style: TextStyle(
  //                                 fontSize: 18,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: blanc),
  //                             onSubmitted: (value) =>
  //                                 formulaireSondeur.updateTitreForm(value),
  //                             controller: formulaireSondeur.titreCtrl,
  //                             cursorColor: blanc,
  //                             decoration: InputDecoration(
  //                                 border: InputBorder.none,
  //                                 hintText: formulaireSondeur
  //                                     .formulaireSondeurModel!.titre!),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(8),
  //                         // Icon(
  //                         //   CupertinoIcons.star,
  //                         //   size: 14,
  //                         //   color: blanc,
  //                         // ),
  //                         const Spacer(),
  //                         IconButton(
  //                             tooltip: 'Apercu',
  //                             onPressed: () {
  //                               formulaireSondeur.setSelectedFormSondeurModel(
  //                                   formulaireSondeur.formulaireSondeurModel!);
  //                               context.go(
  //                                   '/formulaire-view/${formulaireSondeur.formulaireSondeurModel!.id!}');
  //                             },
  //                             icon: Icon(
  //                               CupertinoIcons.eye,
  //                               color: blanc,
  //                             )),
  //                         paddingHorizontalGlobal(8),
  //                         GestureDetector(
  //                           onTap: () => formulaireSondeur.setShowEnvoyer(1),
  //                           child: Container(
  //                               height: 35,
  //                               width: 90,
  //                               decoration: BoxDecoration(
  //                                   color: noir,
  //                                   borderRadius: BorderRadius.circular(4)),
  //                               child: Center(
  //                                   child: Text(
  //                                 'Envoyer',
  //                                 style: TextStyle(fontSize: 14, color: blanc),
  //                               ))),
  //                         ),
  //                         paddingHorizontalGlobal(24),

  //                         CircleAvatar(
  //                           backgroundColor: blanc,
  //                           child: Center(
  //                             child: Text(
  //                               'S',
  //                               style: TextStyle(
  //                                   fontSize: 24,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: rouge),
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                       ],
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                   SizedBox(
  //                     width: size.width,
  //                     height: 30,
  //                     child: Row(
  //                       children: [
  //                         const Spacer(),
  //                         GestureDetector(
  //                           onTap: () => formulaireSondeur.setShowMenu(0),
  //                           child: SizedBox(
  //                             width: 90,
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   'Questions',
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w300,
  //                                       color: blanc),
  //                                 ),
  //                                 paddingVerticalGlobal(2),
  //                                 Container(
  //                                   width: 70,
  //                                   height: 2,
  //                                   color: formulaireSondeur.showMenu == 0
  //                                       ? blanc
  //                                       : rouge,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                         GestureDetector(
  //                           onTap: () => formulaireSondeur.setShowMenu(1),
  //                           child: SizedBox(
  //                             width: 90,
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   'Réponses',
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w300,
  //                                       color: blanc),
  //                                 ),
  //                                 paddingVerticalGlobal(2),
  //                                 Container(
  //                                   width: 70,
  //                                   height: 2,
  //                                   color: formulaireSondeur.showMenu == 1
  //                                       ? blanc
  //                                       : rouge,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                         GestureDetector(
  //                           onTap: () => formulaireSondeur.setShowMenu(2),
  //                           child: SizedBox(
  //                             width: 90,
  //                             child: Column(
  //                               children: [
  //                                 Text(
  //                                   'Paramètres',
  //                                   style: TextStyle(
  //                                       fontSize: 14,
  //                                       fontWeight: FontWeight.w300,
  //                                       color: blanc),
  //                                 ),
  //                                 paddingVerticalGlobal(2),
  //                                 Container(
  //                                   width: 70,
  //                                   height: 2,
  //                                   color: formulaireSondeur.showMenu == 2
  //                                       ? blanc
  //                                       : rouge,
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         const Spacer(),
  //                       ],
  //                     ),
  //                   ),
  //                   const Spacer(),
  //                 ],
  //               ),
  //             )),
  //         Positioned(
  //             top: 120,
  //             child: formulaireSondeur.showMenu == 0
  //                 ? Container(
  //                     height: size.height,
  //                     width: size.width,
  //                     color: gris,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         SizedBox(
  //                           height: size.height,
  //                           width: size.width * .78,
  //                           child: ListView(
  //                             children: [
  //                               paddingVerticalGlobal(8),
  //                               Container(
  //                                 height: 150,
  //                                 width: size.width * .75,
  //                                 decoration: BoxDecoration(
  //                                     color: blanc,
  //                                     borderRadius: const BorderRadius.only(
  //                                         topLeft: Radius.circular(8),
  //                                         topRight: Radius.circular(8)),
  //                                     border: Border(
  //                                         top: BorderSide(
  //                                             width: 5, color: rouge))),
  //                                 child: Column(
  //                                   children: [
  //                                     paddingVerticalGlobal(),
  //                                     Row(
  //                                       children: [
  //                                         paddingHorizontalGlobal(),
  //                                         SizedBox(
  //                                           width: 600.0,
  //                                           child: TextField(
  //                                             style: TextStyle(
  //                                                 fontSize: 24,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: noir),
  //                                             onSubmitted: (value) =>
  //                                                 formulaireSondeur
  //                                                     .updateTitreForm(value),
  //                                             controller:
  //                                                 formulaireSondeur.titreCtrl,
  //                                             cursorColor: blanc,
  //                                             decoration: InputDecoration(
  //                                                 border: InputBorder.none,
  //                                                 hintText: formulaireSondeur
  //                                                     .formulaireSondeurModel!
  //                                                     .titre!),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     paddingVerticalGlobal(4),
  //                                     Row(
  //                                       children: [
  //                                         paddingHorizontalGlobal(),
  //                                         SizedBox(
  //                                           width: size.width * .7,
  //                                           child: TextField(
  //                                             style: TextStyle(
  //                                                 fontSize: 14,
  //                                                 fontWeight: FontWeight.w300,
  //                                                 color: noir),
  //                                             onSubmitted: (value) =>
  //                                                 formulaireSondeur
  //                                                     .updateDescrForm(value),
  //                                             controller:
  //                                                 formulaireSondeur.descCtrl,
  //                                             cursorColor: noir,
  //                                             decoration: InputDecoration(
  //                                                 border:
  //                                                     const OutlineInputBorder(),
  //                                                 hintText: formulaireSondeur
  //                                                     .formulaireSondeurModel!
  //                                                     .description),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               paddingVerticalGlobal(8),
  //                               ...formulaireSondeur.listeChampForm
  //                                   .map((e) => QuestionSondeurWidget(
  //                                         champ: e,
  //                                       ))
  //                                   .toList(),
  //                               paddingVerticalGlobal(200),
  //                             ],
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: size.height,
  //                           width: size.width * .05,
  //                           child: Column(
  //                             children: [
  //                               paddingVerticalGlobal(8),
  //                               CircleAvatar(
  //                                 backgroundColor: rouge,
  //                                 child: IconButton(
  //                                     onPressed: () async {
  //                                       formulaireSondeur.addChampFormulaire(
  //                                           formulaireSondeur
  //                                               .formulaireSondeurModel!.id!);
  //                                     },
  //                                     icon: Icon(
  //                                       CupertinoIcons.add_circled,
  //                                       color: blanc,
  //                                     ),
  //                                     tooltip: 'Ajouter une question'),
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   )
  //                 : formulaireSondeur.showMenu == 1
  //                     ? Container(
  //                         height: size.height - 120,
  //                         width: size.width,
  //                         color: blanc,
  //                       )
  //                     : Container(
  //                         height: size.height - 120,
  //                         width: size.width,
  //                         color: blanc,
  //                       )),
  //         if (formulaireSondeur.showEnvoyer == 1)
  //           Positioned(
  //               child: Container(
  //             color: noir.withOpacity(.5),
  //           )),
  //         if (formulaireSondeur.showEnvoyer == 1)
  //           Positioned(
  //               top: 80,
  //               left: size.width * .25,
  //               right: size.width * .25,
  //               child: Container(
  //                 height: size.height * .7,
  //                 width: size.width * .5,
  //                 decoration: BoxDecoration(
  //                     color: gris,
  //                     borderRadius: BorderRadius.circular(8),
  //                     boxShadow: [
  //                       BoxShadow(color: noir.withOpacity(.2), blurRadius: 2)
  //                     ]),
  //                 child: Column(
  //                   children: [
  //                     paddingVerticalGlobal(),
  //                     Row(
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         Text(
  //                           'Envoyer le formulaire',
  //                           style: TextStyle(
  //                               fontSize: 20,
  //                               color: rouge,
  //                               fontWeight: FontWeight.w500),
  //                         ),
  //                         const Spacer(),
  //                         IconButton(
  //                             onPressed: () =>
  //                                 formulaireSondeur.setShowEnvoyer(0),
  //                             icon: Icon(Icons.close)),
  //                         paddingHorizontalGlobal(),
  //                       ],
  //                     ),
  //                     paddingVerticalGlobal(8),
  //                     Container(
  //                       height: 60,
  //                       color: noir.withOpacity(.3),
  //                       child: Row(
  //                         children: [
  //                           paddingHorizontalGlobal(),
  //                           const Text('Collecter les adresses e-mail'),
  //                           const Spacer(),
  //                           DropdownButton(
  //                               value: formulaireSondeur.collecterEmail,
  //                               items: [
  //                                 'Ne pas collecter',
  //                                 'activer la collection',
  //                                 'Information saisie par le sondé'
  //                               ]
  //                                   .map((e) => DropdownMenuItem(
  //                                         value: e.toLowerCase().trim(),
  //                                         child: Text(
  //                                           e.toUpperCase(),
  //                                           style: TextStyle(
  //                                               fontSize: 13, color: noir),
  //                                         ),
  //                                       ))
  //                                   .toList(),
  //                               onChanged: (v) =>
  //                                   formulaireSondeur.setCollecterEmail(
  //                                       v!.toLowerCase().trim())),
  //                           paddingHorizontalGlobal(),
  //                         ],
  //                       ),
  //                     ),
  //                     paddingHorizontalGlobal(),
  //                     Container(
  //                       height: 45,
  //                       child: Row(
  //                         children: [
  //                           paddingHorizontalGlobal(),
  //                           Text(
  //                             "Envoyer via ",
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: noir,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           paddingHorizontalGlobal(32),
  //                           GestureDetector(
  //                             onTap: () => formulaireSondeur.setEmailList(0),
  //                             child: CircleAvatar(
  //                               backgroundColor:
  //                                   formulaireSondeur.emailList == 0
  //                                       ? noir
  //                                       : gris,
  //                               radius: 14,
  //                               child: Icon(
  //                                 CupertinoIcons.envelope,
  //                                 color: formulaireSondeur.emailList == 0
  //                                     ? blanc
  //                                     : noir,
  //                                 size: 14,
  //                               ),
  //                             ),
  //                           ),
  //                           paddingHorizontalGlobal(16),
  //                           GestureDetector(
  //                             onTap: () => formulaireSondeur.setEmailList(1),
  //                             child: CircleAvatar(
  //                               backgroundColor:
  //                                   formulaireSondeur.emailList == 1
  //                                       ? noir
  //                                       : gris,
  //                               radius: 14,
  //                               child: Icon(
  //                                 CupertinoIcons.link,
  //                                 color: formulaireSondeur.emailList == 1
  //                                     ? blanc
  //                                     : noir,
  //                                 size: 14,
  //                               ),
  //                             ),
  //                           ),
  //                           paddingHorizontalGlobal(16),
  //                           GestureDetector(
  //                             onTap: () => formulaireSondeur.setEmailList(2),
  //                             child: CircleAvatar(
  //                               backgroundColor:
  //                                   formulaireSondeur.emailList == 2
  //                                       ? noir
  //                                       : gris,
  //                               radius: 14,
  //                               child: Icon(
  //                                 CupertinoIcons.phone,
  //                                 color: formulaireSondeur.emailList == 2
  //                                     ? blanc
  //                                     : noir,
  //                                 size: 14,
  //                               ),
  //                             ),
  //                           ),
  //                           paddingHorizontalGlobal(16),
  //                           GestureDetector(
  //                             onTap: () => formulaireSondeur.setEmailList(3),
  //                             child: CircleAvatar(
  //                               backgroundColor:
  //                                   formulaireSondeur.emailList == 3
  //                                       ? noir
  //                                       : gris,
  //                               radius: 14,
  //                               child: ImageIcon(
  //                                   const AssetImage("/images/whatsapp.png"),
  //                                   size: 14,
  //                                   color: formulaireSondeur.emailList == 3
  //                                       ? blanc
  //                                       : noir),
  //                             ),
  //                           ),
  //                           paddingHorizontalGlobal(),
  //                         ],
  //                       ),
  //                     ),
  //                     paddingVerticalGlobal(),
  //                     if (formulaireSondeur.emailList == 0)
  //                       Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               paddingHorizontalGlobal(),
  //                               Text(
  //                                 "Email",
  //                                 style: TextStyle(
  //                                     fontSize: 14,
  //                                     color: noir,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                             ],
  //                           ),
  //                           Row(
  //                             children: [
  //                               paddingHorizontalGlobal(),
  //                               Expanded(
  //                                 child: KeyboardListener(
  //                                     focusNode: formulaireSondeur.focusNode,
  //                                     onKeyEvent: (value) {
  //                                       if (value.logicalKey.keyLabel ==
  //                                               "Enter" ||
  //                                           value.logicalKey.keyLabel ==
  //                                               "Tab") {
  //                                         formulaireSondeur.setContainer();
  //                                       }
  //                                     },
  //                                     child: TextField(
  //                                       controller: formulaireSondeur.emailCtlr,
  //                                       decoration: InputDecoration(
  //                                         labelText: "à".toUpperCase(),
  //                                         border: const UnderlineInputBorder(),
  //                                         enabledBorder:
  //                                             const UnderlineInputBorder(),
  //                                       ),
  //                                     )),
  //                               ),
  //                               paddingHorizontalGlobal(),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     if (formulaireSondeur.emailList == 1 ||
  //                         formulaireSondeur.emailList == 2 ||
  //                         formulaireSondeur.emailList == 3)
  //                       Column(
  //                         children: [
  //                           Row(
  //                             children: [
  //                               paddingHorizontalGlobal(),
  //                               Text(
  //                                 'Fichier : (csv ,xlsx)',
  //                                 style: TextStyle(
  //                                     fontSize: 14,
  //                                     color: noir,
  //                                     fontWeight: FontWeight.bold),
  //                               ),
  //                               const Spacer(),
  //                               GestureDetector(
  //                                 onTap: () => formulaireSondeur.getEmailFile(),
  //                                 child: Container(
  //                                   height: 30,
  //                                   // width: 120,
  //                                   decoration: BoxDecoration(
  //                                       borderRadius: BorderRadius.circular(3),
  //                                       color: noir),
  //                                   child: Row(
  //                                     children: [
  //                                       paddingHorizontalGlobal(4),
  //                                       Text(
  //                                         'Télecharger votre fichier',
  //                                         style: TextStyle(
  //                                           fontSize: 14,
  //                                           color: blanc,
  //                                         ),
  //                                       ),
  //                                       paddingHorizontalGlobal(4),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                               paddingHorizontalGlobal(),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     if (formulaireSondeur.emails.isNotEmpty)
  //                       paddingVerticalGlobal(),
  //                     if (formulaireSondeur.emails.isNotEmpty)
  //                       SizedBox(
  //                         height:
  //                             (formulaireSondeur.emails.length / 3).ceil() * 30,
  //                         // color: rouge,
  //                         child: GridView.count(
  //                           crossAxisCount: 3,
  //                           physics: const NeverScrollableScrollPhysics(),
  //                           mainAxisSpacing: 8,
  //                           // crossAxisSpacing: 16,
  //                           childAspectRatio: 8,

  //                           children: formulaireSondeur.emails
  //                               .map((e) => Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         horizontal: 8.0),
  //                                     child: Container(
  //                                       // height: 30,
  //                                       // width: 150,
  //                                       decoration: BoxDecoration(
  //                                           borderRadius:
  //                                               BorderRadius.circular(2),
  //                                           color: noir),
  //                                       child: Row(
  //                                         children: [
  //                                           paddingHorizontalGlobal(4),
  //                                           Text(e,
  //                                               style: TextStyle(
  //                                                   fontSize: 12,
  //                                                   color: blanc,
  //                                                   fontWeight:
  //                                                       FontWeight.w300)),
  //                                           paddingHorizontalGlobal(4),
  //                                           IconButton(
  //                                             onPressed: () => formulaireSondeur
  //                                                 .removeContainer(e),
  //                                             icon: Icon(
  //                                               Icons.delete,
  //                                               color: blanc,
  //                                               size: 12,
  //                                             ),
  //                                           ),
  //                                           paddingHorizontalGlobal(4),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ))
  //                               .toList(),
  //                         ),
  //                       ),
  //                     paddingVerticalGlobal(),
  //                     Row(
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         Expanded(
  //                           child: TextField(
  //                             controller: formulaireSondeur.objectCtrl,
  //                             decoration: const InputDecoration(
  //                               labelText: 'Object',
  //                               border: UnderlineInputBorder(),
  //                               enabledBorder: UnderlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                       ],
  //                     ),
  //                     paddingVerticalGlobal(),
  //                     Row(
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         Expanded(
  //                           child: TextField(
  //                             controller: formulaireSondeur.messageCtrl,
  //                             decoration: const InputDecoration(
  //                               labelText: 'Message',
  //                               border: UnderlineInputBorder(),
  //                               enabledBorder: UnderlineInputBorder(),
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                       ],
  //                     ),
  //                     paddingVerticalGlobal(),
  //                     Row(
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         IconButton(
  //                           onPressed: () =>
  //                               formulaireSondeur.setInclureFormEmail(),
  //                           icon: formulaireSondeur.inclureFormEmail == 0
  //                               ? Icon(
  //                                   Icons.square_outlined,
  //                                   color: noir,
  //                                 )
  //                               : Icon(
  //                                   Icons.square,
  //                                   color: noir,
  //                                 ),
  //                         ),
  //                         paddingHorizontalGlobal(4),
  //                         Text(
  //                           "Inclure le formulaire dans l'e-mail",
  //                           style: TextStyle(fontSize: 14, color: noir),
  //                         )
  //                       ],
  //                     ),
  //                     paddingVerticalGlobal(),
  //                     Row(
  //                       children: [
  //                         paddingHorizontalGlobal(),
  //                         IconButton(
  //                           onPressed: () =>
  //                               formulaireSondeur.setInclureFormEmailPassword(),
  //                           icon:
  //                               formulaireSondeur.inclureFormEmailPassword == 0
  //                                   ? Icon(
  //                                       Icons.square_outlined,
  //                                       color: noir,
  //                                     )
  //                                   : Icon(
  //                                       Icons.square,
  //                                       color: noir,
  //                                     ),
  //                         ),
  //                         paddingHorizontalGlobal(4),
  //                         Text(
  //                           "Inclure mot de passe pour se connecter avant de repondre",
  //                           style: TextStyle(fontSize: 14, color: noir),
  //                         )
  //                       ],
  //                     ),
  //                     paddingVerticalGlobal(),
  //                     const Spacer(),
  //                     Row(
  //                       children: [
  //                         const Spacer(),
  //                         GestureDetector(
  //                           onTap: () => formulaireSondeur.setShowEnvoyer(0),
  //                           child: Container(
  //                             height: 30,
  //                             width: 80,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(6),
  //                                 color: gris),
  //                             child: Center(
  //                               child: Text(
  //                                 'Annuler',
  //                                 style: TextStyle(fontSize: 14, color: noir),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                         GestureDetector(
  //                           onTap:
  //                               formulaireSondeur.chargementEnvoieFormulaire ==
  //                                       false
  //                                   ? () => formulaireSondeur.sendFormulaire()
  //                                   : () => null,
  //                           child: Container(
  //                             height: 30,
  //                             width: 80,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(6),
  //                                 color: noir),
  //                             child: Center(
  //                               child:
  //                                   formulaireSondeur.chargementEnvoieFormulaire
  //                                       ? CircularProgressIndicator(
  //                                           backgroundColor: noir,
  //                                           color: blanc,
  //                                         )
  //                                       : Text(
  //                                           'Envoyer',
  //                                           style: TextStyle(
  //                                               fontSize: 14, color: blanc),
  //                                         ),
  //                             ),
  //                           ),
  //                         ),
  //                         paddingHorizontalGlobal(),
  //                       ],
  //                     ),
  //                     paddingVerticalGlobal(),
  //                   ],
  //                 ),
  //               )),
  //       ],
  //     ),
  //   );
  // }
}
