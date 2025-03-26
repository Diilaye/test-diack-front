class UserModel {
  String? type;
  String? nom;
  String? email;
  String? prenom;
  String? adresse;
  String? fonction;
  String? telephone;
  String? token;
  String? id;
  String? isProfileComplete;

  UserModel(
      {this.type,
      this.nom,
      this.email,
      this.prenom,
      this.adresse,
      this.fonction,
      this.telephone,
      this.token,
      this.isProfileComplete,
      this.id});

  UserModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    nom = json['nom'];
    email = json['email'];
    prenom = json['prenom'];
    adresse = json['adresse'];
    fonction = json['fonction'];
    telephone = json['telephone'];
    isProfileComplete = json['isProfileComplete'];
    token = json['token'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['nom'] = this.nom;
    data['email'] = this.email;
    data['prenom'] = this.prenom;
    data['adresse'] = this.adresse;
    data['fonction'] = this.fonction;
    data['telephone'] = this.telephone;
    data['token'] = this.token;
    data['isProfileComplete'] = this.isProfileComplete;
    data['id'] = this.id;
    return data;
  }

  static List<UserModel> fromList({required data}) {
    List<UserModel> liste = [];
    for (var element in data) {
      liste.add(UserModel.fromJson(element));
    }
    return liste;
  }
}
