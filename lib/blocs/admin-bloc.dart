import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/user-model.dart';
import 'package:form/services/auth-service.dart';

class AdminBloc with ChangeNotifier {
  AuthService authService = AuthService();

  bool chargement = false;

  int menu = 0;

  setMenu(int i) {
    if (i == 1) {
      setUser(null);
    }
    menu = i;
    notifyListeners();
  }

  List<UserModel> users = [];
  UserModel? user;

  setUser(UserModel? us) {
    user = us;
    if (user != null) {
      selectedStatus = user!.type!;
      nom.text = user!.nom!;
      prenom.text = user!.prenom!;
      email.text = user!.email!;
      adresse.text = user!.adresse!;
      fonction.text = user!.fonction!;
      telephone.text = user!.telephone!;
    } else {
      selectedStatus = "";
      nom.text = "";
      prenom.text = "";
      email.text = "";
      adresse.text = "";
      fonction.text = "";
      telephone.text = "";
    }
    notifyListeners();
  }

  getAllUser() async {
    users = await authService.getUser();
    notifyListeners();
  }

  List<String> listeStatus = [
    '',
    'admin',
    'sondeur',
    'etudiant',
    'entreprise',
    'employe'
  ];

  String selectedStatus = "";

  TextEditingController nom = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController adresse = TextEditingController();
  TextEditingController fonction = TextEditingController();
  TextEditingController telephone = TextEditingController();

  addUser() async {
    chargement = true;
    notifyListeners();
    user = await authService.store({
      "type": selectedStatus == "" ? "sondeur" : selectedStatus,
      "nom": nom.text,
      "prenom": prenom.text,
      "email": email.text,
      "adresse": adresse.text,
      "fonction": fonction.text,
      "telephone": telephone.text,
    });
    chargement = false;
    notifyListeners();

    if (user != null) {
      getAllUser();
      Fluttertoast.showToast(
          msg: "Creation de l'utilisateur reussi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Erreur l'hors de la creation de l'utilisateur",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateUser() async {
    chargement = true;
    notifyListeners();

    user = await authService.upadte(user!.id!, {
      "type": selectedStatus == "" ? "sondeur" : selectedStatus,
      "nom": nom.text,
      "prenom": prenom.text,
      "email": email.text,
      "adresse": adresse.text,
      "fonction": fonction.text,
      "telephone": telephone.text,
    });
    chargement = false;
    notifyListeners();

    if (user != null) {
      getAllUser();
      Fluttertoast.showToast(
          msg: "modification de l'utilisateur reussi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Erreur l'hors de la modification de l'utilisateur",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  setSelectedStatus(String value) {
    selectedStatus = value;
    notifyListeners();
  }

  AdminBloc() {
    getAllUser();
  }
}
