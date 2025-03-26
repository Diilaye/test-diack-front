import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/models/response-sondeur-model.dart';
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
