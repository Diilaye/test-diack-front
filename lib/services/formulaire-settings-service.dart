import 'dart:convert';
import 'package:http/http.dart' as http;

class FormulaireSettingsModel {
  final GeneralSettings general;
  final NotificationSettings notifications;
  final SchedulingSettings scheduling;
  final LocalizationSettings localization;
  final SecuritySettings security;

  FormulaireSettingsModel({
    required this.general,
    required this.notifications,
    required this.scheduling,
    required this.localization,
    required this.security,
  });

  factory FormulaireSettingsModel.fromJson(Map<String, dynamic> json) {
    return FormulaireSettingsModel(
      general: GeneralSettings.fromJson(json['general'] ?? {}),
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
      scheduling: SchedulingSettings.fromJson(json['scheduling'] ?? {}),
      localization: LocalizationSettings.fromJson(json['localization'] ?? {}),
      security: SecuritySettings.fromJson(json['security'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'general': general.toJson(),
      'notifications': notifications.toJson(),
      'scheduling': scheduling.toJson(),
      'localization': localization.toJson(),
      'security': security.toJson(),
    };
  }
}

class GeneralSettings {
  final bool connectionRequired;
  final bool autoSave;
  final bool publicForm;
  final bool limitResponses;
  final int maxResponses;
  final bool anonymousResponses;

  GeneralSettings({
    required this.connectionRequired,
    required this.autoSave,
    required this.publicForm,
    required this.limitResponses,
    required this.maxResponses,
    required this.anonymousResponses,
  });

  factory GeneralSettings.fromJson(Map<String, dynamic> json) {
    return GeneralSettings(
      connectionRequired: json['connectionRequired'] ?? false,
      autoSave: json['autoSave'] ?? true,
      publicForm: json['publicForm'] ?? false,
      limitResponses: json['limitResponses'] ?? false,
      maxResponses: json['maxResponses'] ?? 100,
      anonymousResponses: json['anonymousResponses'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'connectionRequired': connectionRequired,
      'autoSave': autoSave,
      'publicForm': publicForm,
      'limitResponses': limitResponses,
      'maxResponses': maxResponses,
      'anonymousResponses': anonymousResponses,
    };
  }

  GeneralSettings copyWith({
    bool? connectionRequired,
    bool? autoSave,
    bool? publicForm,
    bool? limitResponses,
    int? maxResponses,
    bool? anonymousResponses,
  }) {
    return GeneralSettings(
      connectionRequired: connectionRequired ?? this.connectionRequired,
      autoSave: autoSave ?? this.autoSave,
      publicForm: publicForm ?? this.publicForm,
      limitResponses: limitResponses ?? this.limitResponses,
      maxResponses: maxResponses ?? this.maxResponses,
      anonymousResponses: anonymousResponses ?? this.anonymousResponses,
    );
  }
}

class NotificationSettings {
  final bool enabled;
  final bool emailNotifications;
  final bool dailySummary;

  NotificationSettings({
    required this.enabled,
    required this.emailNotifications,
    required this.dailySummary,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      enabled: json['enabled'] ?? true,
      emailNotifications: json['emailNotifications'] ?? true,
      dailySummary: json['dailySummary'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'emailNotifications': emailNotifications,
      'dailySummary': dailySummary,
    };
  }

  NotificationSettings copyWith({
    bool? enabled,
    bool? emailNotifications,
    bool? dailySummary,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      dailySummary: dailySummary ?? this.dailySummary,
    );
  }
}

class SchedulingSettings {
  final DateTime? startDate;
  final DateTime? endDate;
  final String timezone;

  SchedulingSettings({
    this.startDate,
    this.endDate,
    required this.timezone,
  });

  factory SchedulingSettings.fromJson(Map<String, dynamic> json) {
    return SchedulingSettings(
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      timezone: json['timezone'] ?? 'Europe/Paris',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'timezone': timezone,
    };
  }

  SchedulingSettings copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? timezone,
  }) {
    return SchedulingSettings(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timezone: timezone ?? this.timezone,
    );
  }
}

class LocalizationSettings {
  final String language;
  final String timezone;

  LocalizationSettings({
    required this.language,
    required this.timezone,
  });

  factory LocalizationSettings.fromJson(Map<String, dynamic> json) {
    return LocalizationSettings(
      language: json['language'] ?? 'fr',
      timezone: json['timezone'] ?? 'Europe/Paris',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'timezone': timezone,
    };
  }

  LocalizationSettings copyWith({
    String? language,
    String? timezone,
  }) {
    return LocalizationSettings(
      language: language ?? this.language,
      timezone: timezone ?? this.timezone,
    );
  }
}

class SecuritySettings {
  final bool dataEncryption;
  final bool anonymousResponses;

  SecuritySettings({
    required this.dataEncryption,
    required this.anonymousResponses,
  });

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      dataEncryption: json['dataEncryption'] ?? true,
      anonymousResponses: json['anonymousResponses'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataEncryption': dataEncryption,
      'anonymousResponses': anonymousResponses,
    };
  }

  SecuritySettings copyWith({
    bool? dataEncryption,
    bool? anonymousResponses,
  }) {
    return SecuritySettings(
      dataEncryption: dataEncryption ?? this.dataEncryption,
      anonymousResponses: anonymousResponses ?? this.anonymousResponses,
    );
  }
}

class FormulaireSettingsService {
  final String baseUrl;
  final String token;

  FormulaireSettingsService({
    required this.baseUrl,
    required this.token,
  });

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// Récupérer les paramètres d'un formulaire
  Future<FormulaireSettingsModel?> getSettings(String formulaireId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return FormulaireSettingsModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des paramètres: $e');
      return null;
    }
  }

  /// Mettre à jour les paramètres généraux
  Future<bool> updateGeneralSettings(
      String formulaireId, GeneralSettings settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/general'),
        headers: headers,
        body: json.encode(settings.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la mise à jour des paramètres généraux: $e');
      return false;
    }
  }

  /// Mettre à jour les paramètres de notification
  Future<bool> updateNotificationSettings(
      String formulaireId, NotificationSettings settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/notifications'),
        headers: headers,
        body: json.encode(settings.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la mise à jour des paramètres de notification: $e');
      return false;
    }
  }

  /// Mettre à jour les paramètres de planification
  Future<bool> updateSchedulingSettings(
      String formulaireId, SchedulingSettings settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/scheduling'),
        headers: headers,
        body: json.encode(settings.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print(
          'Erreur lors de la mise à jour des paramètres de planification: $e');
      return false;
    }
  }

  /// Mettre à jour les paramètres de localisation
  Future<bool> updateLocalizationSettings(
      String formulaireId, LocalizationSettings settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/localization'),
        headers: headers,
        body: json.encode(settings.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la mise à jour des paramètres de localisation: $e');
      return false;
    }
  }

  /// Mettre à jour les paramètres de sécurité
  Future<bool> updateSecuritySettings(
      String formulaireId, SecuritySettings settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/security'),
        headers: headers,
        body: json.encode(settings.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la mise à jour des paramètres de sécurité: $e');
      return false;
    }
  }

  /// Mettre à jour tous les paramètres
  Future<bool> updateAllSettings(
      String formulaireId, FormulaireSettingsModel settings) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/all'),
        headers: headers,
        body: json.encode(settings.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la mise à jour de tous les paramètres: $e');
      return false;
    }
  }

  /// Réinitialiser les paramètres
  Future<bool> resetSettings(String formulaireId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/formulaire-settings/$formulaireId/reset'),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la réinitialisation des paramètres: $e');
      return false;
    }
  }
}
