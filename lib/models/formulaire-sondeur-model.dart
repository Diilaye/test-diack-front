class FormulaireSondeurModel {
  String? date;
  List<String>? champs;
  Logo? logo;
  Logo? cover;
  FolderForm? folderForm;
  int? responseTotal;
  String? archived;
  String? deleted;
  String? createdAt;
  String? titre;
  String? description;
  String? admin;
  String? id;

  FormulaireSondeurModel(
      {this.date,
      this.champs,
      this.logo,
      this.cover,
      this.folderForm,
      this.responseTotal,
      this.archived,
      this.deleted,
      this.createdAt,
      this.titre,
      this.description,
      this.admin,
      this.id});

  FormulaireSondeurModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    champs = json['champs'].cast<String>();
    logo = json['logo'] != null ? new Logo.fromJson(json['logo']) : null;
    cover = json['cover'] != null ? new Logo.fromJson(json['cover']) : null;
    folderForm = json['folderForm'] != null
        ? new FolderForm.fromJson(json['folderForm'])
        : null;
    responseTotal = json['responseTotal'];
    archived = json['archived'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    titre = json['titre'];
    description = json['description'];
    admin = json['admin'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['champs'] = this.champs;
    if (this.logo != null) {
      data['logo'] = this.logo!.toJson();
    }
    if (this.cover != null) {
      data['cover'] = this.cover!.toJson();
    }
    if (this.folderForm != null) {
      data['folderForm'] = this.folderForm!.toJson();
    }
    data['responseTotal'] = this.responseTotal;
    data['archived'] = this.archived;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['titre'] = this.titre;
    data['description'] = this.description;
    data['admin'] = this.admin;
    data['id'] = this.id;
    return data;
  }

  static List<FormulaireSondeurModel> fromList({required data}) {
    List<FormulaireSondeurModel> liste = [];
    for (var element in data) {
      liste.add(FormulaireSondeurModel.fromJson(element));
    }
    return liste;
  }
}

class Logo {
  String? date;
  String? url;
  String? type;
  String? id;

  Logo({this.date, this.url, this.type, this.id});

  Logo.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    url = json['url'];
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['url'] = this.url;
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class FolderForm {
  String? titre;
  String? color;
  List<String>? form;
  String? userCreate;
  String? token;
  String? createdAt;
  String? id;

  FolderForm(
      {this.titre,
      this.color,
      this.form,
      this.userCreate,
      this.token,
      this.createdAt,
      this.id});

  FolderForm.fromJson(Map<String, dynamic> json) {
    titre = json['titre'];
    color = json['color'];
    if (json['form'] != null) {
      form = <String>[];
      json['form'].forEach((v) {
        form!.add(v);
      });
    }
    userCreate = json['userCreate'];
    token = json['token'];
    createdAt = json['createdAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titre'] = this.titre;
    data['color'] = this.color;
    if (this.form != null) {
      data['form'] = this.form!.map((v) => v).toList();
    }
    data['userCreate'] = this.userCreate;
    data['token'] = this.token;
    data['createdAt'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
