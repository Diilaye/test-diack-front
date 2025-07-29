import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApercuTestPage extends StatelessWidget {
  const ApercuTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de la fonctionnalité d\'aperçu'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          color: Colors.blue[600],
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Fonctionnalité d\'aperçu implémentée',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Le bouton "Aperçu" dans l\'écran de création de formulaire fonctionne maintenant ! '
                      'Il redirige vers la page de réponse au formulaire en utilisant la route /form/:id.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Fonctionnalité section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comment ça fonctionne :',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.edit,
                      title: '1. Création du formulaire',
                      description:
                          'Dans CreateFormSondeurScreen, créez ou modifiez votre formulaire',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.visibility,
                      title: '2. Clic sur Aperçu',
                      description:
                          'Cliquez sur le bouton "Aperçu" dans la barre d\'actions en haut',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.launch,
                      title: '3. Redirection automatique',
                      description:
                          'Redirection vers /form/:id pour voir le formulaire en mode réponse',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.quiz,
                      title: '4. Aperçu complet',
                      description:
                          'Testez votre formulaire comme le feraient vos utilisateurs',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Code implementation section
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.code,
                          color: Colors.green[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Implémentation technique',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''_buildActionButton(
  icon: CupertinoIcons.eye,
  tooltip: 'Aperçu',
  isPrimary: false,
  onTap: () {
    // Naviguer vers l'aperçu du formulaire
    context.go('/form/\${formulaireSondeur.formulaireSondeurModel!.id!}');
  },
),''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Test buttons section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tester l\'aperçu :',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pour tester cette fonctionnalité avec un vrai formulaire, vous devez :',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    _buildTestStep(
                        '1. Avoir un formulaire existant dans votre base de données'),
                    _buildTestStep(
                        '2. Aller sur la page de création : /formulaire/ID_REEL/create'),
                    _buildTestStep(
                        '3. Cliquer sur le bouton "Aperçu" en haut à droite'),
                    _buildTestStep(
                        '4. Vous serez redirigé vers /form/ID_REEL pour voir l\'aperçu'),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue[600]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Pour les tests avec des IDs fictifs, utilisez la page de test des routes.',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/test-form-routes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text('Tester les routes de formulaires'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text('Retour à l\'accueil'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue[600],
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestStep(String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
