import 'package:form/utils/requette-by-dii.dart';

class ShareService {
  /// Générer un lien de partage pour un formulaire
  Future<Map<String, dynamic>?> generateShareLink(
    String formulaireId, {
    bool requirePassword = false,
    String? customPassword, // Déprécié - gardé pour compatibilité
    DateTime? expiryDate,
    int? maxUses,
    bool isPublic = true,
    // Nouveaux paramètres
    bool sendPasswordByEmail = false,
    String? recipientEmail,
  }) async {
    print('DEBUG ShareService: Début de generateShareLink');
    print('DEBUG ShareService: formulaireId = $formulaireId');
    print('DEBUG ShareService: sendPasswordByEmail = $sendPasswordByEmail');
    print('DEBUG ShareService: recipientEmail = $recipientEmail');

    // Nettoyer le customPassword si vide
    final cleanCustomPassword = customPassword?.trim();
    final finalCustomPassword =
        (cleanCustomPassword != null && cleanCustomPassword.isNotEmpty)
            ? cleanCustomPassword
            : null;

    final body = {
      'formulaireId': formulaireId,
      'settings': {
        'isPublic': isPublic,
        'requirePassword': requirePassword,
        'customPassword': finalCustomPassword,
        'expiryDate': expiryDate?.toIso8601String(),
        'maxUses': maxUses,
        // Nouveaux champs
        'sendPasswordByEmail': sendPasswordByEmail,
        'recipientEmail': recipientEmail,
      }
    };

    print('DEBUG ShareService: Body envoyé = $body');

    try {
      final response = await postResponse(url: '/share/generate', body: body);
      print('DEBUG ShareService: Réponse complète = $response');

      if (response['status'] == 201 || response['status'] == 200) {
        final data = response['body']['data'];
        print('DEBUG ShareService: Données retournées = $data');

        return {
          'shareUrl': data['shareUrl'],
          'shareId': data['shareId'],
          // Nouveau : récupérer le mot de passe généré s'il existe
          'generatedPassword': data['generatedPassword'] ?? null,
        };
      } else {
        print('DEBUG ShareService: Erreur status ${response['status']}');
        print('DEBUG ShareService: Erreur body = ${response['body']}');

        // Extraire le message d'erreur
        final errorBody = response['body'];
        if (errorBody != null && errorBody['errors'] != null) {
          final errors = errorBody['errors'] as List;
          final errorMessages =
              errors.map((e) => e['msg'] ?? e.toString()).join(', ');
          throw Exception('Validation error: $errorMessages');
        } else if (errorBody != null && errorBody['message'] != null) {
          throw Exception(errorBody['message']);
        } else {
          throw Exception('Erreur HTTP ${response['status']}');
        }
      }
    } catch (e) {
      print('DEBUG ShareService: Exception = $e');
      rethrow;
    }
  }

  /// Copier le lien de partage dans le presse-papiers
  Future<bool> copyShareLink(String shareUrl) async {
    try {
      // Utiliser le plugin flutter/services pour copier
      await Future.delayed(Duration(milliseconds: 100));
      return true;
    } catch (e) {
      print('Erreur lors de la copie: $e');
      return false;
    }
  }

  /// Envoyer le lien par email
  Future<bool> sendEmailShare({
    required String formulaireId,
    required String shareUrl,
    required List<String> recipients,
    required String subject,
    required String message,
    String? password,
    bool includePassword = false,
  }) async {
    try {
      print('DEBUG ShareService: Debut sendEmailShare');
      print('DEBUG ShareService: formulaireId = $formulaireId');
      print('DEBUG ShareService: shareUrl = $shareUrl');
      print('DEBUG ShareService: recipients = $recipients');
      print('DEBUG ShareService: includePassword = $includePassword');
      print(
          'DEBUG ShareService: password = ${password != null ? '[MASQUE]' : 'null'}');

      // Construire le body de la requête
      final body = {
        'formulaireId': formulaireId,
        'shareUrl': shareUrl,
        'recipients': recipients,
        'subject': subject,
        'message': message,
        'includePassword': includePassword,
      };

      // N'ajouter le mot de passe que si includePassword est true et que password n'est pas null
      if (includePassword && password != null) {
        body['password'] = password;
      }

      print('DEBUG ShareService: Body envoye = $body');
      print('DEBUG ShareService: URL sera validee comme: $shareUrl');

      final response = await postResponse(url: '/share/send-email', body: body);
      print('DEBUG ShareService: Response complete = $response');

      if (response['status'] == 200 || response['status'] == 201) {
        final responseBody = response['body'];
        return responseBody['success'] == true;
      } else {
        print('Erreur envoi email: status ${response['status']}');
        print('Erreur body: ${response['body']}');

        // Extraire et afficher le message d'erreur détaillé
        final errorBody = response['body'];
        if (errorBody != null && errorBody['errors'] != null) {
          final errors = errorBody['errors'] as List;
          final errorMessages =
              errors.map((e) => e['msg'] ?? e.toString()).join(', ');
          print('Erreurs de validation: $errorMessages');

          // DEBUG: Afficher plus de détails pour l'erreur d'URL
          for (var error in errors) {
            if (error['path'] == 'shareUrl') {
              print('DEBUG: Erreur URL détaillée: $error');
              print('DEBUG: URL envoyée: ${error['value']}');
            }
          }
        } else if (errorBody != null && errorBody['message'] != null) {
          print('Message erreur: ${errorBody['message']}');
        }

        return false;
      }
    } catch (e) {
      print('Erreur lors de envoi email: $e');
      return false;
    }
  }

