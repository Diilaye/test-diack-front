import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FormTestRoutesPage extends StatelessWidget {
  const FormTestRoutesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test des routes de formulaires'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test des routes de formulaires',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Cette page permet de tester les différentes routes pour accéder aux formulaires.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Routes directes
            _buildRouteSection(
              context,
              'Routes d\'accès direct aux formulaires',
              'Accédez directement aux formulaires par leur ID',
              [
                {
                  'title': 'Formulaire de test (ID fictif)',
                  'description': 'Test avec un ID de formulaire fictif',
                  'route': '/form/test-form-123',
                  'color': Colors.blue,
                },
                {
                  'title': 'Formulaire existant (si disponible)',
                  'description': 'Remplacez l\'ID par un vrai ID de formulaire',
                  'route': '/form/REMPLACER-PAR-VRAI-ID',
                  'color': Colors.orange,
                },
              ],
            ),

            const SizedBox(height: 24),

            // Routes de partage
            _buildRouteSection(
              context,
              'Routes de partage de formulaires',
              'Accédez aux formulaires via des liens de partage',
              [
                {
                  'title': 'Formulaire public de test',
                  'description': 'Accès direct sans mot de passe',
                  'route': '/form/share/example-public-form',
                  'color': Colors.green,
                },
                {
                  'title': 'Formulaire privé de test',
                  'description': 'Nécessite un mot de passe (test123)',
                  'route': '/form/share/example-private-form',
                  'color': Colors.purple,
                },
                {
                  'title': 'Formulaire expiré de test',
                  'description': 'Lien expiré pour tester la gestion d\'erreur',
                  'route': '/form/share/example-expired-form',
                  'color': Colors.red,
                },
              ],
            ),

            const SizedBox(height: 24),

            // Section d'information
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Informations sur les routes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Route directe : /form/:id - Accès direct au formulaire par son ID\n'
                      '• Route de partage : /form/share/:shareId - Accès via lien de partage\n'
                      '• Les formulaires de test incluent des données fictives pour la démonstration\n'
                      '• Les vrais formulaires nécessitent des IDs valides de la base de données\n'
                      '• L\'aperçu depuis CreateFormSondeurScreen utilise la route directe /form/:id',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section aperçu depuis création
            _buildRouteSection(
              context,
              'Test de l\'aperçu depuis la création',
              'Testez la fonctionnalité d\'aperçu du formulaire',
              [
                {
                  'title': 'Créer un nouveau formulaire de test',
                  'description':
                      'Créer un formulaire et utiliser le bouton aperçu',
                  'route': '/formulaire/test-form-123/create',
                  'color': Colors.indigo,
                },
              ],
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/test-shared-forms'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Tests du partage de formulaires',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/apercu-test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Text(
                      'Info sur l\'aperçu',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection(
    BuildContext context,
    String title,
    String description,
    List<Map<String, dynamic>> routes,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ...routes.map((route) => _buildRouteButton(context, route)),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteButton(BuildContext context, Map<String, dynamic> route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => context.go(route['route']),
          style: ElevatedButton.styleFrom(
            backgroundColor: route['color'],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                route['description'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                route['route'],
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
