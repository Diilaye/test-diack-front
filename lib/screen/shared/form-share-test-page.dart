import 'package:flutter/material.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';

class FormShareTestPage extends StatelessWidget {
  const FormShareTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gris,
      appBar: AppBar(
        title: const Text('Test des formulaires partagés'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test des formulaires partagés',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: vert,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Testez l\'accès aux formulaires via les liens de partage :',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),

              // Exemple de formulaire public
              _buildTestCard(
                context,
                title: 'Formulaire public (sans mot de passe)',
                description:
                    'Accès direct au formulaire, aucune authentification requise',
                shareId: 'example-public-form-123',
                icon: Icons.public,
                color: Colors.green,
              ),

              const SizedBox(height: 16),

              // Exemple de formulaire privé
              _buildTestCard(
                context,
                title: 'Formulaire privé (avec mot de passe)',
                description:
                    'Nécessite un mot de passe pour accéder au formulaire',
                shareId: 'example-private-form-456',
                icon: Icons.lock,
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              // Exemple de formulaire expiré
              _buildTestCard(
                context,
                title: 'Formulaire expiré',
                description: 'Lien qui a dépassé sa date d\'expiration',
                shareId: 'example-expired-form-789',
                icon: Icons.schedule,
                color: Colors.red,
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note pour le développement',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ces exemples utilisent des IDs de partage fictifs. Dans un environnement réel, ces IDs seraient générés par l\'API de partage.',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(
    BuildContext context, {
    required String title,
    required String description,
    required String shareId,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Share ID: $shareId',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              context.go('/form/share/$shareId');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tester'),
          ),
        ],
      ),
    );
  }
}
