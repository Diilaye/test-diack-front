class ReponseSondeurModel {
  String? responseID;
  String? responseEtat;
  String? responseEtatID;
  String? champ;
  String? sondeur;
  String? id;

  ReponseSondeurModel(
      {this.responseID,
      this.responseEtat,
      this.responseEtatID,
      this.champ,
      this.sondeur,
      this.id});

  ReponseSondeurModel.fromJson(Map<String, dynamic> json) {
    responseID = json['responseID'];
    responseEtat = json['responseEtat'];
    responseEtatID = json['responseEtatID'];
    champ = json['champ'];
    sondeur = json['sondeur'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseID'] = this.responseID;
    data['responseEtat'] = this.responseEtat;
    data['responseEtatID'] = this.responseEtatID;
    data['champ'] = this.champ;
    data['sondeur'] = this.sondeur;
    data['id'] = this.id;
    return data;
  }

  static List<ReponseSondeurModel> fromList({required data}) {
    List<ReponseSondeurModel> liste = [];
    for (var element in data) {
      liste.add(ReponseSondeurModel.fromJson(element));
    }
    return liste;
  }
}
