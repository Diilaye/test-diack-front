import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/niveau-academique-model.dart';
import 'package:form/services/niveau-academique-service.dart';

class NiveauAcademiqueBloc with ChangeNotifier {
  NiveauAcademiqueService niveauAcademiqueService = NiveauAcademiqueService();

  List<NiveauAcademiqueModel> niveauAcademiques = [];

  NiveauAcademiqueModel? niveauAcademique;

  getAllAnneeAcademique() async {
    niveauAcademiques = await niveauAcademiqueService.get();
    notifyListeners();
  }

  setNiveauAcademique(NiveauAcademiqueModel? m) {
    niveauAcademique = m;
    if (niveauAcademique == null) {
      titre.text = "";
      description.text = "";
    } else {
      titre.text = niveauAcademique!.titre!;
      description.text = niveauAcademique!.description!;
    }
    notifyListeners();
  }

  NiveauAcademiqueBloc() {
    getAllAnneeAcademique();
  }

  TextEditingController titre = TextEditingController();
  TextEditingController description = TextEditingController();

  bool chargement = false;

  addAnneeAcademique() async {
    if (titre.text.isNotEmpty && description.text.isNotEmpty) {
      chargement = true;
      notifyListeners();
      niveauAcademique = await niveauAcademiqueService.store({
        "titre": titre.text,
        "description": description.text,
      });
      chargement = false;
      notifyListeners();

      if (niveauAcademique != null) {
        getAllAnneeAcademique();
        titre.text = "";
        description.text = "";
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

  updateMatiere() async {
    if (titre.text.isNotEmpty && description.text.isNotEmpty) {
      chargement = true;
      notifyListeners();
      niveauAcademique =
          await niveauAcademiqueService.upadte(niveauAcademique!.id!, {
        "titre": titre.text,
        "description": description.text,
      });
      chargement = false;
      notifyListeners();

      if (niveauAcademique != null) {
        getAllAnneeAcademique();
        titre.text = "";
        description.text = "";
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
