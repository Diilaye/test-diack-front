import 'package:flutter/foundation.dart';
import 'package:form/services/formulaire-settings-service.dart';

class FormulaireSettingsBloc extends ChangeNotifier {
  FormulaireSettingsService? _service;
  FormulaireSettingsModel? _settings;
  bool _isLoading = false;
  String? _error;

  // Getters
  FormulaireSettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // État local pour les modifications
  late GeneralSettings _localGeneralSettings;
  late NotificationSettings _localNotificationSettings;
  late SchedulingSettings _localSchedulingSettings;
  late LocalizationSettings _localLocalizationSettings;
  late SecuritySettings _localSecuritySettings;

  // Getters pour les paramètres locaux
  GeneralSettings get localGeneralSettings => _localGeneralSettings;
  NotificationSettings get localNotificationSettings =>
      _localNotificationSettings;
  SchedulingSettings get localSchedulingSettings => _localSchedulingSettings;
  LocalizationSettings get localLocalizationSettings =>
      _localLocalizationSettings;
  SecuritySettings get localSecuritySettings => _localSecuritySettings;

  // Indicateurs de modifications
  bool _hasChanges = false;
  bool get hasChanges => _hasChanges;

  /// Initialiser le service avec les paramètres d'authentification
  void initService(String baseUrl, String token) {
    _service = FormulaireSettingsService(baseUrl: baseUrl, token: token);
  }

