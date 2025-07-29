class FormulaireSondeurModel {
  String? date;
  List<String>? champs;
  Logo? logo;
  Logo? cover;
  FolderForm? folderForm;
  int? responseTotal;
  List<String>? response;
  List<Map<String, dynamic>>? responseSondee;
  FormulaireSettings? settings;
  String? archived;
  String? deleted;
  String? createdAt;
  String? titre;
  String? description;
  String? admin;
  String? id;
  bool? isPublic;

  FormulaireSondeurModel({
    this.date,
    this.champs,
    this.logo,
    this.cover,
    this.folderForm,
    this.responseTotal,
    this.response,
    this.responseSondee,
    this.settings,
    this.archived,
    this.deleted,
    this.createdAt,
    this.titre,
    this.description,
    this.admin,
    this.id,
    this.isPublic,
  });

  FormulaireSondeurModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    champs = json['champs']?.cast<String>();
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    cover = json['cover'] != null ? Logo.fromJson(json['cover']) : null;
    folderForm = json['folderForm'] != null
        ? FolderForm.fromJson(json['folderForm'])
        : null;
    responseTotal = json['responseTotal'];
    response = json['response']?.cast<String>();
    responseSondee = json['responseSondee']?.cast<Map<String, dynamic>>();
    settings = json['settings'] != null
        ? FormulaireSettings.fromJson(json['settings'])
        : null;
    archived = json['archived'];
    deleted = json['deleted'];
    createdAt = json['createdAt'];
    titre = json['titre'];
    description = json['description'];
    admin = json['admin'];
    id = json['id'];
    isPublic = json['isPublic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['response'] = this.response;
    data['responseSondee'] = this.responseSondee;
    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }
    data['archived'] = this.archived;
    data['deleted'] = this.deleted;
    data['createdAt'] = this.createdAt;
    data['titre'] = this.titre;
    data['description'] = this.description;
    data['admin'] = this.admin;
    data['id'] = this.id;
    data['isPublic'] = this.isPublic;
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

class FormulaireSettings {
  GeneralSettings? general;
  NotificationSettings? notifications;
  SchedulingSettings? scheduling;
  LocalizationSettings? localization;
  SecuritySettings? security;

  FormulaireSettings({
    this.general,
    this.notifications,
    this.scheduling,
    this.localization,
    this.security,
  });

  FormulaireSettings.fromJson(Map<String, dynamic> json) {
    general = json['general'] != null
        ? GeneralSettings.fromJson(json['general'])
        : null;
    notifications = json['notifications'] != null
        ? NotificationSettings.fromJson(json['notifications'])
        : null;
    scheduling = json['scheduling'] != null
        ? SchedulingSettings.fromJson(json['scheduling'])
        : null;
    localization = json['localization'] != null
        ? LocalizationSettings.fromJson(json['localization'])
        : null;
    security = json['security'] != null
        ? SecuritySettings.fromJson(json['security'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.general != null) {
      data['general'] = this.general!.toJson();
    }
    if (this.notifications != null) {
      data['notifications'] = this.notifications!.toJson();
    }
    if (this.scheduling != null) {
      data['scheduling'] = this.scheduling!.toJson();
    }
    if (this.localization != null) {
      data['localization'] = this.localization!.toJson();
    }
    if (this.security != null) {
      data['security'] = this.security!.toJson();
    }
    return data;
  }
}

class GeneralSettings {
  bool? connectionRequired;
  bool? autoSave;
  bool? publicForm;
  bool? limitResponses;
  int? maxResponses;
  bool? anonymousResponses;

  GeneralSettings({
    this.connectionRequired,
    this.autoSave,
    this.publicForm,
    this.limitResponses,
    this.maxResponses,
    this.anonymousResponses,
  });

  GeneralSettings.fromJson(Map<String, dynamic> json) {
    connectionRequired = json['connectionRequired'];
    autoSave = json['autoSave'];
    publicForm = json['publicForm'];
    limitResponses = json['limitResponses'];
    maxResponses = json['maxResponses'];
    anonymousResponses = json['anonymousResponses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['connectionRequired'] = this.connectionRequired;
    data['autoSave'] = this.autoSave;
    data['publicForm'] = this.publicForm;
    data['limitResponses'] = this.limitResponses;
    data['maxResponses'] = this.maxResponses;
    data['anonymousResponses'] = this.anonymousResponses;
    return data;
  }
}

class NotificationSettings {
  bool? enabled;
  bool? emailNotifications;
  bool? dailySummary;

  NotificationSettings({
    this.enabled,
    this.emailNotifications,
    this.dailySummary,
  });

  NotificationSettings.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
    emailNotifications = json['emailNotifications'];
    dailySummary = json['dailySummary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['enabled'] = this.enabled;
    data['emailNotifications'] = this.emailNotifications;
    data['dailySummary'] = this.dailySummary;
    return data;
  }
}

class SchedulingSettings {
  String? startDate;
  String? endDate;
  String? timezone;

  SchedulingSettings({
    this.startDate,
    this.endDate,
    this.timezone,
  });

  SchedulingSettings.fromJson(Map<String, dynamic> json) {
    startDate = json['startDate'];
    endDate = json['endDate'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['timezone'] = this.timezone;
    return data;
  }
}

class LocalizationSettings {
  String? language;
  String? timezone;

  LocalizationSettings({
    this.language,
    this.timezone,
  });

  LocalizationSettings.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['language'] = this.language;
    data['timezone'] = this.timezone;
    return data;
  }
}

class SecuritySettings {
  bool? dataEncryption;
  bool? anonymousResponses;

  SecuritySettings({
    this.dataEncryption,
    this.anonymousResponses,
  });

  SecuritySettings.fromJson(Map<String, dynamic> json) {
    dataEncryption = json['dataEncryption'];
    anonymousResponses = json['anonymousResponses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['dataEncryption'] = this.dataEncryption;
    data['anonymousResponses'] = this.anonymousResponses;
    return data;
  }
}
