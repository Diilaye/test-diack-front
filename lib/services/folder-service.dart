import 'package:form/models/folder-model.dart';
import 'package:form/utils/requette-by-dii.dart';

class FolderService {
  Future<FolderModel?> store(Map<String, dynamic> body) async {
    return await postResponse(url: '/folders', body: body).then((value) async {
      if (value['status'] == 201) {
        return FolderModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<FolderModel?> upadte(String id, Map<String, dynamic> body) async {
    return await putResponse(url: '/folders/$id', body: body)
        .then((value) async {
      if (value['status'] == 200) {
        return FolderModel.fromJson(value['body']['data']);
      } else {
        return null;
      }
    });
  }

  Future<List<FolderModel>> getFolders() async {
    return await getResponse(url: '/folders/ByUser').then((value) async {
      if (value['status'] == 200) {
        return FolderModel.fromList(data: value['body']['data']);
      } else {
        return [];
      }
    });
  }
}
