import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/screen/entreprise/complete-entreprise.dart';
import 'package:form/screen/entreprise/overview.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashbordEntrepriseScreen extends StatelessWidget {
  const DashbordEntrepriseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final adminBloc = Provider.of<AdminBloc>(context);
    final authBloc = Provider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: .0,
        elevation: .0,
      ),
      backgroundColor: blanc,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: authBloc.userModel == null
            ? CircularProgressIndicator(
                color: noir,
                backgroundColor: blanc,
              )
            : Row(
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
                              authBloc.userModel!.nom!.toLowerCase(),
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
                                      style:
                                          TextStyle(fontSize: 14, color: noir),
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
                            color: adminBloc.menu == 1
                                ? gris.withOpacity(.3)
                                : blanc,
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
                                      style:
                                          TextStyle(fontSize: 14, color: noir),
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
                            color: adminBloc.menu == 10
                                ? gris.withOpacity(.3)
                                : blanc,
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
                                      style:
                                          TextStyle(fontSize: 14, color: noir),
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
                            adminBloc.setMenu(2);
                          },
                          child: Container(
                            color: adminBloc.menu == 2
                                ? gris.withOpacity(.3)
                                : blanc,
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
                                      style:
                                          TextStyle(fontSize: 14, color: noir),
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
                            color: adminBloc.menu == 20
                                ? gris.withOpacity(.3)
                                : blanc,
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
                                      style:
                                          TextStyle(fontSize: 14, color: noir),
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
                            color: adminBloc.menu == 5
                                ? gris.withOpacity(.3)
                                : blanc,
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
                                      style:
                                          TextStyle(fontSize: 14, color: noir),
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
                                Navigator.pushNamed(context, "/");
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
                              ? authBloc.userModel!.isProfileComplete! == "0"
                                  ? const CompleteEntreprise()
                                  : const OverViewEntreprise()
                              : Container())),
                ],
              ),
      ),
    );
  }
}
