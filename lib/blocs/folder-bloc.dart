import 'package:flutter/cupertino.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/services/folder-service.dart';

class FolderBloc with ChangeNotifier {
  FolderService folderService = FolderService();

  int chargement = 0;

  setChargement(int i) {
    chargement = i;
    notifyListeners();
  }

  List<FolderModel> folders = [];
  FolderModel? folder;

  setFolder(FolderModel? f) {
    folder = f;
    notifyListeners();
  }

  setFolders() async {
    folders = await folderService.getFolders();
    notifyListeners();
  }

  addFolder(Map<String, dynamic> body) async {
    chargement = 1;
    notifyListeners();
    await folderService.store(body).then((value) async {
      if (value != null) {
        chargement = 0;
        await setFolders();
        notifyListeners();
      } else {
        chargement = 2;
        notifyListeners();
      }
    });
  }

  updateFolder(String id, Map<String, dynamic> body) async {
    chargement = 1;
    notifyListeners();
    await folderService.upadte(id, body).then((value) {
      if (value != null) {
        chargement = 0;
        notifyListeners();
      } else {
        chargement = 2;
        notifyListeners();
      }
    });
  }

  FolderBloc() {
    setFolders();
  }
}
