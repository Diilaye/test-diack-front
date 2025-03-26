class MatiereModel {
  String? titre;
  String? description;
  String? id;

  MatiereModel({this.titre, this.description, this.id});

  MatiereModel.fromJson(Map<String, dynamic> json) {
    titre = json['titre'];
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titre'] = this.titre;
    data['description'] = this.description;
    data['id'] = this.id;
    return data;
  }

  static List<MatiereModel> fromList({required data}) {
    List<MatiereModel> liste = [];
    for (var element in data) {
      liste.add(MatiereModel.fromJson(element));
    }
    return liste;
  }
}
