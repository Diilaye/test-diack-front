import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/champs-bloc.dart';
import 'package:form/blocs/formulaire-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/screen/sondeur/widget/question-sondeur-widget.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/upload-file.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FormSondeurScreen extends StatelessWidget {
  const FormSondeurScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final champsBloc = Provider.of<ChampsBloc>(context);
    return Scaffold(
      backgroundColor: blanc,
      appBar: AppBar(
        elevation: .0,
        toolbarHeight: .0,
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Container(
                height: 120,
                width: size.width,
                color: rouge,
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 60,
                      width: size.width,
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
                          SizedBox(
                            width: 300.0,
                            child: TextField(
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: blanc),
                              onSubmitted: (value) =>
                                  formulaireSondeur.updateTitreForm(value),
                              controller: formulaireSondeur.titreCtrl,
                              cursorColor: blanc,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: formulaireSondeur
                                      .formulaireSondeurModel!.titre!),
                            ),
                          ),
                          paddingHorizontalGlobal(8),
                          // Icon(
                          //   CupertinoIcons.star,
                          //   size: 14,
                          //   color: blanc,
                          // ),
                          const Spacer(),
                          IconButton(
                              tooltip: 'Apercu',
                              onPressed: () {
                                formulaireSondeur.setSelectedFormSondeurModel(
                                    formulaireSondeur.formulaireSondeurModel!);
                                context.go(
                                    '/formulaire-view/${formulaireSondeur.formulaireSondeurModel!.id!}');
                              },
                              icon: Icon(
                                CupertinoIcons.eye,
                                color: blanc,
                              )),
                          paddingHorizontalGlobal(8),
                          GestureDetector(
                            onTap: () => formulaireSondeur.setShowEnvoyer(1),
                            child: Container(
                                height: 35,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: noir,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Center(
                                    child: Text(
                                  'Envoyer',
                                  style: TextStyle(fontSize: 14, color: blanc),
                                ))),
                          ),
                          paddingHorizontalGlobal(24),

                          CircleAvatar(
                            backgroundColor: blanc,
                            child: Center(
                              child: Text(
                                'S',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: rouge),
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: size.width,
                      height: 30,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () => formulaireSondeur.setShowMenu(0),
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  Text(
                                    'Questions',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: blanc),
                                  ),
                                  paddingVerticalGlobal(2),
                                  Container(
                                    width: 70,
                                    height: 2,
                                    color: formulaireSondeur.showMenu == 0
                                        ? blanc
                                        : rouge,
                                  )
                                ],
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                          GestureDetector(
                            onTap: () => formulaireSondeur.setShowMenu(1),
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  Text(
                                    'Réponses',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: blanc),
                                  ),
                                  paddingVerticalGlobal(2),
                                  Container(
                                    width: 70,
                                    height: 2,
                                    color: formulaireSondeur.showMenu == 1
                                        ? blanc
                                        : rouge,
                                  )
                                ],
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                          GestureDetector(
                            onTap: () => formulaireSondeur.setShowMenu(2),
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  Text(
                                    'Paramètres',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: blanc),
                                  ),
                                  paddingVerticalGlobal(2),
                                  Container(
                                    width: 70,
                                    height: 2,
                                    color: formulaireSondeur.showMenu == 2
                                        ? blanc
                                        : rouge,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )),
          Positioned(
              top: 120,
              child: formulaireSondeur.showMenu == 0
                  ? Container(
                      height: size.height,
                      width: size.width,
                      color: gris,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          paddingHorizontalGlobal(),
                          SizedBox(
                            height: size.height,
                            width: size.width * .78,
                            child: ListView(
                              children: [
                                paddingVerticalGlobal(8),
                                Container(
                                  height: 150,
                                  width: size.width * .75,
                                  decoration: BoxDecoration(
                                      color: blanc,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                      border: Border(
                                          top: BorderSide(
                                              width: 5, color: rouge))),
                                  child: Column(
                                    children: [
                                      paddingVerticalGlobal(),
                                      Row(
                                        children: [
                                          paddingHorizontalGlobal(),
                                          SizedBox(
                                            width: 600.0,
                                            child: TextField(
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: noir),
                                              onSubmitted: (value) =>
                                                  formulaireSondeur
                                                      .updateTitreForm(value),
                                              controller:
                                                  formulaireSondeur.titreCtrl,
                                              cursorColor: blanc,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: formulaireSondeur
                                                      .formulaireSondeurModel!
                                                      .titre!),
                                            ),
                                          ),
                                        ],
                                      ),
                                      paddingVerticalGlobal(4),
                                      Row(
                                        children: [
                                          paddingHorizontalGlobal(),
                                          SizedBox(
                                            width: size.width * .7,
                                            child: TextField(
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: noir),
                                              onSubmitted: (value) =>
                                                  formulaireSondeur
                                                      .updateDescrForm(value),
                                              controller:
                                                  formulaireSondeur.descCtrl,
                                              cursorColor: noir,
                                              decoration: InputDecoration(
                                                  border:
                                                      const OutlineInputBorder(),
                                                  hintText: formulaireSondeur
                                                      .formulaireSondeurModel!
                                                      .description),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                paddingVerticalGlobal(8),
                                ...formulaireSondeur.listeChampForm
                                    .map((e) => QuestionSondeurWidget(
                                          champ: e,
                                        ))
                                    .toList(),
                                paddingVerticalGlobal(200),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height,
                            width: size.width * .05,
                            child: Column(
                              children: [
                                paddingVerticalGlobal(8),
                                CircleAvatar(
                                  backgroundColor: rouge,
                                  child: IconButton(
                                      onPressed: () async {
                                        formulaireSondeur.addChampFormulaire(
                                            formulaireSondeur
                                                .formulaireSondeurModel!.id!);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.add_circled,
                                        color: blanc,
                                      ),
                                      tooltip: 'Ajouter une question'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : formulaireSondeur.showMenu == 1
                      ? Container(
                          height: size.height - 120,
                          width: size.width,
                          color: blanc,
                        )
                      : Container(
                          height: size.height - 120,
                          width: size.width,
                          color: blanc,
                        )),
          if (formulaireSondeur.showEnvoyer == 1)
            Positioned(
                child: Container(
              color: noir.withOpacity(.5),
            )),
          if (formulaireSondeur.showEnvoyer == 1)
            Positioned(
                top: 80,
                left: size.width * .25,
                right: size.width * .25,
                child: Container(
                  height: size.height * .7,
                  width: size.width * .5,
                  decoration: BoxDecoration(
                      color: gris,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: noir.withOpacity(.2), blurRadius: 2)
                      ]),
                  child: Column(
                    children: [
                      paddingVerticalGlobal(),
                      Row(
                        children: [
                          paddingHorizontalGlobal(),
                          Text(
                            'Envoyer le formulaire',
                            style: TextStyle(
                                fontSize: 20,
                                color: rouge,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () =>
                                  formulaireSondeur.setShowEnvoyer(0),
                              icon: Icon(Icons.close)),
                          paddingHorizontalGlobal(),
                        ],
                      ),
                      paddingVerticalGlobal(8),
                      Container(
                        height: 60,
                        color: noir.withOpacity(.3),
                        child: Row(
                          children: [
                            paddingHorizontalGlobal(),
                            const Text('Collecter les adresses e-mail'),
                            const Spacer(),
                            DropdownButton(
                                value: formulaireSondeur.collecterEmail,
                                items: [
                                  'Ne pas collecter',
                                  'activer la collection',
                                  'Information saisie par le sondé'
                                ]
                                    .map((e) => DropdownMenuItem(
                                          value: e.toLowerCase().trim(),
                                          child: Text(
                                            e.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 13, color: noir),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (v) =>
                                    formulaireSondeur.setCollecterEmail(
                                        v!.toLowerCase().trim())),
                            paddingHorizontalGlobal(),
                          ],
                        ),
                      ),
                      paddingHorizontalGlobal(),
                      Container(
                        height: 45,
                        child: Row(
                          children: [
                            paddingHorizontalGlobal(),
                            Text(
                              "Envoyer via ",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: noir,
                                  fontWeight: FontWeight.bold),
                            ),
                            paddingHorizontalGlobal(32),
                            GestureDetector(
                              onTap: () => formulaireSondeur.setEmailList(0),
                              child: CircleAvatar(
                                backgroundColor:
                                    formulaireSondeur.emailList == 0
                                        ? noir
                                        : gris,
                                radius: 14,
                                child: Icon(
                                  CupertinoIcons.envelope,
                                  color: formulaireSondeur.emailList == 0
                                      ? blanc
                                      : noir,
                                  size: 14,
                                ),
                              ),
                            ),
                            paddingHorizontalGlobal(16),
                            GestureDetector(
                              onTap: () => formulaireSondeur.setEmailList(1),
                              child: CircleAvatar(
                                backgroundColor:
                                    formulaireSondeur.emailList == 1
                                        ? noir
                                        : gris,
                                radius: 14,
                                child: Icon(
                                  CupertinoIcons.link,
                                  color: formulaireSondeur.emailList == 1
                                      ? blanc
                                      : noir,
                                  size: 14,
                                ),
                              ),
                            ),
                            paddingHorizontalGlobal(16),
                            GestureDetector(
                              onTap: () => formulaireSondeur.setEmailList(2),
                              child: CircleAvatar(
                                backgroundColor:
                                    formulaireSondeur.emailList == 2
                                        ? noir
                                        : gris,
                                radius: 14,
                                child: Icon(
                                  CupertinoIcons.phone,
                                  color: formulaireSondeur.emailList == 2
                                      ? blanc
                                      : noir,
                                  size: 14,
                                ),
                              ),
                            ),
                            paddingHorizontalGlobal(16),
                            GestureDetector(
                              onTap: () => formulaireSondeur.setEmailList(3),
                              child: CircleAvatar(
                                backgroundColor:
                                    formulaireSondeur.emailList == 3
                                        ? noir
                                        : gris,
                                radius: 14,
                                child: ImageIcon(
                                    const AssetImage("/images/whatsapp.png"),
                                    size: 14,
                                    color: formulaireSondeur.emailList == 3
                                        ? blanc
                                        : noir),
                              ),
                            ),
                            paddingHorizontalGlobal(),
                          ],
                        ),
                      ),
                      paddingVerticalGlobal(),
                      if (formulaireSondeur.emailList == 0)
                        Column(
                          children: [
                            Row(
                              children: [
                                paddingHorizontalGlobal(),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: noir,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                paddingHorizontalGlobal(),
                                Expanded(
                                  child: KeyboardListener(
                                      focusNode: formulaireSondeur.focusNode,
                                      onKeyEvent: (value) {
                                        if (value.logicalKey.keyLabel ==
                                                "Enter" ||
                                            value.logicalKey.keyLabel ==
                                                "Tab") {
                                          formulaireSondeur.setContainer();
                                        }
                                      },
                                      child: TextField(
                                        controller: formulaireSondeur.emailCtlr,
                                        decoration: InputDecoration(
                                          labelText: "à".toUpperCase(),
                                          border: const UnderlineInputBorder(),
                                          enabledBorder:
                                              const UnderlineInputBorder(),
                                        ),
                                      )),
                                ),
                                paddingHorizontalGlobal(),
                              ],
                            ),
                          ],
                        ),
                      if (formulaireSondeur.emailList == 1 ||
                          formulaireSondeur.emailList == 2 ||
                          formulaireSondeur.emailList == 3)
                        Column(
                          children: [
                            Row(
                              children: [
                                paddingHorizontalGlobal(),
                                Text(
                                  'Fichier : (csv ,xlsx)',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: noir,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => formulaireSondeur.getEmailFile(),
                                  child: Container(
                                    height: 30,
                                    // width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: noir),
                                    child: Row(
                                      children: [
                                        paddingHorizontalGlobal(4),
                                        Text(
                                          'Télecharger votre fichier',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: blanc,
                                          ),
                                        ),
                                        paddingHorizontalGlobal(4),
                                      ],
                                    ),
                                  ),
                                ),
                                paddingHorizontalGlobal(),
                              ],
                            ),
                          ],
                        ),
                      if (formulaireSondeur.emails.isNotEmpty)
                        paddingVerticalGlobal(),
                      if (formulaireSondeur.emails.isNotEmpty)
                        SizedBox(
                          height:
                              (formulaireSondeur.emails.length / 3).ceil() * 30,
                          // color: rouge,
                          child: GridView.count(
                            crossAxisCount: 3,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            // crossAxisSpacing: 16,
                            childAspectRatio: 8,

                            children: formulaireSondeur.emails
                                .map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        // height: 30,
                                        // width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: noir),
                                        child: Row(
                                          children: [
                                            paddingHorizontalGlobal(4),
                                            Text(e,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: blanc,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                            paddingHorizontalGlobal(4),
                                            IconButton(
                                              onPressed: () => formulaireSondeur
                                                  .removeContainer(e),
                                              icon: Icon(
                                                Icons.delete,
                                                color: blanc,
                                                size: 12,
                                              ),
                                            ),
                                            paddingHorizontalGlobal(4),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      paddingVerticalGlobal(),
                      Row(
                        children: [
                          paddingHorizontalGlobal(),
                          Expanded(
                            child: TextField(
                              controller: formulaireSondeur.objectCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Object',
                                border: UnderlineInputBorder(),
                                enabledBorder: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                        ],
                      ),
                      paddingVerticalGlobal(),
                      Row(
                        children: [
                          paddingHorizontalGlobal(),
                          Expanded(
                            child: TextField(
                              controller: formulaireSondeur.messageCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Message',
                                border: UnderlineInputBorder(),
                                enabledBorder: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                        ],
                      ),
                      paddingVerticalGlobal(),
                      Row(
                        children: [
                          paddingHorizontalGlobal(),
                          IconButton(
                            onPressed: () =>
                                formulaireSondeur.setInclureFormEmail(),
                            icon: formulaireSondeur.inclureFormEmail == 0
                                ? Icon(
                                    Icons.square_outlined,
                                    color: noir,
                                  )
                                : Icon(
                                    Icons.square,
                                    color: noir,
                                  ),
                          ),
                          paddingHorizontalGlobal(4),
                          Text(
                            "Inclure le formulaire dans l'e-mail",
                            style: TextStyle(fontSize: 14, color: noir),
                          )
                        ],
                      ),
                      paddingVerticalGlobal(),
                      Row(
                        children: [
                          paddingHorizontalGlobal(),
                          IconButton(
                            onPressed: () =>
                                formulaireSondeur.setInclureFormEmailPassword(),
                            icon:
                                formulaireSondeur.inclureFormEmailPassword == 0
                                    ? Icon(
                                        Icons.square_outlined,
                                        color: noir,
                                      )
                                    : Icon(
                                        Icons.square,
                                        color: noir,
                                      ),
                          ),
                          paddingHorizontalGlobal(4),
                          Text(
                            "Inclure mot de passe pour se connecter avant de repondre",
                            style: TextStyle(fontSize: 14, color: noir),
                          )
                        ],
                      ),
                      paddingVerticalGlobal(),
                      const Spacer(),
                      Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () => formulaireSondeur.setShowEnvoyer(0),
                            child: Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: gris),
                              child: Center(
                                child: Text(
                                  'Annuler',
                                  style: TextStyle(fontSize: 14, color: noir),
                                ),
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                          GestureDetector(
                            onTap:
                                formulaireSondeur.chargementEnvoieFormulaire ==
                                        false
                                    ? () => formulaireSondeur.sendFormulaire()
                                    : () => null,
                            child: Container(
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: noir),
                              child: Center(
                                child:
                                    formulaireSondeur.chargementEnvoieFormulaire
                                        ? CircularProgressIndicator(
                                            backgroundColor: noir,
                                            color: blanc,
                                          )
                                        : Text(
                                            'Envoyer',
                                            style: TextStyle(
                                                fontSize: 14, color: blanc),
                                          ),
                              ),
                            ),
                          ),
                          paddingHorizontalGlobal(),
                        ],
                      ),
                      paddingVerticalGlobal(),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
