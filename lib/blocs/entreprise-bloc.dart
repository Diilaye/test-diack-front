import 'package:flutter/material.dart';

class EntrepriseBloc with ChangeNotifier {
  int showThemeatiqueEntreprise = 0;

  setShowThematiqueEntreprise(int _) {
    showThemeatiqueEntreprise = _;
    notifyListeners();
  }

  int showCibleEntreprise = 0;

  setShowCibleEntreprise(int _) {
    showCibleEntreprise = _;
    notifyListeners();
  }

  int selectThematiqueEntreprise = 0;

  setSelectedThematiqueEntreprise(int _) {
    selectThematiqueEntreprise = _;
    notifyListeners();
  }

  int selectCibleEntreprise = 0;

  setSelectedCibleEntreprise(int _) {
    selectCibleEntreprise = _;
    notifyListeners();
  }

  String reponseAutreThematiqueEntreprise = "";

  setReponseAutreThematiqueEntreprise(String _) {
    reponseAutreThematiqueEntreprise = _;
    notifyListeners();
  }

  //Section salarier

  int showSectionSalaire = 0;

  setShowSectionSalaire(int _) {
    showSectionSalaire = _;
    notifyListeners();
  }

  int sectionSalaire = 0;

  setSectionSalaire(int _) {
    sectionSalaire = _;
    notifyListeners();
  }

  //Section outils numerik

  int sectionOutilNumerique = 0;

  setSectionOutilsNumerique(int _) {
    sectionOutilNumerique = _;
    notifyListeners();
  }

  int showSectionOutilsNumerique = 0;

  setShowSectionOutilsNumerique(int _) {
    showSectionOutilsNumerique = _;
    notifyListeners();
  }
}
