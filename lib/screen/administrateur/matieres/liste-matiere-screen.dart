import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:form/blocs/matiere-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';

class ListeMatiereScreen extends StatefulWidget {
  const ListeMatiereScreen({super.key});

  @override
  State<ListeMatiereScreen> createState() => _ListeMatiereScreenState();
}

class _ListeMatiereScreenState extends State<ListeMatiereScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final adminBloc = Provider.of<AdminBloc>(context);
    final matiereBloc = Provider.of<MatiereBloc>(context);

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
              'Liste des matieres',
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
                        Expanded(flex: 1, child: Text("Titre")),
                        Expanded(flex: 3, child: Text("description")),
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
                      children: matiereBloc.matieres
                          .map(
                            (e) => Row(
                              children: [
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${e.titre}".toUpperCase(),
                                      style:
                                          TextStyle(fontSize: 10, color: noir),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      e.description!,
                                      style:
                                          TextStyle(fontSize: 10, color: noir),
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
                                            matiereBloc.setMatiere(e);
                                            adminBloc.setMenu(21);
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
                                            matiereBloc.setMatiere(e);
                                            adminBloc.setMenu(22);
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
