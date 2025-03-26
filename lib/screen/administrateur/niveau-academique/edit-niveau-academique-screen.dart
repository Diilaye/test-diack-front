import 'package:flutter/material.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:form/blocs/niveau-academique-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';

class EditNiveauAcademiqueScreen extends StatefulWidget {
  const EditNiveauAcademiqueScreen({super.key});

  @override
  State<EditNiveauAcademiqueScreen> createState() =>
      _EditNiveauAcademiqueScreenState();
}

class _EditNiveauAcademiqueScreenState
    extends State<EditNiveauAcademiqueScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final niveauAcademiqueBloc = Provider.of<NiveauAcademiqueBloc>(context);
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
              'Modifier niveau academique',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: size.height * .02,
        ),
        Expanded(
            child: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: size.width * .9,
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: niveauAcademiqueBloc.titre,
                      decoration: const InputDecoration(
                          labelText: 'Titre',
                          labelStyle: TextStyle(color: Colors.black),
                          focusColor: Colors.black,
                          fillColor: Colors.black,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: size.width * .9,
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: niveauAcademiqueBloc.description,
                      decoration: const InputDecoration(
                          labelText: 'Description ',
                          labelStyle: TextStyle(color: Colors.black),
                          focusColor: Colors.black,
                          fillColor: Colors.black,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          niveauAcademiqueBloc.updateMatiere();
                          adminBloc.setMenu(0);
                        },
                        child: Container(
                          height: 50,
                          width: 240,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 0),
                                    blurRadius: 2,
                                    color: Colors.white.withOpacity(.2))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              niveauAcademiqueBloc.chargement
                                  ? CircularProgressIndicator(
                                      backgroundColor: noir,
                                      color: blanc,
                                    )
                                  : const Text(
                                      "Enregister",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
          ],
        ))
      ],
    );
  }
}
