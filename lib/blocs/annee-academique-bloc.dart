import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/annee-academique-model.dart';
import 'package:form/services/annee-academique-service.dart';
import 'package:form/utils/get-date-by-dii.dart';

class AnneeAcademiqueBloc with ChangeNotifier {
  AnneeAcademiqueService anneeAcademiqueService = AnneeAcademiqueService();

  List<AnneeAcademiqueModel> anneeAcademiques = [];

  AnneeAcademiqueModel? anneeAcademique;

  getAllAnneeAcademique() async {
    anneeAcademiques = await anneeAcademiqueService.get();
    notifyListeners();
  }

  setAnneeAcademique(AnneeAcademiqueModel? m) {
    anneeAcademique = m;
    if (anneeAcademique == null) {
      debut.text = "";
      fin.text = "";
      fin.text = "";
    } else {
      debut.text = getDateByDii(anneeAcademique!.debut!);
      titre.text = anneeAcademique!.titre!;
      fin.text = getDateByDii(anneeAcademique!.fin!);
    }
    notifyListeners();
  }

  AnneeAcademiqueBloc() {
    getAllAnneeAcademique();
  }

  setDateDebut(DateTime? value) {
    debut.text = value!.toString().split(" ")[0].split("-").reversed.join("-");
    titre.text = debut.text.split('-')[2];
    notifyListeners();
  }

  setDateFin(DateTime? value) {
    fin.text = value!.toString().split(" ")[0].split("-").reversed.join("-");
    titre.text = titre.text + "-" + fin.text.split('-')[2];

    notifyListeners();
  }

  TextEditingController debut = TextEditingController();
  TextEditingController titre = TextEditingController();
  TextEditingController fin = TextEditingController();

  bool chargement = false;

  addAnneeAcademique() async {
    if (titre.text.isNotEmpty && debut.text.isNotEmpty && fin.text.isNotEmpty) {
      chargement = true;
      notifyListeners();
      anneeAcademique = await anneeAcademiqueService.store({
        "titre": titre.text,
        "debut": debut.text,
        "fin": fin.text,
      });
      chargement = false;
      notifyListeners();

      if (anneeAcademique != null) {
        getAllAnneeAcademique();
        titre.text = "";
        debut.text = "";
        fin.text = "";
        Fluttertoast.showToast(
            msg: "Ajout d'année academique reussi",
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

  updateAnneAcademique() async {
    if (titre.text.isNotEmpty && debut.text.isNotEmpty && fin.text.isNotEmpty) {
      chargement = true;
      notifyListeners();
      anneeAcademique = await anneeAcademiqueService.store({
        "titre": titre.text,
        "debut": debut.text,
        "fin": fin.text,
      });
      chargement = false;
      notifyListeners();

      if (anneeAcademique != null) {
        getAllAnneeAcademique();
        titre.text = "";
        debut.text = "";
        fin.text = "";
        Fluttertoast.showToast(
            msg: "Modification de l'année academique reussi",
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
