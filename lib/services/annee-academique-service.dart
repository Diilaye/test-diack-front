import 'package:form/models/annee-academique-model.dart';
import 'package:form/utils/requette-by-dii.dart';

class AnneeAcademiqueService {
  Future<AnneeAcademiqueModel?> store(Map<String, dynamic> body) async {
    return await postResponse(url: '/annee-academinques', body: body)
        .then((value) async {
      if (value['status'] == 201) {
        return AnneeAcademiqueModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<AnneeAcademiqueModel?> upadte(
      String id, Map<String, dynamic> body) async {
    return await putResponse(url: '/annee-academinques/$id', body: body)
        .then((value) async {
      if (value['status'] == 200) {
        return AnneeAcademiqueModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<List<AnneeAcademiqueModel>> get() async {
    return await getResponse(url: '/annee-academinques/').then((value) async {
      if (value['status'] == 200) {
        return AnneeAcademiqueModel.fromList(data: value['body']['data']);
      } else {
        return [];
      }
    });
  }
}
