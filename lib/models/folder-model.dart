class FolderModel {
  String? titre;
  String? color;
  String? id;

  userCreateModel? userCreate;

  FolderModel({this.titre, this.color, this.id, this.userCreate});

  FolderModel.fromJson(Map<String, dynamic> json) {
    titre = json['titre'];
    color = json['color'];
    id = json['id'];
    userCreate = json['userCreate'] != null
        ? new userCreateModel.fromJson(json['userCreate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titre'] = this.titre;
    data['color'] = this.color;
    data['id'] = this.id;
    if (this.userCreate != null) {
      data['userCreate'] = this.userCreate!.toJson();
    }
    return data;
  }

  static List<FolderModel> fromList({required data}) {
    List<FolderModel> liste = [];
    for (var element in data) {
      liste.add(FolderModel.fromJson(element));
    }
    return liste;
  }
}

class userCreateModel {
  String? type;
  String? nom;
  String? email;
  String? prenom;
  String? adresse;
  String? telephone;
  String? id;

  userCreateModel(
      {this.type,
      this.nom,
      this.email,
      this.prenom,
      this.adresse,
      this.telephone,
      this.id});

  userCreateModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    nom = json['nom'];
    email = json['email'];
    prenom = json['prenom'];
    adresse = json['adresse'];
    telephone = json['telephone'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['nom'] = this.nom;
    data['email'] = this.email;
    data['prenom'] = this.prenom;
    data['adresse'] = this.adresse;
    data['telephone'] = this.telephone;
    data['id'] = this.id;
    return data;
  }
}
