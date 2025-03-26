class ChampsFormulaireModel {
  List<ListeOptions>? listeOptions;
  String? isObligatoire;
  String? haveResponse;
  String? notes;
  String? type;
  String? nom;
  String? description;
  String? formulaire;
  List<ReponseChamp>? listeReponses;
  String? id;

  ChampsFormulaireModel(
      {this.listeOptions,
      this.isObligatoire,
      this.haveResponse,
      this.notes,
      this.type,
      this.nom,
      this.description,
      this.formulaire,
      this.listeReponses,
      this.id});

  ChampsFormulaireModel.fromJson(Map<String, dynamic> json) {
    if (json['listeOptions'] != null) {
      listeOptions = <ListeOptions>[];
      json['listeOptions'].forEach((v) {
        listeOptions!.add(new ListeOptions.fromJson(v));
      });
    }
    isObligatoire = json['isObligatoire'];
    haveResponse = json['haveResponse'];
    notes = json['notes'];
    type = json['type'];
    nom = json['nom'];
    description = json['description'];
    formulaire = json['formulaire'];
    if (json['listeReponses'] != null) {
      listeReponses = <ReponseChamp>[];
      json['listeReponses'].forEach((v) {
        listeReponses!.add(new ReponseChamp.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listeOptions != null) {
      data['listeOptions'] = this.listeOptions!.map((v) => v.toJson()).toList();
    }
    data['isObligatoire'] = this.isObligatoire;
    data['haveResponse'] = this.haveResponse;
    data['notes'] = this.notes;
    data['type'] = this.type;
    data['nom'] = this.nom;
    data['description'] = this.description;
    data['formulaire'] = this.formulaire;
    if (this.listeReponses != null) {
      data['listeReponses'] =
          this.listeReponses!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }

  static List<ChampsFormulaireModel> fromList({required data}) {
    List<ChampsFormulaireModel> liste = [];
    for (var element in data) {
      liste.add(ChampsFormulaireModel.fromJson(element));
    }
    return liste;
  }
}

class ListeOptions {
  String? option;
  String? id;

  ListeOptions({this.option, this.id});

  ListeOptions.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['id'] = this.id;
    return data;
  }
}

class ReponseChamp {
  String? option;
  String? id;

  ReponseChamp({this.option, this.id});

  ReponseChamp.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['id'] = this.id;
    return data;
  }
}
