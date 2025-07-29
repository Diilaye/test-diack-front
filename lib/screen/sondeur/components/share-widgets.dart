import 'package:flutter/material.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/screen/sondeur/page-extentions/share-form-page.dart';

class ShareButton extends StatelessWidget {
  final FormulaireSondeurModel formulaire;
  final bool isIconOnly;
  final VoidCallback? onShareCompleted;

  const ShareButton({
    Key? key,
    required this.formulaire,
    this.isIconOnly = false,
    this.onShareCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isIconOnly
        ? IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _openSharePage(context),
            tooltip: 'Partager le formulaire',
          )
        : ElevatedButton.icon(
            onPressed: () => _openSharePage(context),
            icon: const Icon(Icons.share),
            label: const Text('Partager'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          );
  }

  void _openSharePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareFormPage(formulaire: formulaire),
      ),
    ).then((_) {
      // Appeler le callback si fourni
      if (onShareCompleted != null) {
        onShareCompleted!();
      }
    });
  }
}

class ShareQuickActions extends StatelessWidget {
  final FormulaireSondeurModel formulaire;
  final VoidCallback? onShareCompleted;

  const ShareQuickActions({
    Key? key,
    required this.formulaire,
    this.onShareCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _handleAction(context, value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'share_full',
          child: Row(
            children: [
              Icon(Icons.share),
              SizedBox(width: 8),
              Text('Partager le formulaire'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'copy_link',
          child: Row(
            children: [
              Icon(Icons.link),
              SizedBox(width: 8),
              Text('Copier le lien'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'send_email',
          child: Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 8),
              Text('Envoyer par email'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'schedule_email',
          child: Row(
            children: [
              Icon(Icons.schedule),
              SizedBox(width: 8),
              Text('Programmer l\'envoi'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'view_stats',
          child: Row(
            children: [
              Icon(Icons.analytics),
              SizedBox(width: 8),
              Text('Voir les statistiques'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'share_full':
        _openSharePage(context);
        break;
      case 'copy_link':
        _showQuickShareDialog(context, 'copy');
        break;
      case 'send_email':
        _showQuickShareDialog(context, 'email');
        break;
      case 'schedule_email':
        _showQuickShareDialog(context, 'schedule');
        break;
      case 'view_stats':
        _showQuickShareDialog(context, 'stats');
        break;
    }
  }

  void _openSharePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareFormPage(formulaire: formulaire),
      ),
    ).then((_) {
      if (onShareCompleted != null) {
        onShareCompleted!();
      }
    });
  }

  void _showQuickShareDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getDialogTitle(action)),
        content: Text(_getDialogContent(action)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openSharePage(context);
            },
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  String _getDialogTitle(String action) {
    switch (action) {
      case 'copy':
        return 'Copier le lien';
      case 'email':
        return 'Envoyer par email';
      case 'schedule':
        return 'Programmer l\'envoi';
      case 'stats':
        return 'Statistiques de partage';
      default:
        return 'Partager';
    }
  }

  String _getDialogContent(String action) {
    switch (action) {
      case 'copy':
        return 'Voulez-vous générer un lien de partage pour ce formulaire ?';
      case 'email':
        return 'Voulez-vous envoyer ce formulaire par email ?';
      case 'schedule':
        return 'Voulez-vous programmer l\'envoi de ce formulaire ?';
      case 'stats':
        return 'Voulez-vous voir les statistiques de partage de ce formulaire ?';
      default:
        return 'Voulez-vous partager ce formulaire ?';
    }
  }
}

class ShareStatusIndicator extends StatelessWidget {
  final FormulaireSondeurModel formulaire;
  final bool isShared;
  final int? shareCount;
  final int? viewCount;

  const ShareStatusIndicator({
    Key? key,
    required this.formulaire,
    this.isShared = false,
    this.shareCount,
    this.viewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isShared) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.share,
            size: 16,
            color: Colors.blue[700],
          ),
          const SizedBox(width: 4),
          Text(
            'Partagé',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (shareCount != null && shareCount! > 0) ...[
            const SizedBox(width: 4),
            Text(
              '($shareCount)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ShareStatsPreview extends StatelessWidget {
  final FormulaireSondeurModel formulaire;
  final Map<String, dynamic>? stats;

  const ShareStatsPreview({
    Key? key,
    required this.formulaire,
    this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques de partage',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Liens',
                  stats!['totalLinks']?.toString() ?? '0',
                  Icons.link,
                ),
                _buildStatItem(
                  'Vues',
                  stats!['totalViews']?.toString() ?? '0',
                  Icons.visibility,
                ),
                _buildStatItem(
                  'Emails',
                  stats!['emailsSent']?.toString() ?? '0',
                  Icons.email,
                ),
                _buildStatItem(
                  'Réponses',
                  stats!['totalResponses']?.toString() ?? '0',
                  Icons.reply,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
