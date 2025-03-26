import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';

class ListeUserScreen extends StatefulWidget {
  const ListeUserScreen({super.key});

  @override
  State<ListeUserScreen> createState() => _ListeUserScreenState();
}

class _ListeUserScreenState extends State<ListeUserScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final adminBloc = Provider.of<AdminBloc>(context);

    return ListView(
      children: [
        SizedBox(
          height: size.height * .02,
        ),
        Row(
          children: [
            SizedBox(
              width: size.width * .01,
            ),
            const Text(
              'Liste des utilisateurs',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: size.height * .02,
        ),
        SizedBox(
            height: size.height * .7,
            width: size.width,
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Column(
                  children: [
                    const Row(
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(flex: 1, child: Text("Nom complet")),
                        Expanded(flex: 1, child: Text("Email")),
                        Expanded(child: Text("Fonction")),
                        Expanded(child: Text("Téléphone")),
                        Expanded(child: Text("Adresse")),
                        Expanded(flex: 1, child: Text("Action")),
                        SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                        child: ListView(
                      children: adminBloc.users
                          .map(
                            (e) => Row(
                              children: [
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${e.prenom} ${e.nom}".toUpperCase(),
                                      style:
                                          TextStyle(fontSize: 10, color: noir),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      e.email!,
                                      style:
                                          TextStyle(fontSize: 10, color: noir),
                                    )),
                                Expanded(
                                    child: Text(
                                  e.fonction!,
                                  style: TextStyle(fontSize: 10, color: noir),
                                )),
                                Expanded(
                                    child: Text(
                                  e.telephone!,
                                  style: TextStyle(fontSize: 10, color: noir),
                                )),
                                Expanded(
                                    child: Text(
                                  e.adresse!,
                                  style: TextStyle(fontSize: 10, color: noir),
                                )),
                                Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.eye_solid,
                                            size: 14,
                                          ),
                                          onPressed: () {
                                            adminBloc.setUser(e);
                                            adminBloc.setMenu(11);
                                          },
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.pencil,
                                            size: 14,
                                          ),
                                          onPressed: () {
                                            adminBloc.setUser(e);
                                            adminBloc.setMenu(12);
                                          },
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.delete,
                                            size: 14,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    )),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    )),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                )),
                const SizedBox(
                  width: 8,
                ),
              ],
            ))
      ],
    );
  }
}
