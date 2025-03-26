import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/admin-bloc.dart';
import 'package:provider/provider.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
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
              'Voir utilisateur',
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
                    width: size.width,
                    child: Center(
                      child: FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: adminBloc.selectedStatus,
                                onChanged: (newValue) {
                                  setState(() {
                                    state.didChange(newValue);
                                  });
                                  adminBloc.setSelectedStatus(newValue!);
                                },
                                iconSize: 12,
                                items: [adminBloc.selectedStatus]
                                    .map((String value) {
                                  if (value == "") {
                                    return const DropdownMenuItem<String>(
                                      value: "",
                                      child: Text(
                                        "Type d'utilisateur",
                                      ),
                                    );
                                  } else {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                      ),
                                    );
                                  }
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: size.width * .9,
                    child: TextField(
                      cursorColor: Colors.black,
                      controller: adminBloc.nom,
                      readOnly: true,
                      decoration: const InputDecoration(
                          labelText: 'Nom',
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
                      readOnly: true,
                      controller: adminBloc.prenom,
                      decoration: const InputDecoration(
                          labelText: 'Prenom ',
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
                      readOnly: true,
                      controller: adminBloc.email,
                      decoration: const InputDecoration(
                          labelText: 'Email ',
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
                      readOnly: true,
                      controller: adminBloc.adresse,
                      decoration: const InputDecoration(
                          labelText: 'Adresse ',
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
                      readOnly: true,
                      controller: adminBloc.fonction,
                      decoration: const InputDecoration(
                          labelText: 'Fonction ',
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
                      readOnly: true,
                      controller: adminBloc.telephone,
                      decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          labelStyle: TextStyle(color: Colors.black),
                          prefixText: '+221',
                          focusColor: Colors.black,
                          fillColor: Colors.black,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
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
