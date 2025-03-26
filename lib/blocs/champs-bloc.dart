import 'package:flutter/material.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/services/champs-service.dart';

class ChampsBloc with ChangeNotifier {
  ChampService champService = ChampService();
  bool chargement = false;

  addChampFormulaire(String id) async {
    chargement = true;
    notifyListeners();
    await champService.add({"type": "textField", 'idForm': id});
    chargement = false;
    notifyListeners();
  }
}
