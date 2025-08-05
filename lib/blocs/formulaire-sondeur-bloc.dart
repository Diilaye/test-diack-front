import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/services/champs-service.dart';
import 'package:form/services/formulaire-service.dart';
import 'package:form/utils/upload-file.dart';

class FormulaireSondeurBloc with ChangeNotifier {
  ChampService champService = ChampService();

  String description = "Formulaire sans description";

  String titre = "Formulaire sans titre";

  TextEditingController titreCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();

  int showSearch = 0;

  setShowSearch(int i) {
    showSearch = i;
    notifyListeners();
  }

  String? resultDelete;

  int showMenuProfil = 0;

  setMenuProfil(int i) {
    showMenuProfil = i;
    notifyListeners();
  }

  int menuNumber = 0;

  setMenuNumber(int i) {
    menuNumber = i;
    notifyListeners();
  }

  int openMenuFolder = 0;

  setOpenMenuFolder(int i) {
    openMenuFolder = i;
    notifyListeners();
  }

  deleteFformulaire(String id) async {
    resultDelete = await formulaireService.deleteFormulaire(id);
    notifyListeners();
  }

  int showEnvoyer = 0;

  int emailList = 0;

  setEmailList(int i) {
    emailList = i;
    notifyListeners();
  }

  setShowEnvoyer(int i) {
    showEnvoyer = i;
    notifyListeners();
  }

  getEmailFile() async {
    List? v = await getFile();
    emails = v!.map((e) => e.toString()).toList();
    print(emails);
    notifyListeners();
  }

  final FocusNode focusNode = FocusNode();
  TextEditingController emailCtlr = TextEditingController();
  TextEditingController objectCtrl = TextEditingController();
  TextEditingController messageCtrl = TextEditingController();

  int inclureFormEmail = 0;
  int inclureFormEmailPassword = 0;

  String collecterEmail = 'Ne pas collecter'.toLowerCase().trim();

  setCollecterEmail(String v) {
    collecterEmail = v;
    notifyListeners();
  }

  setInclureFormEmail() {
    inclureFormEmail = inclureFormEmail == 0 ? 1 : 0;
    notifyListeners();
  }

  setInclureFormEmailPassword() {
    inclureFormEmailPassword = inclureFormEmailPassword == 0 ? 1 : 0;
    notifyListeners();
  }

  List<String> emails = [];

  setContainer() {
    emails.add(emailCtlr.text.trim().toLowerCase());
    notifyListeners();
    print("setContainer");
    print("emails => $emails");

    emailCtlr.text = "";
    notifyListeners();
  }

  removeContainer(String v) {
    emails.remove(v);
    notifyListeners();
  }

  FormulaireSondeurModel? formulaireSondeurModel;

  List<String> questions = [
    'textField',
    'textArea',
    'singleChoice',
    'yesno',
    'multiChoice',
    'nomComplet',
    'email',
    'addresse',
    'telephone',
    'image',
    'file',
    'separator',
    'explication'
  ];

  bool chargementEnvoieFormulaire = false;

