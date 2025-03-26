class NiveauAcademiqueModel {
  String? titre;
  String? description;
  String? id;

  NiveauAcademiqueModel({this.titre, this.description, this.id});

  NiveauAcademiqueModel.fromJson(Map<String, dynamic> json) {
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

  static List<NiveauAcademiqueModel> fromList({required data}) {
    List<NiveauAcademiqueModel> liste = [];
    for (var element in data) {
      liste.add(NiveauAcademiqueModel.fromJson(element));
    }
    return liste;
  }
}
