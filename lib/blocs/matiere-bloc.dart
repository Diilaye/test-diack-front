import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/matiere-model.dart';
import 'package:form/services/matiere-service.dart';

class MatiereBloc with ChangeNotifier {
  MatiereService matiereService = MatiereService();

  List<MatiereModel> matieres = [];

  MatiereModel? matiere;

  getAllMatiere() async {
    matieres = await matiereService.getMatiere();
    notifyListeners();
  }

  setMatiere(MatiereModel? m) {
    matiere = m;
    if (matiere == null) {
      titre.text = "";
      description.text = "";
    } else {
      titre.text = matiere!.titre!;
      description.text = matiere!.description!;
    }
    notifyListeners();
  }

  MatiereBloc() {
    getAllMatiere();
  }

  TextEditingController titre = TextEditingController();
  TextEditingController description = TextEditingController();

  bool chargement = false;

  addMatiere() async {
    if (titre.text.isNotEmpty && description.text.isNotEmpty) {
      chargement = true;
      notifyListeners();
      matiere = await matiereService.store({
        "titre": titre.text,
        "description": description.text,
      });
      chargement = false;
      notifyListeners();

      if (matiere != null) {
        getAllMatiere();
        titre.text = "";
        description.text = "";
        Fluttertoast.showToast(
            msg: "Ajout de matiere reussi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Erreur l'hors  de la creation",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  updateMatiere() async {
    if (titre.text.isNotEmpty && description.text.isNotEmpty) {
      chargement = true;
      notifyListeners();
      matiere = await matiereService.upadte(matiere!.id!, {
        "titre": titre.text,
        "description": description.text,
      });
      chargement = false;
      notifyListeners();

      if (matiere != null) {
        getAllMatiere();
        titre.text = "";
        description.text = "";
        Fluttertoast.showToast(
            msg: "Modification de matiere reussi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Erreur l'hors  de la modification",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