  sendFormulaire() async {
    chargementEnvoieFormulaire = true;
    notifyListeners();

    print(emails);

    Map<String, dynamic> body = {
      "emails": emails,
      "object": objectCtrl.text,
      "message": messageCtrl.text,
      "inclureForm": inclureFormEmail.toString(),
      "inclurePassword": inclureFormEmailPassword.toString(),
      "idFormulaire": formulaireSondeurModel!.id!
    };

    String? result = await formulaireService.sendFomulaire(body);
    if (result != null) {
      Fluttertoast.showToast(
          msg: "Envoie reussi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "L'envoie à echouer ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    chargementEnvoieFormulaire = false;
    showEnvoyer = 0;
    notifyListeners();
  }

  String question = 'textfield';

  List<ChampsFormulaireModel> listeChampForm = [];

  getAllChampForm() async {
    listeChampForm = await champService.allForm(formulaireSondeurModel!.id!);

    notifyListeners();
  }

  setQuestions(String v) {
    question = v;
    notifyListeners();
  }

  addChampsFormulaireOptions(
    String id,
  ) async {
    await champService.update(id, {"options": "option"});
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireTypeQuestions(String id, String type) async {
    await champService.update(id, {"type": type});
    if (type == "multiChoice") {
      await champService.update(id, {"options": "option"});
    }
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireNomQuestions(String id, String nom) async {
    await champService.update(id, {"nom": nom});
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireDescriptionQuestions(
      String id, String description) async {
    await champService.update(id, {"description": description});
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireNotesQuestions(String id, String note) async {
    await champService.update(id, {"notes": int.parse(note)});
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireObligatoireQuestions(String id, String type) async {
    await champService.update(id, {"isObligatoire": type});
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireHaveReponseQuestions(String id, String type) async {
    await champService.update(id, {"haveResponse": type});
    await getAllChampForm();
    notifyListeners();
  }

  deleteChampFormulaireOptions(String id, String idChamp) async {
    await champService.update(id, {
      "valueOption": {"id": idChamp, "delete": "true", "option": "option"}
    });
    await getAllChampForm();
    notifyListeners();
  }

  addChampFormulaireResponse(
      String id, String idChamp, ListeOptions option) async {
    await champService.update(id, {
      "listeReponses": {
        "id": idChamp,
        "delete": "false",
        "option": option.option!
      }
    });
    await getAllChampForm();
    notifyListeners();
  }

  addChampFormulaireResponseTextField(
      String id, String idChamp, String option) async {
    await champService.updateTextield(id, {
      "listeReponses": [
        {"id": idChamp, "delete": "false", "option": option}
      ]
    });
    await getAllChampForm();
    notifyListeners();
  }

  addChampFormulaireResponseMultiChoice(
      String id, String idChamp, String option, String supOrNot) async {
    await champService.updateMultiChoice(id, {
      "option": {"id": idChamp, "delete": supOrNot, "option": option}
    });
    await getAllChampForm();
    notifyListeners();
  }

  updateChampFormulaireOptions(String id, String idChamp, String value) async {
    await champService.update(id, {
      "valueOption": {"id": idChamp, "delete": "false", "option": value}
    });
    await getAllChampForm();
    notifyListeners();
  }

  deleteChampFormulaire(String id) async {
    await champService.delete(id);
    await getAllChampForm();
    notifyListeners();
  }

  int showMenu = 0;

  setShowMenu(int s) {
    showMenu = s;
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
    indexFromChild++;
    notifyListeners();
  }

  deleteChildForm() {
    formChild.removeWhere((t) => t['index'] == childForm['index']);
    notifyListeners();
  }

  setSelectedFormSondeurModel(f) async {
    if (f.runtimeType == FormulaireSondeurModel) {
      formulaireSondeurModel = f;
      getAllChampForm();
      notifyListeners();
    } else {
      formulaireSondeurModel = await formulaireService.one(f);

      getAllChampForm();
      notifyListeners();
    }
    titreCtrl.text = formulaireSondeurModel!.titre!;
    descCtrl.text = formulaireSondeurModel!.description!;
    objectCtrl.text = formulaireSondeurModel!.titre!;
    messageCtrl.text = 'Je vous ai invité à remplir un formulaire : ';
    notifyListeners();
  }

  addChampFormulaire(String id) async {
    chargement = true;
    notifyListeners();
    await champService.add({
      "type": "textField",
      'idForm': id,
      "description": "Description de cette question",
      "nom": "Questions à poser",
    });
    getAllChampForm();
    chargement = false;
    notifyListeners();
  }

  addChampFormulaireType(String id, String type) async {
    chargement = true;
    notifyListeners();
    await champService.add({
      "type": type,
      'idForm': id,
      "description": type == "explication" 
          ? "Ajoutez ici le texte d'explication qui sera affiché aux répondants."
          : "Description de cette question",
      "nom": type == 'nomComplet'
          ? "Veuillez renseigner votre nom complet ?"
          : type == "email"
              ? "Veuillez renseigner votre email ?"
              : type == "addresse"
                  ? "Veuillez renseigner votre addresse ?"
                  : type == "telephone"
                      ? "Veuillez renseigner votre telephone ?"
                      : type == "image"
                          ? "Veuillez télécharger votre image ?"
                          : type == "file"
                              ? "Veuillez télécharger votre ichier ?"
                              : type == "separator-title"
                                  ? "Titre séparateur"
                                  : type == "explication"
                                      ? "Titre de l'explication"
                                      : "Questions à poser",
    });
    getAllChampForm();
    chargement = false;
    notifyListeners();
  }

  updateTitreForm(String titre) async {
    formulaireSondeurModel = await formulaireService
        .update(formulaireSondeurModel!.id!, {"titre": titre});
    notifyListeners();
    getAllForm();
    notifyListeners();
  }

  updateDescrForm(String desc) async {
    formulaireSondeurModel = await formulaireService
        .update(formulaireSondeurModel!.id!, {"description": desc});
    notifyListeners();
    getAllForm();
    notifyListeners();
  }

  upadteCover() async {
    String idCover = "";
    await getImage(1).then((value) async {
      idCover = value[0];
    });
    formulaireSondeurModel = await formulaireService
        .update(formulaireSondeurModel!.id!, {"cover": idCover});
    notifyListeners();
    getAllForm();
    notifyListeners();
  }

  upadteLogo() async {
    String? idLogo;
    await getImage(1).then((value) async {
      print("value[0] image logo");
      print(value[0]);
      idLogo = value[0];

      if (idLogo != null) {
        formulaireSondeurModel = await formulaireService
            .update(formulaireSondeurModel!.id!, {"logo": idLogo});
        notifyListeners();
      }
    });

    getAllForm();
    notifyListeners();
  }

  List<FormulaireSondeurModel> formulaires = [];

  bool isHaveFormToday = false;

  FormulaireService formulaireService = FormulaireService();

  bool chargement = false;

  addFormSondeur(String folder) async {
    chargement = true;
    ChangeNotifier();
    if (folder == "") {
      formulaireSondeurModel = await formulaireService
          .add({"titre": titre, "description": description});
    } else {
      formulaireSondeurModel = await formulaireService
          .add({"titre": titre, "description": description, "folder": folder});
    }
    await getAllForm();
    chargement = false;
    ChangeNotifier();
  }

  getAllForm() async {
    formulaires = await formulaireService.all();
    notifyListeners();
  }

  FormulaireSondeurBloc() {
    getAllForm();
  }
}