  /// Charger les paramètres d'un formulaire
  Future<void> loadSettings(String formulaireId) async {
    if (_service == null) return;

    _setLoading(true);
    _error = null;

    try {
      final settings = await _service!.getSettings(formulaireId);
      if (settings != null) {
        _settings = settings;
        _initLocalSettings();
        _hasChanges = false;
      } else {
        _error = 'Erreur lors du chargement des paramètres';
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Initialiser les paramètres locaux avec les valeurs chargées
  void _initLocalSettings() {
    if (_settings == null) return;

    _localGeneralSettings = GeneralSettings(
      connectionRequired: _settings!.general.connectionRequired,
      autoSave: _settings!.general.autoSave,
      publicForm: _settings!.general.publicForm,
      limitResponses: _settings!.general.limitResponses,
      maxResponses: _settings!.general.maxResponses,
      anonymousResponses: _settings!.general.anonymousResponses,
    );

    _localNotificationSettings = NotificationSettings(
      enabled: _settings!.notifications.enabled,
      emailNotifications: _settings!.notifications.emailNotifications,
      dailySummary: _settings!.notifications.dailySummary,
    );

    _localSchedulingSettings = SchedulingSettings(
      startDate: _settings!.scheduling.startDate,
      endDate: _settings!.scheduling.endDate,
      timezone: _settings!.scheduling.timezone,
    );

    _localLocalizationSettings = LocalizationSettings(
      language: _settings!.localization.language,
      timezone: _settings!.localization.timezone,
    );

    _localSecuritySettings = SecuritySettings(
      dataEncryption: _settings!.security.dataEncryption,
      anonymousResponses: _settings!.security.anonymousResponses,
    );
  }

  /// Mettre à jour les paramètres généraux localement
  void updateLocalGeneralSettings({
    bool? connectionRequired,
    bool? autoSave,
    bool? publicForm,
    bool? limitResponses,
    int? maxResponses,
    bool? anonymousResponses,
  }) {
    _localGeneralSettings = _localGeneralSettings.copyWith(
      connectionRequired: connectionRequired,
      autoSave: autoSave,
      publicForm: publicForm,
      limitResponses: limitResponses,
      maxResponses: maxResponses,
      anonymousResponses: anonymousResponses,
    );
    _hasChanges = true;
    notifyListeners();
  }

  /// Mettre à jour les paramètres de notification localement
  void updateLocalNotificationSettings({
    bool? enabled,
    bool? emailNotifications,
    bool? dailySummary,
  }) {
    _localNotificationSettings = _localNotificationSettings.copyWith(
      enabled: enabled,
      emailNotifications: emailNotifications,
      dailySummary: dailySummary,
    );
    _hasChanges = true;
    notifyListeners();
  }

  /// Mettre à jour les paramètres de planification localement
  void updateLocalSchedulingSettings({
    DateTime? startDate,
    DateTime? endDate,
    String? timezone,
  }) {
    _localSchedulingSettings = _localSchedulingSettings.copyWith(
      startDate: startDate,
      endDate: endDate,
      timezone: timezone,
    );
    _hasChanges = true;
    notifyListeners();
  }

  /// Mettre à jour les paramètres de localisation localement
  void updateLocalLocalizationSettings({
    String? language,
    String? timezone,
  }) {
    _localLocalizationSettings = _localLocalizationSettings.copyWith(
      language: language,
      timezone: timezone,
    );
    _hasChanges = true;
    notifyListeners();
  }

  /// Mettre à jour les paramètres de sécurité localement
  void updateLocalSecuritySettings({
    bool? dataEncryption,
    bool? anonymousResponses,
  }) {
    _localSecuritySettings = _localSecuritySettings.copyWith(
      dataEncryption: dataEncryption,
      anonymousResponses: anonymousResponses,
    );
    _hasChanges = true;
    notifyListeners();
  }

  /// Sauvegarder tous les paramètres
  Future<bool> saveAllSettings(String formulaireId) async {
    if (_service == null || !_hasChanges) return false;

    _setLoading(true);
    _error = null;

    try {
      final newSettings = FormulaireSettingsModel(
        general: _localGeneralSettings,
        notifications: _localNotificationSettings,
        scheduling: _localSchedulingSettings,
        localization: _localLocalizationSettings,
        security: _localSecuritySettings,
      );

      final success =
          await _service!.updateAllSettings(formulaireId, newSettings);

      if (success) {
        _settings = newSettings;
        _hasChanges = false;
        return true;
      } else {
        _error = 'Erreur lors de la sauvegarde';
        return false;
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sauvegarder les paramètres généraux seulement
  Future<bool> saveGeneralSettings(String formulaireId) async {
    if (_service == null) return false;

    _setLoading(true);
    _error = null;

    try {
      final success = await _service!
          .updateGeneralSettings(formulaireId, _localGeneralSettings);

      if (success) {
        _settings = _settings!.copyWith(general: _localGeneralSettings);
        return true;
      } else {
        _error = 'Erreur lors de la sauvegarde des paramètres généraux';
        return false;
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sauvegarder les paramètres de notification seulement
  Future<bool> saveNotificationSettings(String formulaireId) async {
    if (_service == null) return false;

    _setLoading(true);
    _error = null;

    try {
      final success = await _service!
          .updateNotificationSettings(formulaireId, _localNotificationSettings);

      if (success) {
        _settings =
            _settings!.copyWith(notifications: _localNotificationSettings);
        return true;
      } else {
        _error = 'Erreur lors de la sauvegarde des paramètres de notification';
        return false;
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Annuler les modifications locales
  void cancelChanges() {
    if (_settings != null) {
      _initLocalSettings();
      _hasChanges = false;
      notifyListeners();
    }
  }

  /// Réinitialiser les paramètres aux valeurs par défaut
  Future<bool> resetSettings(String formulaireId) async {
    if (_service == null) return false;

    _setLoading(true);
    _error = null;

    try {
      final success = await _service!.resetSettings(formulaireId);

      if (success) {
        await loadSettings(formulaireId); // Recharger les paramètres
        return true;
      } else {
        _error = 'Erreur lors de la réinitialisation';
        return false;
      }
    } catch (e) {
      _error = 'Erreur de connexion: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Vérifier si le formulaire est accessible
  bool isFormAccessible() {
    if (_settings == null) return false;

    final now = DateTime.now();

    // Vérifier les dates de planification
    if (_settings!.scheduling.startDate != null &&
        now.isBefore(_settings!.scheduling.startDate!)) {
      return false;
    }

    if (_settings!.scheduling.endDate != null &&
        now.isAfter(_settings!.scheduling.endDate!)) {
      return false;
    }

    return true;
  }

  /// Obtenir le message d'inaccessibilité
  String? getInaccessibilityMessage() {
    if (_settings == null) return null;

    final now = DateTime.now();

    if (_settings!.scheduling.startDate != null &&
        now.isBefore(_settings!.scheduling.startDate!)) {
      return 'Ce formulaire sera disponible à partir du ${_settings!.scheduling.startDate!.day}/${_settings!.scheduling.startDate!.month}/${_settings!.scheduling.startDate!.year}';
    }

    if (_settings!.scheduling.endDate != null &&
        now.isAfter(_settings!.scheduling.endDate!)) {
      return 'Ce formulaire n\'est plus disponible depuis le ${_settings!.scheduling.endDate!.day}/${_settings!.scheduling.endDate!.month}/${_settings!.scheduling.endDate!.year}';
    }

    return null;
  }

  /// Définir l'état de chargement
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Nettoyer les ressources
  void dispose() {
    _service = null;
    _settings = null;
    _error = null;
    super.dispose();
  }
}

// Extension pour la copie des paramètres
extension FormulaireSettingsModelExtension on FormulaireSettingsModel {
  FormulaireSettingsModel copyWith({
    GeneralSettings? general,
    NotificationSettings? notifications,
    SchedulingSettings? scheduling,
    LocalizationSettings? localization,
    SecuritySettings? security,
  }) {
    return FormulaireSettingsModel(
      general: general ?? this.general,
      notifications: notifications ?? this.notifications,
      scheduling: scheduling ?? this.scheduling,
      localization: localization ?? this.localization,
      security: security ?? this.security,
    );
  }
}
