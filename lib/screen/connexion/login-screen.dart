import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

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
                              authBloc.inscription == 0
                                  ? 'Simplon Formulaire'.toUpperCase()
                                  : 'Inscription Formulaire'.toUpperCase(),
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
                        'Connectez-vous à votre compte',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Content de vous revoir! Veuillez entrer vos coordonnées',
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => authBloc.setInscriretion(1),
                              child: Text(
                                "S'inscrire",
                                style: TextStyle(fontSize: 16, color: noir),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                await authBloc.login();
                                if (authBloc.userModel != null) {
                                  js.context.callMethod('open', [
                                    'http://testing.simplonsolution.com/',
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
            if (authBloc.inscription == 1)
              Center(
                child: SizedBox(
                  width: size.width < 1028 ? size.width * .9 : size.width * .4,
                  child: Column(
                    children: [
                      const Text(
                        'Inscrivez-vous pour acceder a votre compte',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.height * .05,
                      ),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.prenom,
                          decoration: const InputDecoration(
                              labelText: 'Prenom',
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
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.nom,
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
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.adresse,
                          decoration: const InputDecoration(
                              labelText: 'Adresse',
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
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.telephone,
                          decoration: const InputDecoration(
                              labelText: 'Télephone',
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
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.fonction,
                          decoration: const InputDecoration(
                              labelText: 'Fonction Entreprise',
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
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.emailInsc,
                          decoration: const InputDecoration(
                              labelText: 'email',
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
                        // width: size.width * .3,
                        height: 60,
                        child: TextField(
                          cursorColor: Colors.black,
                          controller: authBloc.passwordInsc,
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
                              border: const UnderlineInputBorder(
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
                          controller: authBloc.confPasswordInsc,
                          obscureText: authBloc.viewPassword,
                          decoration: InputDecoration(
                              labelText: 'Confirmer Mot de passe',
                              suffixIcon: IconButton(
                                onPressed: () => authBloc.setViewPassword(),
                                icon: authBloc.viewPassword
                                    ? const Icon(CupertinoIcons.eye_slash)
                                    : const Icon(CupertinoIcons.eye),
                              ),
                              labelStyle: const TextStyle(color: Colors.black),
                              focusColor: Colors.black,
                              fillColor: Colors.black,
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => authBloc.setInscriretion(0),
                              child: Text(
                                "Se connecter",
                                style: TextStyle(fontSize: 16, color: noir),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => authBloc.inscriptionfunc(context),
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
                                            "S'inscrire",
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
