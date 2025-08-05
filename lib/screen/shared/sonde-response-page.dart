import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/services/formulaire-service.dart';
import 'package:form/services/sonde-auth-service.dart';
import 'package:form/screen/shared/widgets/form-response-field.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';

class SondeResponsePage extends StatefulWidget {
  final String formulaireId;
  final FormulaireSondeurModel? formulaire;
  final String? sondeId;

  const SondeResponsePage({
    Key? key,
    required this.formulaireId,
    this.formulaire,
    this.sondeId,
  }) : super(key: key);

  @override
  State<SondeResponsePage> createState() => _SondeResponsePageState();
}

class _SondeResponsePageState extends State<SondeResponsePage>
    with TickerProviderStateMixin {
  final FormulaireService _formulaireService = FormulaireService();
  final SondeAuthService _authService = SondeAuthService();
  final PageController _pageController = PageController();

  late AnimationController _progressAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  FormulaireSondeurModel? _formulaire;
  List<ChampsFormulaireModel> _champs = [];
  Map<String, dynamic> _responses = {};
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  int _currentPage = 0;
  int _totalPages = 1;
  String _sondeId = '';

  // Contrôleurs pour l'authentification
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _sondeId = widget.sondeId ?? _generateSondeId();
    _initAnimations();
    _loadFormData();
  }

  String _generateSondeId() {
    // Générer un ID unique pour la sonde
    return 'sonde_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _initAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    _fadeAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      FormulaireSondeurModel? formulaire = widget.formulaire;

      if (formulaire == null) {
        // Pour les tests, créer un formulaire factice si l'ID contient "test"
        if (widget.formulaireId.contains('public-form') ||
            widget.formulaireId.contains('private-form')) {
          formulaire = _createTestFormulaire();
        } else {
          // Charger le formulaire depuis l'API pour les vrais formulaires
          formulaire = await _formulaireService.one(widget.formulaireId);
        }
      }

      if (formulaire == null) {
        throw Exception('Formulaire non trouvé');
      }

      setState(() {
        _formulaire = formulaire;
        _isLoading = false;
      });

      // Vérifier si le formulaire est privé
      if (_isFormulairePrivate(formulaire)) {
        _showAuthenticationDialog();
      } else {
        // Formulaire public, charger directement les champs
        await _loadFormulaireChamps();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
        _isLoading = false;
      });
    }
  }

  FormulaireSondeurModel _createTestFormulaire() {
    final isPrivate = widget.formulaireId.contains('private');

    return FormulaireSondeurModel(
      id: widget.formulaireId,
      titre: isPrivate ? 'Formulaire Privé Test' : 'Formulaire Public Test',
      description: isPrivate
          ? 'Ce formulaire nécessite une authentification pour y accéder'
          : 'Ce formulaire est accessible à tous',
      admin: isPrivate ? 'admin@test.com' : null,
      champs: ['champ1', 'champ2', 'champ3'],
      date: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
      isPublic: !isPrivate,
      responseTotal: 0,
      archived: '0',
      deleted: '0',
      settings: FormulaireSettings(
        general: GeneralSettings(
          connectionRequired: isPrivate,
          autoSave: true,
          publicForm: !isPrivate,
          limitResponses: false,
          maxResponses: 100,
          anonymousResponses: !isPrivate,
        ),
        notifications: NotificationSettings(
          enabled: true,
          emailNotifications: true,
          dailySummary: false,
        ),
        scheduling: SchedulingSettings(
          timezone: 'Europe/Paris',
        ),
        localization: LocalizationSettings(
          language: 'fr',
          timezone: 'Europe/Paris',
        ),
        security: SecuritySettings(
          dataEncryption: true,
          anonymousResponses: !isPrivate,
        ),
      ),
    );
  }

  bool _isFormulairePrivate(FormulaireSondeurModel formulaire) {
    return formulaire.isPublic ?? false;
  }

  Future<void> _loadFormulaireChamps() async {
    try {
      // Pour les formulaires de test, créer des champs factices
      if (widget.formulaireId.contains('public-form') ||
          widget.formulaireId.contains('private-form')) {
        _champs = _createTestChamps();
      } else {
        // Charger les champs du formulaire depuis l'API pour les vrais formulaires
        _champs =
            await _formulaireService.getFormulaireChamps(_formulaire!.id!);
      }

      _totalPages = _calculateTotalPages();

      setState(() {
        _isAuthenticated = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement des champs: $e';
      });
    }
  }

  List<ChampsFormulaireModel> _createTestChamps() {
    return [
      ChampsFormulaireModel(
        id: 'intro_explanation',
        nom: 'Bienvenue dans notre enquête de satisfaction',
        type: 'explication',
        isObligatoire: '0',
        description: 'Cette enquête nous permettra d\'améliorer nos services. Veuillez répondre avec sincérité. Toutes vos réponses sont confidentielles et anonymes.',
      ),
      ChampsFormulaireModel(
        id: 'section_separator',
        nom: 'Informations personnelles',
        type: 'separator-title',
        isObligatoire: '0',
      ),
      ChampsFormulaireModel(
        id: 'champ1',
        nom: 'Votre nom complet',
        type: 'text',
        isObligatoire: '1',
        description: 'Veuillez entrer votre nom complet',
      ),
      ChampsFormulaireModel(
        id: 'simple_separator',
        type: 'separator',
        isObligatoire: '0',
      ),
      ChampsFormulaireModel(
        id: 'champ2',
        nom: 'Comment évaluez-vous notre service?',
        type: 'choix_unique',
        isObligatoire: '1',
        listeOptions: [
          ListeOptions(option: 'Excellent'),
          ListeOptions(option: 'Très bien'),
          ListeOptions(option: 'Bien'),
          ListeOptions(option: 'Moyen'),
          ListeOptions(option: 'Médiocre'),
        ],
      ),
      ChampsFormulaireModel(
        id: 'champ3',
        nom: 'Commentaires supplémentaires',
        type: 'textarea',
        isObligatoire: '0',
        description: 'Partagez vos commentaires ou suggestions',
      ),
      ChampsFormulaireModel(
        id: 'outro_explanation',
        nom: 'Merci pour votre participation !',
        type: 'explication',
        isObligatoire: '0',
        description: 'Vos réponses ont été prises en compte. Elles nous aideront à améliorer nos services pour mieux vous servir à l\'avenir.',
      ),
    ];
  }

  void _showAuthenticationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildAuthenticationDialog(),
    );
  }

  Future<void> _authenticateSonde() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showError('Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simuler une authentification - remplacez par votre logique d'authentification
      await Future.delayed(const Duration(seconds: 1));

      // Pour l'exemple, on accepte n'importe quel email/mot de passe
      // Remplacez par votre logique d'authentification réelle
      bool isAuthenticated = await _validateSondeCredentials(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (isAuthenticated) {
        setState(() {
          _isAuthenticated = true;
          _isAuthenticating = false;
        });

        Navigator.of(context).pop(); // Fermer la dialog
        await _loadFormulaireChamps(); // Charger les champs
      } else {
        setState(() {
          _isAuthenticating = false;
        });
        _showError('Email ou mot de passe incorrect');
      }
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      _showError('Erreur de connexion: $e');
    }
  }

  Future<bool> _validateSondeCredentials(String email, String password) async {
    try {
      // Pour les formulaires de test, utiliser une validation simple
      if (widget.formulaireId.contains('test') ||
          widget.formulaireId.contains('private-form')) {
        // Credentials de test : sonde@test.com / 123456
        return email.toLowerCase() == 'sonde@test.com' && password == '123456';
      }

      // Pour les vrais formulaires, utiliser le service d'authentification
      return await _authService.authenticateSonde(
        email: email,
        password: password,
        formulaireId: widget.formulaireId,
      );
    } catch (e) {
      print('Erreur validation credentials: $e');
      return false;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  int _calculateTotalPages() {
    if (_champs.isEmpty) return 1;
    return ((_champs.length - 1) ~/ 3) + 1; // 3 champs par page
  }

  Widget _buildAuthenticationDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [btnColor, btnColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                CupertinoIcons.lock_shield,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Formulaire Privé',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ce formulaire nécessite une authentification pour y accéder.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildAuthField(
              controller: _emailController,
              label: 'Email de la sonde',
              icon: CupertinoIcons.mail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildAuthField(
              controller: _passwordController,
              label: 'Mot de passe',
              icon: CupertinoIcons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAuthenticating ? null : _authenticateSonde,
                icon: _isAuthenticating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(CupertinoIcons.checkmark_alt),
                label:
                    Text(_isAuthenticating ? 'Connexion...' : 'Se connecter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/');
              },
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }

  List<ChampsFormulaireModel> _getChampsForPage(int pageIndex) {
    final startIndex = pageIndex * 3;
    final endIndex = (startIndex + 3).clamp(0, _champs.length);
    return _champs.sublist(startIndex, endIndex);
  }

  void _updateResponse(String champId, dynamic value) {
    setState(() {
      // Trouver le champ correspondant pour vérifier son type
      final champ = _champs.firstWhere((c) => c.id == champId,
          orElse: () => ChampsFormulaireModel());

      // Si c'est un champ de type date et que la valeur est une string,
      // essayer de la convertir en DateTime
      if (champ.type == 'date' && value is String && value.isNotEmpty) {
        try {
          // Parser la string en DateTime
          final parsedDate = DateTime.parse(value);
          _responses[champId] = parsedDate;
        } catch (e) {
          // Si le parsing échoue, stocker la valeur telle quelle
          _responses[champId] = value;
        }
      } else {
        _responses[champId] = value;
      }
    });
  }

  bool _isCurrentPageValid() {
    final champsForPage = _getChampsForPage(_currentPage);
    for (final champ in champsForPage) {
      // Ignorer les champs non-interactifs (séparateurs et explications)
      if (champ.type == 'separator' || 
          champ.type == 'separator-title' || 
          champ.type == 'separatorTitre' || 
          champ.type == 'explication') {
        continue;
      }
      
      if (champ.isObligatoire == '1') {
        final response = _responses[champ.id];
        if (response == null ||
            (response is String && response.trim().isEmpty) ||
            (response is List && response.isEmpty)) {
          return false;
        }
      }
    }
    return true;
  }

  void _nextPage() {
    if (!_isCurrentPageValid()) {
      _showValidationError();
      return;
    }

    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitForm();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Veuillez remplir tous les champs obligatoires'),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  String _mapChampTypeForAPI(String? type) {
    // Mapper les types de champs du frontend vers ceux attendus par le backend
    switch (type) {
      case 'choix_unique':
        return 'singleChoice';
      case 'choix_multiple':
        return 'multipleChoice';
      case 'text':
        return 'textField';
      case 'textarea':
        return 'textArea';
      case 'number':
        return 'numberField';
      case 'email':
        return 'emailField';
      case 'date':
        return 'dateField';
      default:
        return type ?? 'textField';
    }
  }

  bool _validateAllRequiredFields() {
    for (final champ in _champs) {
      // Ignorer les champs non-interactifs (séparateurs et explications)
      if (champ.type == 'separator' || 
          champ.type == 'separator-title' || 
          champ.type == 'separatorTitre' || 
          champ.type == 'explication') {
        continue;
      }
      
      if (champ.isObligatoire == '1') {
        final response = _responses[champ.id];
        if (response == null ||
            (response is String && response.trim().isEmpty) ||
            (response is List && response.isEmpty)) {
          // Afficher un message d'erreur spécifique
          _showValidationErrorForField(champ);
          return false;
        }
      }
    }
    return true;
  }

  void _showValidationErrorForField(ChampsFormulaireModel champ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Le champ "${champ.nom}" est obligatoire'),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _submitForm() async {
    // Valider tous les champs obligatoires avant la soumission
    if (!_validateAllRequiredFields()) {
      setState(() => _isSubmitting = false);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Préparer les données de réponse pour l'API
      Map<String, dynamic> responseData = {};

      // Grouper les réponses par type de champ
      for (final champ in _champs) {
        // Ignorer les champs non-interactifs (séparateurs et explications)
        if (champ.type == 'separator' || 
            champ.type == 'separator-title' || 
            champ.type == 'separatorTitre' || 
            champ.type == 'explication') {
          continue;
        }
        
        if (_responses.containsKey(champ.id)) {
          final champType = _mapChampTypeForAPI(champ.type);

          // Initialiser le type s'il n'existe pas encore
          if (!responseData.containsKey(champType)) {
            responseData[champType] = <String, dynamic>{};
          }

          // Traitement spécial pour les champs de type date
          dynamic responseValue = _responses[champ.id];
          if (champ.type == 'date' && responseValue != null) {
            // Si c'est déjà un DateTime, le convertir en ISO string
            if (responseValue is DateTime) {
              responseValue = responseValue.toIso8601String();
            } else if (responseValue is String) {
              // Si c'est une string, essayer de la parser en DateTime puis la convertir
              try {
                final parsedDate = DateTime.parse(responseValue);
                responseValue = parsedDate.toIso8601String();
              } catch (e) {
                // Si le parsing échoue, garder la valeur originale
                print('Erreur lors du parsing de la date: $e');
              }
            }
          }

          // Ajouter la réponse pour ce champ
          responseData[champType][champ.id!] = responseValue;
        }
      }

      print('Données de réponse préparées: $responseData');
      print('Réponses stockées: $_responses');

      // Soumettre les réponses via l'API
      final success = await _formulaireService.submitSondeResponse(
        formulaireId: _formulaire!.id!,
        sondeId: _sondeId,
        responses: responseData,
      );

      if (success) {
        // Afficher un message de succès et naviguer vers l'accueil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      'Réponse soumise avec succès pour la sonde $_sondeId'),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 4),
          ),
        );

        // Naviguer vers la page d'accueil après un court délai
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          context.go('/');
        }
      } else {
        throw Exception('Erreur lors de la soumission des réponses');
      }
    } catch (e) {
      setState(() {
        // Extraire un message d'erreur plus informatif si possible
        String errorMessage = 'Erreur lors de la soumission: $e';

        // Si l'erreur contient des informations sur un champ manquant
        if (e.toString().contains('champ') &&
            e.toString().contains('obligatoire')) {
          errorMessage =
              'Veuillez remplir tous les champs obligatoires avant de soumettre';
        }

        _errorMessage = errorMessage;
        _isSubmitting = false;
      });

      // Afficher aussi un SnackBar pour plus de visibilité
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(CupertinoIcons.exclamationmark_triangle,
                  color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(_errorMessage ?? 'Erreur de soumission'),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  double _getProgress() {
    if (_totalPages <= 1) return 1.0;
    return (_currentPage + 1) / _totalPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage != null
              ? _buildErrorView()
              : !_isAuthenticated && _isFormulairePrivate(_formulaire!)
                  ? _buildWaitingAuthView()
                  : _buildSondeFormView(),
    );
  }

  Widget _buildWaitingAuthView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Colors.white],
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [btnColor, btnColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  CupertinoIcons.lock_shield,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Formulaire Privé',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Ce formulaire "${_formulaire?.titre ?? 'Chargement...'}" nécessite une authentification.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAuthenticationDialog,
                  icon: const Icon(CupertinoIcons.person_badge_plus),
                  label: const Text('Se connecter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text(
                  'Retour à l\'accueil',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Colors.white],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [btnColor, btnColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chargement du formulaire...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Veuillez patienter quelques instants',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 40,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Une erreur s\'est produite',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loadFormData,
                  icon: const Icon(CupertinoIcons.refresh),
                  label: const Text('Réessayer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSondeFormView() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset:
                Offset(0, _slideAnimation.value * (1 - _fadeAnimation.value)),
            child: SafeArea(
              child: Column(
                children: [
                  _buildSondeHeader(),
                  Expanded(child: _buildFormContent()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSondeHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            btnColor,
            btnColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: btnColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.doc_text,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Formulaire Sonde',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formulaire?.titre ?? 'Chargement...',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_formulaire?.description != null) ...[
            const SizedBox(height: 16),
            Text(
              _formulaire!.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Étape ${_currentPage + 1} sur $_totalPages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${((_currentPage + 1) / _totalPages * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: constraints.maxWidth * _getProgress(),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  return _buildPageContent(index);
                },
              ),
            ),
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int pageIndex) {
    final champsForPage = _getChampsForPage(pageIndex);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...champsForPage.map((champ) => Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: FormResponseField(
                  champ: champ,
                  value: _responses[champ.id],
                  onChanged: (value) => _updateResponse(champ.id!, value),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousPage,
                icon: const Icon(CupertinoIcons.chevron_left),
                label: const Text('Précédent'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _nextPage,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(_currentPage == _totalPages - 1
                      ? CupertinoIcons.checkmark_alt
                      : CupertinoIcons.chevron_right),
              label: Text(
                  _currentPage == _totalPages - 1 ? 'Soumettre' : 'Suivant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SondeResponseSuccessPage extends StatelessWidget {
  final String formulaireTitle;
  final String sondeId;
  final Map<String, dynamic> responses;

  const SondeResponseSuccessPage({
    Key? key,
    required this.formulaireTitle,
    required this.sondeId,
    required this.responses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green, Colors.green.shade400],
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Réponses soumises avec succès !',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vos réponses au formulaire "$formulaireTitle" ont été enregistrées.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.info,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID de la sonde:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              sondeId,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(CupertinoIcons.home),
                    label: const Text('Retour à l\'accueil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
