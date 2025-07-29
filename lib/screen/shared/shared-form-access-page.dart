import 'package:flutter/material.dart';
import 'package:form/services/share-service.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/screen/shared/form-response-page.dart';

class SharedFormAccessPage extends StatefulWidget {
  final String shareId;

  const SharedFormAccessPage({Key? key, required this.shareId})
      : super(key: key);

  @override
  State<SharedFormAccessPage> createState() => _SharedFormAccessPageState();
}

class _SharedFormAccessPageState extends State<SharedFormAccessPage> {
  final ShareService _shareService = ShareService();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = true;
  bool _requirePassword = false;
  bool _isValidating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadShareDetails();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadShareDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Gérer les cas de test avec des données fictives
      if (_isTestShareId(widget.shareId)) {
        _handleTestShare();
        return;
      }

      final details = await _shareService.getShareDetails(widget.shareId);

      if (details != null) {
        setState(() {
          _requirePassword = details['settings']['requirePassword'] ?? false;
        });

        // Si pas de mot de passe requis, accéder directement au formulaire
        if (!_requirePassword) {
          _accessForm();
        }
      } else {
        setState(() {
          _errorMessage = 'Lien de partage introuvable ou expiré';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isTestShareId(String shareId) {
    return shareId.startsWith('example-');
  }

  void _handleTestShare() {
    setState(() {
      _isLoading = false;
    });

    // Simuler différents comportements selon l'ID de test
    if (widget.shareId.contains('public')) {
      // Formulaire public - accès direct
      _requirePassword = false;
      _accessTestForm();
    } else if (widget.shareId.contains('private')) {
      // Formulaire privé - nécessite un mot de passe
      _requirePassword = true;
    } else if (widget.shareId.contains('expired')) {
      // Formulaire expiré
      setState(() {
        _errorMessage =
            'Ce lien de partage a expiré et n\'est plus accessible.';
      });
    }
  }

  void _accessTestForm() {
    // Créer un formulaire de test
    final testFormulaire = FormulaireSondeurModel(
      id: 'test-form-123',
      titre: 'Formulaire de test - Satisfaction client',
      description:
          'Ce formulaire de test permet de valider le système de réponse aux formulaires partagés. Merci de répondre aux questions suivantes.',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FormResponsePage(
          shareId: widget.shareId,
          formulaire: testFormulaire,
        ),
      ),
    );
  }

  Future<void> _validatePassword() async {
    if (_passwordController.text.isEmpty) {
      _showError('Veuillez entrer le mot de passe');
      return;
    }

    setState(() {
      _isValidating = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _shareService.validatePasswordAccess(
        widget.shareId,
        _passwordController.text,
      );

      if (isValid) {
        _accessForm();
      } else {
        _showError('Mot de passe incorrect');
      }
    } catch (e) {
      _showError('Erreur lors de la validation: $e');
    } finally {
      setState(() {
        _isValidating = false;
      });
    }
  }

  Future<void> _accessForm() async {
    try {
      // Ici, on pourrait naviguer vers la page de réponse au formulaire
      // En attendant, on affiche juste le contenu
      final accessResult = await _shareService.getShareDetails(widget.shareId);

      if (accessResult != null && accessResult['formulaireId'] != null) {
        // Naviguer vers la page de formulaire
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FormResponsePage(
              formulaire:
                  FormulaireSondeurModel.fromJson(accessResult['formulaireId']),
              shareId: widget.shareId,
            ),
          ),
        );
      }
    } catch (e) {
      _showError('Erreur lors de l\'accès au formulaire: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accès au formulaire'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : _requirePassword
                  ? _buildPasswordView()
                  : _buildFormView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur d\'accès',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadShareDetails,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Colors.blue[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Formulaire protégé',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ce formulaire nécessite un mot de passe pour y accéder',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  onSubmitted: (_) => _validatePassword(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isValidating ? null : _validatePassword,
                    child: _isValidating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Accéder'),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Chargement du formulaire...'),
        ],
      ),
    );
  }
}

class FormResponsePage extends StatefulWidget {
  final FormulaireSondeurModel formulaire;
  final String shareId;

  const FormResponsePage({
    Key? key,
    required this.formulaire,
    required this.shareId,
  }) : super(key: key);

  @override
  State<FormResponsePage> createState() => _FormResponsePageState();
}

class _FormResponsePageState extends State<FormResponsePage> {
  // Variables pour gérer les réponses
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formulaire.titre ?? 'Formulaire'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête du formulaire
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.formulaire.titre ?? 'Formulaire',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (widget.formulaire.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.formulaire.description!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Contenu du formulaire
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Répondre au formulaire',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Ici, on afficherait les champs du formulaire
                    // Pour l'instant, on affiche un message informatif
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue),
                          SizedBox(height: 8),
                          Text(
                            'L\'interface de réponse au formulaire sera implémentée ici.\n'
                            'Elle affichera tous les champs du formulaire selon leur type.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bouton de soumission
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitResponse,
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Envoyer mes réponses'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitResponse() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Ici, on soumettrait les réponses via l'API
      // await _responseService.submitResponse(widget.shareId, _responses);

      // Simulation d'une soumission
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réponses envoyées avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        // Naviguer vers une page de confirmation
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResponseConfirmationPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class ResponseConfirmationPage extends StatelessWidget {
  const ResponseConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Colors.green[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Merci !',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              const Text(
                'Vos réponses ont été envoyées avec succès.\n'
                'Nous vous remercions pour votre participation.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
