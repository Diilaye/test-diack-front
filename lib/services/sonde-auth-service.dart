import 'package:form/utils/requette-by-dii.dart';

class SondeAuthService {
  /// Authentifier une sonde avec email et mot de passe
  Future<bool> authenticateSonde({
    required String email,
    required String password,
    required String formulaireId,
  }) async {
    try {
      final body = {
        'email': email,
        'password': password,
        'formulaireId': formulaireId,
      };

      final response = await postResponse(
        url: '/sonde/authenticate',
        body: body,
      );

      if (response['status'] == 200 || response['status'] == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erreur authentification sonde: $e');
      return false;
    }
  }

  /// Vérifier si une sonde est autorisée à accéder à un formulaire
  Future<bool> canAccessFormulaire({
    required String sondeEmail,
    required String formulaireId,
  }) async {
    try {
      final response = await getResponse(
        url: '/sonde/access-check?email=$sondeEmail&formulaireId=$formulaireId',
      );

      if (response['status'] == 200) {
        return response['body']['data']['hasAccess'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Erreur vérification accès: $e');
      return false;
    }
  }

  /// Enregistrer les informations d'authentification localement
  Future<void> saveAuthInfo({
    required String email,
    required String formulaireId,
  }) async {
    // TODO: Implémenter la sauvegarde locale avec SharedPreferences si nécessaire
  }
}
