import 'package:flutter/material.dart';
import 'package:form/models/response-sondeur-model.dart';
import 'package:form/services/formulaire-service.dart';

class FormulaireReponseBloc with ChangeNotifier {
  FormulaireService formulaireService = FormulaireService();
  List<Map<String, dynamic>> reponseMultiChoice = [];
  Map<String, dynamic> reponseOneChoice = {};

  addReponseMultiChoice(
      Map<String, dynamic> r, Map<String, dynamic> champs) async {
    if (reponseMultiChoice.where((e) => e['id'] == r['id']).isNotEmpty) {
      reponseMultiChoice.removeWhere((e) => e['id'] == r['id']);
      notifyListeners();
    } else {
      reponseMultiChoice.add(r);
      await formulaireService.sendReponseFormulaire({
        "idChamp": champs['id'],
        "idOption": r['id'],
        "option": r['option']
      });
    }
    notifyListeners();
  }

  checkResponse() async {}

  addReponseOneChoice(
      Map<String, dynamic> r, Map<String, dynamic> champs) async {
    print("champs");
    print(champs['id']);
    print("response");
    print(r);

    // await formulaireService.sendReponseFormulaire({
    //   "idChamp": champs["id"],
    //   "listRep": [reponseOneChoice]
    // });

    if (reponseOneChoice['id'] == r['id']) {
      reponseOneChoice = {};
      // await formulaireService
      //     .sendReponseFormulaire({"idChamp": champs["id"], "listRep": []});
      notifyListeners();
    } else {
      reponseOneChoice = r;
      reponseMultiChoice.add(r);
      await formulaireService.sendReponseFormulaire({
        "idChamp": champs['id'],
        "idOption": r['id'],
        "option": r['option']
      });
    }
    notifyListeners();
  }

  List<ReponseSondeurModel> listeReponseSondeur = [];

  Future<List<ReponseSondeurModel>> getResponseSonde(String id) async {
    print("getResponseSonde");
    listeReponseSondeur = await formulaireService.getReponseFormulaire(id);
    return listeReponseSondeur;
  }

  removeResponseSonde(String id, idResponse) async {
    print("removeResponseSonde");
    print("await formulaireService.deleteReponseFormulaire");
    print(id);
    print(idResponse);
    await formulaireService.deleteReponseFormulaire(id, idResponse);
    getResponseSonde(id);
    notifyListeners();
  }
}