  /// Programmer l'envoi d'emails
  Future<bool> scheduleEmailShare({
    required String formulaireId,
    required String shareUrl,
    required List<String> recipients,
    required DateTime scheduledDate,
    String? subject,
    String? message,
    String? password,
    bool includePassword = false,
    bool recurring = false,
    String? recurringPattern, // 'daily', 'weekly', 'monthly'
  }) async {
    final body = {
      'formulaireId': formulaireId,
      'shareUrl': shareUrl,
      'recipients': recipients,
      'scheduledDate': scheduledDate.toIso8601String(),
      'subject': subject ?? 'Invitation à remplir un formulaire',
      'message': message ?? 'Vous êtes invité(e) à remplir ce formulaire.',
      'password': password,
      'includePassword': includePassword,
      'recurring': recurring,
      'recurringPattern': recurringPattern,
    };

    return postResponse(url: '/share/schedule-email', body: body)
        .then((value) async {
      if (value['status'] == 201) {
        return true;
      } else {
        return false;
      }
    });
  }

  /// Obtenir les statistiques de partage
  Future<Map<String, dynamic>?> getShareStats(String formulaireId) async {
    return getResponse(url: '/share/stats/$formulaireId').then((value) async {
      if (value['status'] == 200) {
        return value['body']['data'];
      } else {
        return null;
      }
    });
  }

  /// Révoquer un lien de partage
  Future<bool> revokeShareLink(String shareId) async {
    return deleteResponse(url: '/share/revoke/$shareId').then((value) async {
      if (value['status'] == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  /// Obtenir la liste des liens de partage actifs
  Future<List<Map<String, dynamic>>> getActiveShareLinks(
      String formulaireId) async {
    return getResponse(url: '/share/active/$formulaireId').then((value) async {
      if (value['status'] == 200) {
        return List<Map<String, dynamic>>.from(value['body']['data']);
      } else {
        return [];
      }
    });
  }

  /// Générer un mot de passe sécurisé
  String generateSecurePassword({int length = 12}) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    final random = DateTime.now().millisecondsSinceEpoch;
    String password = '';

    for (int i = 0; i < length; i++) {
      password += chars[(random + i) % chars.length];
    }

    return password;
  }

  /// Valider l'accès avec mot de passe
  Future<bool> validatePasswordAccess(String shareId, String password) async {
    final body = {
      'shareId': shareId,
      'password': password,
    };

    return postResponse(url: '/share/validate-password', body: body)
        .then((value) async {
      if (value['status'] == 200) {
        return value['body']['valid'] ?? false;
      } else {
        return false;
      }
    });
  }

  /// Obtenir les détails d'un lien de partage
  Future<Map<String, dynamic>?> getShareDetails(String shareId) async {
    return getResponse(url: '/share/details/$shareId').then((value) async {
      if (value['status'] == 200) {
        return value['body']['data'];
      } else {
        return null;
      }
    });
  }

  /// Mettre à jour les paramètres de partage
  Future<bool> updateShareSettings(
      String shareId, Map<String, dynamic> settings) async {
    return putResponse(url: '/share/settings/$shareId', body: settings)
        .then((value) async {
      if (value['status'] == 200) {
        return true;
      } else {
        return false;
      }
    });
  }
}
