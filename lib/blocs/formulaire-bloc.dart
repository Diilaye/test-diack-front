import 'package:flutter/material.dart';

class FormulaireBloc with ChangeNotifier {
  int menuForm = 0;

  setMenuForm(int _) {
    menuForm = _;
    notifyListeners();
  }

  List<Widget> childrenForm = [];

  List<Map> formChild = [];
  int indexFromChild = 0;

  Map childForm = {};

  setChildForm(Map _) {
    childForm = _;
    notifyListeners();
  }

  addFormChild(Map _) {
    formChild.add(_);
    childForm = _;
    menuForm = 1;
    indexFromChild++;
    notifyListeners();
  }

  deleteChildForm() {
    formChild.removeWhere((t) => t['index'] == childForm['index']);
    notifyListeners();
  }

  updateFielForm(String title, dynamic value) {
    if (value.runtimeType == String) {
      childForm[title] = value;
    } else {
      if (childForm[title] == null) {
        childForm[title] = value;
        if (title == 'admin_unique') {
          childForm['monde'] = null;
        }
        if (title == 'monde') {
          childForm['admin_unique'] = null;
        }
      } else {
        childForm[title] = null;
      }
    }

    notifyListeners();

    List<Map> l = [];
    for (var element in formChild) {
      if (element['index'] == childForm['index']) {
        l.add(childForm);
      } else {
        l.add(element);
      }
    }
    notifyListeners();
  }

  addChildForm(Widget _) {
    childrenForm.add(_);
    notifyListeners();
  }

  removeChildForm(Widget _) {
    childrenForm.remove(_);
    notifyListeners();
  }

  int hoverSettingForm = 0;

  setHoverSettingForm(int _) {
    hoverSettingForm = _;
    notifyListeners();
  }

  String titleForm = "Formumaire sans titre";

  setTitleform(String _) {
    titleForm = _;
    notifyListeners();
  }

  String messageEmailForm = "Super! Merci d'avoir rempli mon formulaire !";

  TextEditingController controllerEmailMessage = TextEditingController(
      text: "Super! Merci d'avoir rempli mon formulaire !");

  setMessageEmailForm(String _) {
    messageEmailForm = _;
    notifyListeners();
  }

  int formPublic = 0;

  setFromPublic(int _) {
    formPublic = _;

    notifyListeners();
  }

  String codeForm = "1234-5678";

  TextEditingController controllerCodeFormulaire =
      TextEditingController(text: "1234-5678");

  setCodeFormForm(String _) {
    codeForm = _;
    notifyListeners();
  }

  TextEditingController title = TextEditingController();

  String descForm = "Formumaire sans description";

  String styleTitreForm = "1";

  setStyleTitreForm(String _) {
    styleTitreForm = _;
    notifyListeners();
  }

  String styleDescForm = "1";

  setStyleDescForm(String _) {
    styleDescForm = _;
    notifyListeners();
  }

  setdescform(String _) {
    descForm = _;
    notifyListeners();
  }

  int noSendText = 0;

  setNoSendText(int _) {
    noSendText = _;
    notifyListeners();
  }

  int noSendConfirm = 0;

  setNoSendConfirm() {
    if (noSendConfirm == 0) {
      noSendConfirm = 1;
    } else {
      noSendConfirm = 0;
    }
    notifyListeners();
  }
}
