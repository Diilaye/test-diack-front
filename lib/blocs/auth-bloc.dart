import 'dart:ui';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/user-model.dart';
import 'package:form/services/auth-service.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc with ChangeNotifier {
  AuthService authService = AuthService();

  UserModel? userModel;

  bool viewPassword = true;

  bool chargement = false;

  int inscription = 0;

  setInscriretion(int _) {
    inscription = _;
    notifyListeners();
  }

  setViewPassword() {
    viewPassword = !viewPassword;
    notifyListeners();
  }

  AuthBloc() {
    checkIsConnect();
  }

  checkIsConnect() async {
    await SharedPreferences.getInstance().then((prefs) async {
      if (prefs.containsKey("token")) {
        userModel = await authService.getAuth();
        notifyListeners();
      } else {
        userModel = null;
        notifyListeners();
      }
    });
  }

  setResetData() {
    inscription = 0;
    viewPassword = true;
    chargement = false;
    checkIsConnect();
    email = TextEditingController(text: "");
    password = TextEditingController(text: "");
    emailInsc = TextEditingController(text: "");
    passwordInsc = TextEditingController(text: "");
    nom = TextEditingController(text: "");
    prenom = TextEditingController(text: "");
    confPasswordInsc = TextEditingController(text: "");
    adresse = TextEditingController(text: "");
    fonction = TextEditingController(text: "");
    telephone = TextEditingController(text: "");
    notifyListeners();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController emailInsc = TextEditingController();
  TextEditingController passwordInsc = TextEditingController();
  TextEditingController confPasswordInsc = TextEditingController();
  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController fonction = TextEditingController();
  TextEditingController telephone = TextEditingController();

  login() async {
    chargement = true;
    notifyListeners();
    userModel = await authService
        .auth({"email": email.text, "password": password.text});
    chargement = false;
    notifyListeners();
    if (userModel != null) {
      Fluttertoast.showToast(
          msg: "Connexion reussi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      checkIsConnect();
    }
  }

  inscriptionfunc(BuildContext context) async {
    Map<String, dynamic> body = {
      "email": emailInsc.text,
      "password": passwordInsc.text,
      "nom": nom.text,
      "prenom": prenom.text,
      "adresse": adresse.text,
      "telephone": telephone.text,
      "fonction": fonction.text,
    };
    chargement = true;
    notifyListeners();
    if (passwordInsc.text == confPasswordInsc.text) {
      userModel = await authService.store(body);
      chargement = false;
      notifyListeners();
      if (userModel != null) {
        Fluttertoast.showToast(
            msg: "inscription reussi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        checkIsConnect();
        // ignore: use_build_context_synchronously
        context.go("/");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Les deux mots de passe ne concorde pas ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  logout(BuildContext context) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove("token");
      prefs.remove("type");
    });
    userModel = null;
    html.window.location.reload();
    // ignore: use_build_context_synchronously
    notifyListeners();
  }
}
