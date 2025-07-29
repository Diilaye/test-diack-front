import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/requette-by-dii.dart';

class ChampService {
  Future<ChampsFormulaireModel?> add(Map<String, dynamic> body) {
    print(body);
    return postResponse(url: '/champs', body: body).then((value) async {
      print("add ChampsFormulaireModel");
      print(value);
      if (value['status'] == 201) {
        return ChampsFormulaireModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<List<ChampsFormulaireModel>> allForm(String id) {
    return getResponse(
      url: '/champs/formulaire/$id',
    ).then((value) async {
      print("allForm");
      print(value);
      if (value['status'] == 200) {
        return ChampsFormulaireModel.fromList(data: value['body']['data'])
            .reversed
            .toList();
      } else {
        return [];
      }
    });
  }

  Future<ChampsFormulaireModel?> one(String id) {
    return getResponse(
      url: '/champs/$id',
    ).then((value) async {
      if (value['status'] == 200) {
        return ChampsFormulaireModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<ChampsFormulaireModel?> update(String id, Map<String, dynamic> body) {
    print(body);
    return putResponse(url: '/champs/$id', body: body).then((value) async {
      print(value);
      if (value['status'] == 200) {
        return ChampsFormulaireModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<ChampsFormulaireModel?> updateTextield(
      String id, Map<String, dynamic> body) {
    print(body);
    return putResponse(url: '/champs/textfield/$id', body: body)
        .then((value) async {
      print(value);
      if (value['status'] == 200) {
        return ChampsFormulaireModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<ChampsFormulaireModel?> updateMultiChoice(
      String id, Map<String, dynamic> body) {
    print(body);
    return putResponse(url: '/champs/multichoice/$id', body: body)
        .then((value) async {
      print(value);
      if (value['status'] == 200) {
        return ChampsFormulaireModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<String?> delete(String id) {
    return deleteResponse(url: '/champs/$id').then((value) async {
      if (value['status'] == 200) {
        return "success";
      } else {
        return null;
      }
    });
  }
}
