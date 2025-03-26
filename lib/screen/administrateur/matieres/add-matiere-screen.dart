import 'package:flutter/material.dart';
import 'package:form/blocs/matiere-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';

class AddMatiereScreen extends StatefulWidget {
  const AddMatiereScreen({super.key});

  @override
  State<AddMatiereScreen> createState() => _AddMatiereScreenState();
}

class _AddMatiereScreenState extends State<AddMatiereScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              'Ajouter matiere',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: size.height * .02,
        ),
        SizedBox(
          height: 300,
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
                      width: size.width * .8,
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: matiereBloc.titre,
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
                      // width: size.width * .9,
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: matiereBloc.description,
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
                          onTap: () => matiereBloc.addMatiere(),
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
                                matiereBloc.chargement
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
          ),
        )
      ],
    );
  }
}
