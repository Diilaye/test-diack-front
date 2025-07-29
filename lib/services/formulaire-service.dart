import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/models/response-sondeur-model.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/requette-by-dii.dart';

class FormulaireService {
  Future<FormulaireSondeurModel?> add(Map<String, dynamic> body) {
    return postResponse(url: '/formulaires', body: body).then((value) async {
      if (value['status'] == 201) {
        return FormulaireSondeurModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<List<FormulaireSondeurModel>> all() {
    return getResponse(
      url: '/formulaires/ByUser',
    ).then((value) async {
      if (value['status'] == 200) {
        return FormulaireSondeurModel.fromList(data: value['body']['data'])
            .reversed
            .toList();
      } else {
        return [];
      }
    });
  }

  Future<FormulaireSondeurModel?> one(String id) {
    return getResponse(
      url: '/formulaires/$id',
    ).then((value) async {
      if (value['status'] == 200) {
        return FormulaireSondeurModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<FormulaireSondeurModel?> update(String id, Map<String, dynamic> body) {
    return putResponse(url: '/formulaires/$id', body: body).then((value) async {
      if (value['status'] == 200) {
        return FormulaireSondeurModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<String?> sendFomulaire(Map<String, dynamic> body) {
    print(body);
    return postResponse(url: '/formulaires/sendMailFormulaire', body: body)
        .then((value) {
      print(value);
      if (value['status'] == 201) {
        return 'success';
      } else {
        return null;
      }
    });
  }

  Future<String?> sendReponseFormulaire(Map<String, dynamic> body) async {
    return postResponse(url: '/formulaires-reponses/', body: body)
        .then((value) {
      if (value['status'] == 201) {
        return 'success';
      } else {
        return null;
      }
    });
  }

  Future<List<ReponseSondeurModel>> getReponseFormulaire(String id) async {
    return getResponse(
      url: '/formulaires-reponses?idChamps=$id',
    ).then((value) {
      if (value['status'] == 200) {
        return ReponseSondeurModel.fromList(data: value['body']['data']);
      } else {
        return [];
      }
    });
  }

  Future<ReponseSondeurModel?> deleteReponseFormulaire(
      String id, String idResponse) async {
    return deleteResponse(
      url: '/formulaires-reponses?idChamps=$id&responseID=$idResponse',
    ).then((value) {
      if (value['status'] == 200) {
        return ReponseSondeurModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  /// Récupérer les champs d'un formulaire pour répondre
  Future<List<ChampsFormulaireModel>> getFormulaireChamps(
      String formulaireId) async {
    return getResponse(
      url: '/champs/formulaire/$formulaireId',
    ).then((value) {
      if (value['status'] == 200) {
        final List<dynamic> champsData = value['body']['data'];
        return champsData
            .map((champ) => ChampsFormulaireModel.fromJson(champ))
            .toList();
      } else {
        return [];
      }
    });
  }

  /// Soumettre une réponse de formulaire partagé
  Future<bool> submitSharedFormResponse({
    required String shareId,
    required Map<String, dynamic> responses,
  }) async {
    final body = {
      'shareId': shareId,
      'responses': responses,
    };

    return postResponse(url: '/share/submit-response', body: body)
        .then((value) {
      if (value['status'] == 201 || value['status'] == 200) {
        return true;
      } else {
        print('Erreur soumission réponse: ${value['body']}');
        return false;
      }
    });
  }

  /// Soumettre une réponse de sonde
  Future<bool> submitSondeResponse({
    required String formulaireId,
    required String sondeId,
    required Map<String, dynamic> responses,
  }) async {
    final body = {
      'sondeId': sondeId,
      'responses': responses,
    };

    return postResponse(
            url: '/formulaires-reponses/sondee/$formulaireId', body: body)
        .then((value) {
      if (value['status'] == 201 || value['status'] == 200) {
        print('Réponse sonde soumise avec succès: ${value['body']}');
        return true;
      } else {
        print('Erreur soumission réponse sonde: ${value['body']}');
        return false;
      }
    });
  }

  Future<String?> deleteFormulaire(String id) async {
    return deleteResponse(url: '/formulaires/$id').then((value) {
      print("deleteFormulaire");
      print(value);
      if (value['statusCode'] == 200) {
        return "Formulaire delete";
      } else {
        return null;
      }
    });
  }
}
