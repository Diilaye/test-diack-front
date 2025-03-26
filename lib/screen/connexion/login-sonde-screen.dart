import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/blocs/auth-sonde-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

class LoginSondeScreen extends StatelessWidget {
  final String id;
  const LoginSondeScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthSondeBloc>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: .0,
          elevation: .0,
        ),
        backgroundColor: blanc,
        body: ListView(
          children: [
            Center(
              child: SizedBox(
                height: 60,
                child: Row(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => context.go("/"),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width * .025,
                            ),
                            Text(
                              'Conexion au Formulaire'.toUpperCase(),
                              style: TextStyle(color: noir),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            // if (authBloc.inscription == 0)
            SizedBox(
              height: size.height * .1,
            ),
            if (authBloc.inscription == 0)
              Center(
                child: SizedBox(
                  width: size.width * .4,
                  child: Column(
                    children: [
                      const Text(
                        'Connectez-vous à pour remplir votre formulaire',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Veuillez entrer vos coordonnées pour remplir le formulaire ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: size.height * .05,
                      ),
                      SizedBox(
                        // width: size.width * .3,
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.email,
                          decoration: const InputDecoration(
                              labelText: 'email',
                              labelStyle: TextStyle(color: Colors.black),
                              focusColor: Colors.black,
                              fillColor: Colors.black,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        // width: size.width * .3,
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.password,
                          obscureText: authBloc.viewPassword,
                          decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              suffixIcon: IconButton(
                                onPressed: () => authBloc.setViewPassword(),
                                icon: authBloc.viewPassword
                                    ? const Icon(CupertinoIcons.eye_slash)
                                    : const Icon(CupertinoIcons.eye),
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              focusColor: Colors.black,
                              fillColor: Colors.black,
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              disabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                await authBloc.login(context, id);
                                if (authBloc.resultE == "1") {
                                  print("TOus est bene");
                                  js.context.callMethod('open', [
                                    'http://testing.simplonsolution.com/formulaire-view-sonde/$id',
                                    '_self'
                                  ]);
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 150,
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
                                    authBloc.chargement
                                        ? CircularProgressIndicator(
                                            backgroundColor: noir,
                                            color: blanc,
                                          )
                                        : const Text(
                                            "Se connecter",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(
              height: 16,
            ),
          ],
        ));
  }
}
