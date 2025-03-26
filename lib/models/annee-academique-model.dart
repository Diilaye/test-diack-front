class AnneeAcademiqueModel {
  String? titre;
  String? debut;
  String? fin;
  String? id;

  AnneeAcademiqueModel({this.titre, this.debut, this.fin, this.id});

  AnneeAcademiqueModel.fromJson(Map<String, dynamic> json) {
    titre = json['titre'];
    debut = json['debut'];
    fin = json['fin'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titre'] = this.titre;
    data['debut'] = this.debut;
    data['fin'] = this.fin;
    data['id'] = this.id;
    return data;
  }

  static List<AnneeAcademiqueModel> fromList({required data}) {
    List<AnneeAcademiqueModel> liste = [];
    for (var element in data) {
      liste.add(AnneeAcademiqueModel.fromJson(element));
    }
    return liste;
  }
}
