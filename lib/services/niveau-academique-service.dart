import 'package:form/models/niveau-academique-model.dart';
import 'package:form/utils/requette-by-dii.dart';

class NiveauAcademiqueService {
  Future<NiveauAcademiqueModel?> store(Map<String, dynamic> body) async {
    return await postResponse(url: '/niveau-academiques', body: body)
        .then((value) async {
      if (value['status'] == 201) {
        return NiveauAcademiqueModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<NiveauAcademiqueModel?> upadte(
      String id, Map<String, dynamic> body) async {
    return await putResponse(url: '/niveau-academiques/$id', body: body)
        .then((value) async {
      if (value['status'] == 200) {
        return NiveauAcademiqueModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<List<NiveauAcademiqueModel>> get() async {
    return await getResponse(url: '/niveau-academiques/').then((value) async {
      if (value['status'] == 200) {
        return NiveauAcademiqueModel.fromList(data: value['body']['data']);
      } else {
        return [];
      }
    });
  }
}
