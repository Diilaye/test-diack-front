import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/blocs/folder-bloc.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/screen/sondeur/components/menu-item.dart';
import 'package:form/screen/sondeur/page-extentions/add-folder.dart';
import 'package:form/screen/sondeur/page-extentions/liste-formulaire.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:provider/provider.dart';

class IndexSondeur extends StatelessWidget {
  const IndexSondeur({super.key});

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Simplon formulaire'.toUpperCase()),
        titleTextStyle: TextStyle(color: blanc, fontWeight: FontWeight.bold),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => formulaireSondeur.showMenuProfil == 0
                  ? formulaireSondeur.setMenuProfil(1)
                  : formulaireSondeur.setMenuProfil(0),
              child: CircleAvatar(
                backgroundColor: blanc,
                child: Text(
                  authBloc.userModel == null
                      ? ""
                      : authBloc.userModel!.nom!.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: () => formulaireSondeur.showMenuProfil == 1
                  ? formulaireSondeur.setMenuProfil(0)
                  : null,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      color: blanc,
                      child: Column(
                        children: [
                          Container(
                            height: 64,
                            color: gris,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () => folderBloc.setFolder(null),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.folder,
                                        size: 12,
                                      ),
                                      paddingHorizontalGlobal(8),
                                      Text(
                                        'Mes dossier',
                                        style: TextStyle(
                                            color: noir,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      paddingHorizontalGlobal(8),
                                      Text(
                                        '(${folderBloc.folders.length})',
                                        style: TextStyle(
                                            color: noir,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                paddingHorizontalGlobal(8),
                                IconButton(
                                  onPressed: () => formulaireSondeur
                                              .openMenuFolder ==
                                          0
                                      ? formulaireSondeur.setOpenMenuFolder(1)
                                      : formulaireSondeur.setOpenMenuFolder(0),
                                  icon: Icon(
                                    formulaireSondeur.openMenuFolder == 0
                                        ? CupertinoIcons.chevron_up
                                        : CupertinoIcons.chevron_down,
                                    size: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (formulaireSondeur.openMenuFolder == 1)
                            Column(
                              children: [
                                ...folderBloc.folders
                                    .map((e) => GestureDetector(
                                          onTap: () => folderBloc.setFolder(e),
                                          child: Container(
                                            height: 48,
                                            color: blanc,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.folder_solid,
                                                  size: 24,
                                                  color: e.color!.toColor(),
                                                ),
                                                paddingHorizontalGlobal(8),
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    e.titre!,
                                                    style: TextStyle(
                                                        color: noir,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                paddingHorizontalGlobal(8),
                                GestureDetector(
                                  onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AddFolderDialog(),
                                  ),
                                  child: Container(
                                    height: 48,
                                    color: blanc,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          CupertinoIcons.add,
                                          size: 12,
                                        ),
                                        paddingHorizontalGlobal(8),
                                        Text(
                                          'Creer un dossier',
                                          style: TextStyle(
                                              color: noir,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: gris, width: 1)),
                                color: blanc,
                                borderRadius: BorderRadius.circular(0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.archivebox,
                                  size: 12,
                                ),
                                paddingHorizontalGlobal(8),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Mes Archives',
                                    style: TextStyle(
                                        color: noir,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                    " (${formulaireSondeur.formulaires.where((e) => e.archived == "1").length})",
                                    style: TextStyle(
                                        color: noir,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          paddingHorizontalGlobal(8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: gris, width: 1)),
                                color: blanc,
                                borderRadius: BorderRadius.circular(0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.trash,
                                  size: 12,
                                ),
                                paddingHorizontalGlobal(8),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Corbeille',
                                    style: TextStyle(
                                        color: noir,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                    " (${formulaireSondeur.formulaires.where((e) => e.deleted == "1").length})",
                                    style: TextStyle(
                                        color: noir,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          paddingHorizontalGlobal(8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: gris, width: 1)),
                                color: blanc,
                                borderRadius: BorderRadius.circular(0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.paperplane,
                                  size: 12,
                                ),
                                paddingHorizontalGlobal(8),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    'Mes soumissions',
                                    style: TextStyle(
                                        color: noir,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(" (2)",
                                    style: TextStyle(
                                        color: noir,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          paddingVerticalGlobal(58)
                        ],
                      ),
                    )),
                    const Expanded(flex: 5, child: ListeFormulaireSection()),
                  ],
                ),
              ),
            ),
          ),
          if (formulaireSondeur.showMenuProfil == 1)
            Positioned(
              top: 10,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                opacity: formulaireSondeur.showMenuProfil == 1 ? 1 : 0,
                child: Container(
                  height: 420,
                  width: 300,
                  decoration: BoxDecoration(
                      color: blanc,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: noir.withOpacity(.2),
                            blurRadius: 10,
                            spreadRadius: 2)
                      ]),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: gris,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8))),
                        height: 64,
                        child: Row(
                          children: [
                            paddingHorizontalGlobal(8),
                            CircleAvatar(
                              backgroundColor: primary,
                              child: Text(
                                authBloc.userModel == null
                                    ? ""
                                    : authBloc.userModel!.nom!
                                        .substring(0, 1)
                                        .toUpperCase(),
                                style: TextStyle(
                                    color: blanc,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            paddingHorizontalGlobal(8),
                            Text(
                              authBloc.userModel == null
                                  ? ""
                                  : "${authBloc.userModel!.nom!} ${authBloc.userModel!.prenom!}"
                                      .toUpperCase(),
                              style: TextStyle(
                                color: primary,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  color: noir,
                                  borderRadius: BorderRadius.circular(2)),
                              child: Row(
                                children: [
                                  paddingHorizontalGlobal(4),
                                  Text(
                                    'Free'.toUpperCase(),
                                    style: TextStyle(
                                      color: blanc,
                                      fontSize: 12,
                                    ),
                                  ),
                                  paddingHorizontalGlobal(4),
                                ],
                              ),
                            ),
                            paddingHorizontalGlobal(8),
                          ],
                        ),
                      ),
                      paddingHorizontalGlobal(8),
                      MenuItem(
                        titre: 'Mon profil',
                        icons: CupertinoIcons.person_alt_circle,
                        showbadge: 1,
                        badge: 'new',
                        color: jaune,
                        hover: formulaireSondeur.menuNumber == 1 ? true : false,
                        onHover: () => formulaireSondeur.setMenuNumber(1),
                        onOutHover: () => formulaireSondeur.setMenuNumber(0),
                      ),
                      MenuItem(
                        titre: 'Mes formulaires',
                        icons: CupertinoIcons.doc,
                        showbadge: 1,
                        badge: formulaireSondeur.formulaires.length.toString(),
                        color: rouge,
                        radius: 2,
                        hover: formulaireSondeur.menuNumber == 2 ? true : false,
                        onHover: () => formulaireSondeur.setMenuNumber(2),
                        onOutHover: () => formulaireSondeur.setMenuNumber(0),
                      ),
                      MenuItem(
                        titre: 'Comptes',
                        icons: CupertinoIcons.settings,
                        showbadge: 0,
                        badge: '2',
                        color: rouge,
                        radius: 2,
                        hover: formulaireSondeur.menuNumber == 3 ? true : false,
                        onHover: () => formulaireSondeur.setMenuNumber(3),
                        onOutHover: () => formulaireSondeur.setMenuNumber(0),
                      ),
                      MenuItem(
                        titre: 'Help & Support',
                        icons: CupertinoIcons.globe,
                        showbadge: 0,
                        badge: '2',
                        color: rouge,
                        radius: 2,
                        hover: formulaireSondeur.menuNumber == 4 ? true : false,
                        onHover: () => formulaireSondeur.setMenuNumber(4),
                        onOutHover: () => formulaireSondeur.setMenuNumber(0),
                      ),
                      MenuItem(
                        titre: "What's news",
                        icons: CupertinoIcons.news,
                        showbadge: 0,
                        badge: '2',
                        color: rouge,
                        radius: 2,
                        hover: formulaireSondeur.menuNumber == 5 ? true : false,
                        onHover: () => formulaireSondeur.setMenuNumber(5),
                        onOutHover: () => formulaireSondeur.setMenuNumber(0),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: noir,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8))),
                        height: 64,
                        child: GestureDetector(
                          onTap: () => authBloc.logout(context),
                          child: Row(
                            children: [
                              paddingHorizontalGlobal(8),
                              Icon(
                                CupertinoIcons.power,
                                color: blanc,
                              ),
                              paddingHorizontalGlobal(8),
                              Text(
                                "Se déconnecter".toUpperCase(),
                                style: TextStyle(
                                  color: blanc,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
