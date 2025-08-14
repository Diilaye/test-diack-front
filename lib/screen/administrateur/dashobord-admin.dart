import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:form/blocs/matiere-bloc.dart';
import 'package:form/screen/administrateur/add-user-screen.dart';
import 'package:form/screen/administrateur/annee-academique/add-annee-academique-screen.dart';
import 'package:form/screen/administrateur/annee-academique/edit-annee-academique-screen.dart';
import 'package:form/screen/administrateur/edit-user-screen.dart';
import 'package:form/screen/administrateur/formulaire/add.dart';
import 'package:form/screen/administrateur/liste-user-screen.dart';
import 'package:form/screen/administrateur/matieres/add-matiere-screen.dart';
import 'package:form/screen/administrateur/matieres/edit-matiere-screen.dart';
import 'package:form/screen/administrateur/matieres/liste-matiere-screen.dart';
import 'package:form/screen/administrateur/matieres/view-matiere-scrren.dart';
import 'package:form/screen/administrateur/niveau-academique/add-niveau-academique-screen.dart';
import 'package:form/screen/administrateur/niveau-academique/edit-niveau-academique-screen.dart';
import 'package:form/screen/administrateur/overview-screen.dart';
import 'package:form/screen/administrateur/view-user-screen.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

class DashbordAdminScreen extends StatelessWidget {
  const DashbordAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final adminBloc = Provider.of<AdminBloc>(context);
    final matiereBloc = Provider.of<MatiereBloc>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: .0,
        elevation: .0,
      ),
      backgroundColor: blanc,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Row(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(color: blanc, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 10,
                    color: noir.withOpacity(.2))
              ]),
              child: ListView(
                children: [
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * .025,
                      ),
                      Text(
                        'Simplon'.toUpperCase(),
                        style: TextStyle(color: noir),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  GestureDetector(
                    onTap: () => adminBloc.setMenu(0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width * .025,
                        ),
                        Text(
                          'Dashbord',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: noir),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  GestureDetector(
                    onTap: () => adminBloc.setMenu(0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: adminBloc.menu == 0
                              ? gris.withOpacity(.3)
                              : blanc),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .03,
                              ),
                              const Icon(
                                Icons.dashboard,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Overview',
                                style: TextStyle(fontSize: 14, color: noir),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .025,
                      ),
                      Text(
                        'Utilisateur',
                        style: TextStyle(fontSize: 14, color: noir),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  GestureDetector(
                    onTap: () => adminBloc.setMenu(1),
                    child: Container(
                      color: adminBloc.menu == 1 ? gris.withOpacity(.3) : blanc,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .03,
                              ),
                              const Icon(
                                CupertinoIcons.add,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'ajouter',
                                style: TextStyle(fontSize: 14, color: noir),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => adminBloc.setMenu(10),
                    child: Container(
                      color:
                          adminBloc.menu == 10 ? gris.withOpacity(.3) : blanc,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .03,
                              ),
                              const Icon(
                                CupertinoIcons.square_list,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'liste',
                                style: TextStyle(fontSize: 14, color: noir),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .025,
                      ),
                      Text(
                        'Matiere',
                        style: TextStyle(fontSize: 14, color: noir),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  GestureDetector(
                    onTap: () {
                      matiereBloc.setMatiere(null);
                      adminBloc.setMenu(2);
                    },
                    child: Container(
                      color: adminBloc.menu == 2 ? gris.withOpacity(.3) : blanc,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .03,
                              ),
                              const Icon(
                                CupertinoIcons.add,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'ajouter',
                                style: TextStyle(fontSize: 14, color: noir),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => adminBloc.setMenu(20),
                    child: Container(
                      color:
                          adminBloc.menu == 20 ? gris.withOpacity(.3) : blanc,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .03,
                              ),
                              const Icon(
                                CupertinoIcons.square_list,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'liste',
                                style: TextStyle(fontSize: 14, color: noir),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .025,
                      ),
                      Text(
                        'Formulaire',
                        style: TextStyle(fontSize: 14, color: noir),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  GestureDetector(
                    onTap: () => adminBloc.setMenu(5),
                    child: Container(
                      color: adminBloc.menu == 5 ? gris.withOpacity(.3) : blanc,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * .03,
                              ),
                              const Icon(
                                CupertinoIcons.add,
                                size: 13,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'Paramétrages',
                                style: TextStyle(fontSize: 14, color: noir),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * .03,
                          ),
                          const Icon(
                            CupertinoIcons.square_list,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'liste',
                            style: TextStyle(fontSize: 14, color: noir),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * .025,
                          ),
                          const Icon(
                            CupertinoIcons.headphones,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Help & Support',
                            style: TextStyle(fontSize: 14, color: noir),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * .025,
                          ),
                          const Icon(
                            CupertinoIcons.settings,
                            size: 13,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Paramètres',
                            style: TextStyle(fontSize: 14, color: noir),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * .01,
                  ),
                  GestureDetector(
                    onTap: () => dialogRequest(
                            context: context,
                            title: "Voullez-vous vous déconectez ?")
                        .then((value) {
                      if (value) {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.clear();
                          js.context.callMethod('open',
                              ['https://test-diag.saharux.com/', '_self']);
                        });
                      }
                    }),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * .03,
                            ),
                            const Icon(
                              Icons.logout_rounded,
                              size: 13,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Déconnection',
                              style: TextStyle(fontSize: 14, color: noir),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                flex: 4,
                child: Container(
                    decoration: BoxDecoration(color: blanc, boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 0),
                          blurRadius: .3,
                          color: noir.withOpacity(.2))
                    ]),
                    child: adminBloc.menu == 0
                        ? const OverviewScreen()
                        : adminBloc.menu == 1
                            ? const AddUserScreen()
                            : adminBloc.menu == 10
                                ? const ListeUserScreen()
                                : adminBloc.menu == 11
                                    ? const ViewUserScreen()
                                    : adminBloc.menu == 12
                                        ? const EditUserScreen()
                                        : adminBloc.menu == 2
                                            ? const AddMatiereScreen()
                                            : adminBloc.menu == 20
                                                ? const ListeMatiereScreen()
                                                : adminBloc.menu == 21
                                                    ? const ViewMatiereScreen()
                                                    : adminBloc.menu == 22
                                                        ? const EditMatiereScreen()
                                                        : adminBloc.menu == 3
                                                            ? const AddNiveauAcademiqueScreen()
                                                            : adminBloc.menu ==
                                                                    32
                                                                ? const EditNiveauAcademiqueScreen()
                                                                : adminBloc.menu ==
                                                                        4
                                                                    ? const AddAnneeAcademiqueScreen()
                                                                    : adminBloc.menu ==
                                                                            42
                                                                        ? const EditAnneeAcademiqueScreen()
                                                                        : adminBloc.menu ==
                                                                                5
                                                                            ? const AddFormulaireScreen()
                                                                            : Container())),
          ],
        ),
      ),
    );
  }
}
