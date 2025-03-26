import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/user-model.dart';
import 'package:form/services/auth-service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class AuthSondeBloc with ChangeNotifier {
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

  AuthSondeBloc() {
    checkIsConnect();
  }

  setEmailInit(String? emailS, String? passwordS) {
    email.text = emailS ?? "";
    password.text = passwordS ?? "";
    notifyListeners();
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
    notifyListeners();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String resultE = "0";
  login(BuildContext context, String id) async {
    chargement = true;
    notifyListeners();
    String? result = await authService.authSonde(
        {"email": email.text, "password": password.text, "idForm": id});
    chargement = false;
    notifyListeners();
    if (result != null) {
      resultE = "1";
      notifyListeners();
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
}
