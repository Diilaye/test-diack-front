import 'package:form/models/matiere-model.dart';
import 'package:form/utils/requette-by-dii.dart';

class MatiereService {
  Future<MatiereModel?> store(Map<String, dynamic> body) async {
    return await postResponse(url: '/matieres', body: body).then((value) async {
      if (value['status'] == 201) {
        return MatiereModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<MatiereModel?> upadte(String id, Map<String, dynamic> body) async {
    return await putResponse(url: '/matieres/$id', body: body)
        .then((value) async {
      if (value['status'] == 200) {
        return MatiereModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<List<MatiereModel>> getMatiere() async {
    return await getResponse(url: '/matieres/').then((value) async {
      if (value['status'] == 200) {
        return MatiereModel.fromList(data: value['body']['data']);
      } else {
        return [];
      }
    });
  }
}
