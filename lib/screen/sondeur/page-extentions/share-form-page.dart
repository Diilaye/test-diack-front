import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:form/services/share-service.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:intl/intl.dart';

class ShareFormPage extends StatefulWidget {
  final FormulaireSondeurModel formulaire;

  const ShareFormPage({Key? key, required this.formulaire}) : super(key: key);

  @override
  State<ShareFormPage> createState() => _ShareFormPageState();
}

class _ShareFormPageState extends State<ShareFormPage>
    with TickerProviderStateMixin {
  final ShareService _shareService = ShareService();
  late TabController _tabController;

  // Contrôleurs pour les formulaires
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _passwordController = TextEditingController();

  // États
  bool _isLoading = false;
  String? _shareUrl;
  bool _requirePassword = false;
  bool _isPublic = true;
  bool _includePassword = false;
  DateTime? _expiryDate;
  DateTime? _scheduledDate;
  int? _maxUses;
  bool _recurring = false;
  String _recurringPattern = 'weekly';

  // Liste des emails
  List<String> _emailList = [];

  // Statistiques
  Map<String, dynamic>? _shareStats;
  List<Map<String, dynamic>> _activeLinks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadShareStats();
    _loadActiveLinks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadShareStats() async {
    final stats = await _shareService.getShareStats(widget.formulaire.id ?? '');
    if (mounted) {
      setState(() {
        _shareStats = stats;
      });
    }
  }

  Future<void> _loadActiveLinks() async {
    final links =
        await _shareService.getActiveShareLinks(widget.formulaire.id ?? '');
    if (mounted) {
      setState(() {
        _activeLinks = links;
      });
    }
  }

  Future<void> _generateShareLink() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _shareService.generateShareLink(
        widget.formulaire.id ?? '',
        requirePassword: _requirePassword,
        customPassword: _requirePassword ? _passwordController.text : null,
        expiryDate: _expiryDate,
        maxUses: _maxUses,
        isPublic: _isPublic,
      );

      if (result != null) {
        setState(() {
          _shareUrl = result['shareUrl'];
        });
        _showSuccessMessage('Lien de partage généré avec succès !');
      } else {
        _showErrorMessage('Erreur lors de la génération du lien');
      }
    } catch (e) {
      _showErrorMessage('Erreur: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _copyShareLink() async {
    if (_shareUrl != null) {
      await Clipboard.setData(ClipboardData(text: _shareUrl!));
      _showSuccessMessage('Lien copié dans le presse-papiers !');
    }
  }

  Future<void> _sendEmailShare() async {
    if (_emailList.isEmpty) {
      _showErrorMessage('Veuillez ajouter au moins une adresse email');
      return;
    }

    if (_shareUrl == null) {
      _showErrorMessage('Veuillez d\'abord générer un lien de partage');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _shareService.sendEmailShare(
        formulaireId: widget.formulaire.id ?? '',
        shareUrl: _shareUrl!,
        recipients: _emailList,
        subject: _subjectController.text.isNotEmpty
            ? _subjectController.text
            : 'Invitation à remplir un formulaire',
        message: _messageController.text.isNotEmpty
            ? _messageController.text
            : 'Bonjour,\n\nVous êtes invité(e) à remplir ce formulaire.',
        password: _requirePassword ? _passwordController.text : null,
        includePassword: _includePassword,
      );

      if (success) {
        _showSuccessMessage('Emails envoyés avec succès !');
        _emailList.clear();
        _emailController.clear();
      } else {
        _showErrorMessage('Erreur lors de l\'envoi des emails');
      }
    } catch (e) {
      _showErrorMessage('Erreur: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _scheduleEmailShare() async {
    if (_emailList.isEmpty) {
      _showErrorMessage('Veuillez ajouter au moins une adresse email');
      return;
    }

    if (_shareUrl == null) {
      _showErrorMessage('Veuillez d\'abord générer un lien de partage');
      return;
    }

    if (_scheduledDate == null) {
      _showErrorMessage('Veuillez sélectionner une date de programmation');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _shareService.scheduleEmailShare(
        formulaireId: widget.formulaire.id ?? '',
        shareUrl: _shareUrl!,
        recipients: _emailList,
        scheduledDate: _scheduledDate!,
        subject:
            _subjectController.text.isNotEmpty ? _subjectController.text : null,
        message:
            _messageController.text.isNotEmpty ? _messageController.text : null,
        password: _requirePassword ? _passwordController.text : null,
        includePassword: _includePassword,
        recurring: _recurring,
        recurringPattern: _recurring ? _recurringPattern : null,
      );

      if (success) {
        _showSuccessMessage('Email programmé avec succès !');
        _emailList.clear();
        _emailController.clear();
      } else {
        _showErrorMessage('Erreur lors de la programmation de l\'email');
      }
    } catch (e) {
      _showErrorMessage('Erreur: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addEmail() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && _isValidEmail(email)) {
      if (!_emailList.contains(email)) {
        setState(() {
          _emailList.add(email);
          _emailController.clear();
        });
      } else {
        _showErrorMessage('Cette adresse email est déjà ajoutée');
      }
    } else {
      _showErrorMessage('Veuillez entrer une adresse email valide');
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _emailList.remove(email);
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildGenerateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Générer un lien de partage',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Formulaire public
                  SwitchListTile(
                    title: const Text('Formulaire public'),
                    subtitle: const Text('Accessible à tous sans restriction'),
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),

                  // Mot de passe requis
                  SwitchListTile(
                    title: const Text('Mot de passe requis'),
                    subtitle:
                        const Text('Protéger l\'accès avec un mot de passe'),
                    value: _requirePassword,
                    onChanged: (value) {
                      setState(() {
                        _requirePassword = value;
                      });
                    },
                  ),

                  // Champ mot de passe
                  if (_requirePassword) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Mot de passe',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _passwordController.text =
                                  _shareService.generateSecurePassword();
                            });
                          },
                          child: const Text('Générer'),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Date d'expiration
                  ListTile(
                    title: const Text('Date d\'expiration'),
                    subtitle: Text(_expiryDate != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(_expiryDate!)
                        : 'Aucune expiration'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().add(const Duration(days: 7)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _expiryDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),

                  // Nombre maximal d'utilisations
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre maximal d\'utilisations (optionnel)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxUses = int.tryParse(value);
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Bouton générer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _generateShareLink,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Générer le lien'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lien généré
          if (_shareUrl != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lien de partage généré',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _shareUrl!,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: _copyShareLink,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Envoyer par email',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Ajouter des emails
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Adresse email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) => _addEmail(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addEmail,
                        child: const Text('Ajouter'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Liste des emails
                  if (_emailList.isNotEmpty) ...[
                    Text(
                      'Destinataires (${_emailList.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _emailList
                          .map((email) => Chip(
                                label: Text(email),
                                onDeleted: () => _removeEmail(email),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Sujet
                  TextField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Sujet (optionnel)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Message
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Message personnalisé (optionnel)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 16),

                  // Inclure le mot de passe
                  if (_requirePassword)
                    SwitchListTile(
                      title:
                          const Text('Inclure le mot de passe dans l\'email'),
                      subtitle: const Text(
                          'Le mot de passe sera envoyé dans l\'email'),
                      value: _includePassword,
                      onChanged: (value) {
                        setState(() {
                          _includePassword = value;
                        });
                      },
                    ),

                  const SizedBox(height: 24),

                  // Bouton envoyer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendEmailShare,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Envoyer maintenant'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Programmer l\'envoi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Date et heure de programmation
                  ListTile(
                    title: const Text('Date et heure de programmation'),
                    subtitle: Text(_scheduledDate != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(_scheduledDate!)
                        : 'Sélectionner une date'),
                    trailing: const Icon(Icons.schedule),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().add(const Duration(hours: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _scheduledDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Envoi récurrent
                  SwitchListTile(
                    title: const Text('Envoi récurrent'),
                    subtitle: const Text('Programmer des envois répétés'),
                    value: _recurring,
                    onChanged: (value) {
                      setState(() {
                        _recurring = value;
                      });
                    },
                  ),

                  // Fréquence de récurrence
                  if (_recurring) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _recurringPattern,
                      decoration: const InputDecoration(
                        labelText: 'Fréquence',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'daily', child: Text('Quotidien')),
                        DropdownMenuItem(
                            value: 'weekly', child: Text('Hebdomadaire')),
                        DropdownMenuItem(
                            value: 'monthly', child: Text('Mensuel')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _recurringPattern = value!;
                        });
                      },
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Bouton programmer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _scheduleEmailShare,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Programmer l\'envoi'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistiques
          if (_shareStats != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Statistiques de partage',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('Liens créés',
                              _shareStats!['totalLinks']?.toString() ?? '0'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard('Vues totales',
                              _shareStats!['totalViews']?.toString() ?? '0'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard('Emails envoyés',
                              _shareStats!['emailsSent']?.toString() ?? '0'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard('Réponses',
                              _shareStats!['responses']?.toString() ?? '0'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Liens actifs
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Liens actifs',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  if (_activeLinks.isEmpty)
                    const Text('Aucun lien actif')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _activeLinks.length,
                      itemBuilder: (context, index) {
                        final link = _activeLinks[index];
                        return Card(
                          child: ListTile(
                            title: Text('Lien ${index + 1}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Créé: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(link['createdAt']))}'),
                                if (link['expiryDate'] != null)
                                  Text(
                                      'Expire: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(link['expiryDate']))}'),
                                Text('Vues: ${link['views'] ?? 0}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final success = await _shareService
                                    .revokeShareLink(link['id']);
                                if (success) {
                                  _showSuccessMessage('Lien révoqué');
                                  _loadActiveLinks();
                                } else {
                                  _showErrorMessage(
                                      'Erreur lors de la révocation');
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          _buildModernAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 24),
                _buildTabContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey[800],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
        title: Text(
          'Partager le formulaire',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                btnColor.withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                CupertinoIcons.xmark,
                size: 20,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [btnColor, btnColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              CupertinoIcons.share,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.formulaire.titre ?? 'Formulaire',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Partagez ce formulaire avec votre audience',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildModernTabBar(),
          const SizedBox(height: 24),
          IndexedStack(
            index: _tabController.index,
            children: [
              _buildModernGenerateTab(),
              _buildModernEmailTab(),
              _buildModernScheduleTab(),
              _buildModernStatsTab(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() {});
        },
        indicator: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: [
          _buildModernTab(CupertinoIcons.link, 'Générer'),
          _buildModernTab(CupertinoIcons.mail, 'Email'),
          _buildModernTab(CupertinoIcons.clock, 'Programmer'),
          _buildModernTab(CupertinoIcons.chart_bar_alt_fill, 'Stats'),
        ],
      ),
    );
  }

  Widget _buildModernTab(IconData icon, String label) {
    return Tab(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    );
  }

  // Onglet Générer moderne
  Widget _buildModernGenerateTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de section
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: btnColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CupertinoIcons.link,
                    color: btnColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Générer un lien de partage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Créez un lien sécurisé pour partager votre formulaire',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Options de configuration
            _buildModernSectionCard(
              'Configuration du lien',
              [
                _buildModernSwitchTile(
                  'Lien public',
                  'Accessible à tous sans restriction',
                  _isPublic,
                  (value) => setState(() => _isPublic = value),
                  CupertinoIcons.globe,
                ),
                _buildModernSwitchTile(
                  'Protection par mot de passe',
                  'Nécessite un mot de passe pour accéder',
                  _requirePassword,
                  (value) => setState(() => _requirePassword = value),
                  CupertinoIcons.lock,
                ),
                if (_requirePassword) ...[
                  const SizedBox(height: 16),
                  _buildModernTextField(
                    controller: _passwordController,
                    label: 'Mot de passe personnalisé',
                    hint: 'Laissez vide pour générer automatiquement',
                    icon: CupertinoIcons.lock_fill,
                    isPassword: true,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Options avancées
            _buildModernSectionCard(
              'Options avancées',
              [
                _buildModernDatePicker(
                  'Date d\'expiration',
                  _expiryDate,
                  (date) => setState(() => _expiryDate = date),
                  CupertinoIcons.calendar,
                ),
                const SizedBox(height: 16),
                _buildModernNumberField(
                  'Nombre maximum d\'utilisations',
                  _maxUses,
                  (value) => setState(() => _maxUses = value),
                  CupertinoIcons.number,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Bouton de génération
            _buildModernActionButton(
              onPressed: _isLoading ? null : _generateShareLink,
              label: _isLoading ? 'Génération...' : 'Générer le lien',
              icon: _isLoading ? null : CupertinoIcons.arrow_right_circle_fill,
              isPrimary: true,
              isLoading: _isLoading,
            ),

            // Affichage du lien généré
            if (_shareUrl != null) ...[
              const SizedBox(height: 24),
              _buildGeneratedLinkCard(),
            ],
          ],
        ),
      ),
    );
  }

  // Onglet Email moderne
  Widget _buildModernEmailTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.mail,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Envoi par email',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Envoyez le lien directement par email',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Liste des emails
            _buildModernSectionCard(
              'Destinataires',
              [
                _buildEmailInputField(),
                if (_emailList.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildEmailList(),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Personnalisation de l'email
            _buildModernSectionCard(
              'Personnaliser l\'email',
              [
                _buildModernTextField(
                  controller: _subjectController,
                  label: 'Sujet de l\'email',
                  hint: 'Invitation à répondre au formulaire',
                  icon: CupertinoIcons.textformat,
                ),
                const SizedBox(height: 16),
                _buildModernTextField(
                  controller: _messageController,
                  label: 'Message personnalisé',
                  hint: 'Votre message d\'accompagnement...',
                  icon: CupertinoIcons.text_bubble,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                _buildModernSwitchTile(
                  'Inclure le mot de passe',
                  'Envoyer le mot de passe dans l\'email',
                  _includePassword,
                  (value) => setState(() => _includePassword = value),
                  CupertinoIcons.lock_fill,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Bouton d'envoi
            _buildModernActionButton(
              onPressed: _isLoading ? null : _sendEmailShare,
              label: _isLoading ? 'Envoi...' : 'Envoyer les emails',
              icon: _isLoading ? null : CupertinoIcons.paperplane_fill,
              isPrimary: true,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  // Onglet Programmer moderne
  Widget _buildModernScheduleTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.clock,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Programmer l\'envoi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Planifiez l\'envoi pour plus tard',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Configuration de la programmation
            _buildModernSectionCard(
              'Planification',
              [
                _buildModernDateTimePicker(
                  'Date et heure d\'envoi',
                  _scheduledDate,
                  (date) => setState(() => _scheduledDate = date),
                  CupertinoIcons.time,
                ),
                const SizedBox(height: 16),
                _buildModernSwitchTile(
                  'Envoi récurrent',
                  'Répéter l\'envoi périodiquement',
                  _recurring,
                  (value) => setState(() => _recurring = value),
                  CupertinoIcons.repeat,
                ),
                if (_recurring) ...[
                  const SizedBox(height: 16),
                  _buildRecurringPatternSelector(),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Destinataires pour programmation
            _buildModernSectionCard(
              'Destinataires',
              [
                _buildEmailInputField(),
                if (_emailList.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildEmailList(),
                ],
              ],
            ),

            const SizedBox(height: 32),

            // Bouton de programmation
            _buildModernActionButton(
              onPressed: _isLoading ? null : _scheduleEmailShare,
              label: _isLoading ? 'Programmation...' : 'Programmer l\'envoi',
              icon: _isLoading ? null : CupertinoIcons.clock_fill,
              isPrimary: true,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  // Onglet Statistiques moderne
  Widget _buildModernStatsTab() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    CupertinoIcons.chart_bar_alt_fill,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statistiques de partage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Suivez les performances de vos partages',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Cartes de statistiques
            if (_shareStats != null) ...[
              _buildModernStatsGrid(),
              const SizedBox(height: 24),
            ],

            // Liens actifs
            _buildModernSectionCard(
              'Liens actifs',
              [
                if (_activeLinks.isEmpty)
                  _buildEmptyState('Aucun lien actif', CupertinoIcons.link)
                else
                  ..._activeLinks.map((link) => _buildActiveLinkCard(link)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Méthodes helper pour les composants modernes
  Widget _buildModernSectionCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildModernSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? btnColor.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: value ? btnColor : Colors.grey[600],
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: btnColor,
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.grey[700]),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildModernDatePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onChanged,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        onChanged(date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedDate)
                        : 'Sélectionner une date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedDate != null
                          ? Colors.black87
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right,
                color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNumberField(
    String label,
    int? value,
    Function(int?) onChanged,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (val) => onChanged(int.tryParse(val)),
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Illimité',
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildModernActionButton({
    required VoidCallback? onPressed,
    required String label,
    IconData? icon,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? btnColor : Colors.grey[100],
          foregroundColor: isPrimary ? Colors.white : Colors.grey[800],
          elevation: isPrimary ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGeneratedLinkCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [btnColor.withOpacity(0.1), btnColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: btnColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.checkmark_circle_fill, color: btnColor),
              const SizedBox(width: 12),
              const Text(
                'Lien généré avec succès !',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    _shareUrl!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _copyShareLink,
                  icon: const Icon(CupertinoIcons.doc_on_clipboard),
                  tooltip: 'Copier',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInputField() {
    return Row(
      children: [
        Expanded(
          child: _buildModernTextField(
            controller: _emailController,
            label: 'Adresse email',
            hint: 'exemple@domaine.com',
            icon: CupertinoIcons.mail,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          width: 52,
          child: ElevatedButton(
            onPressed: _addEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(CupertinoIcons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destinataires ajoutés (${_emailList.length})',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _emailList.map((email) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: btnColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: btnColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 12,
                      color: btnColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _removeEmail(email),
                    child: Icon(
                      CupertinoIcons.xmark,
                      size: 14,
                      color: btnColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildModernDateTimePicker(
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onChanged,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selectedDate ?? DateTime.now()),
          );
          if (time != null) {
            final dateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            onChanged(dateTime);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedDate != null
                        ? DateFormat('dd/MM/yyyy HH:mm').format(selectedDate)
                        : 'Sélectionner date et heure',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedDate != null
                          ? Colors.black87
                          : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            Icon(CupertinoIcons.chevron_right,
                color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringPatternSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _recurringPattern,
        decoration: const InputDecoration(
          labelText: 'Fréquence',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        items: const [
          DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
          DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
          DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
        ],
        onChanged: (value) {
          setState(() {
            _recurringPattern = value!;
          });
        },
      ),
    );
  }

  Widget _buildModernStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildModernStatCard(
          'Liens générés',
          _shareStats!['totalLinks']?.toString() ?? '0',
          CupertinoIcons.link,
          Colors.blue,
        ),
        _buildModernStatCard(
          'Emails envoyés',
          _shareStats!['emailsSent']?.toString() ?? '0',
          CupertinoIcons.mail,
          Colors.green,
        ),
        _buildModernStatCard(
          'Vues totales',
          _shareStats!['totalViews']?.toString() ?? '0',
          CupertinoIcons.eye,
          Colors.orange,
        ),
        _buildModernStatCard(
          'Réponses',
          _shareStats!['responses']?.toString() ?? '0',
          CupertinoIcons.checkmark_circle,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildModernStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveLinkCard(Map<String, dynamic> link) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.link,
              color: Colors.green,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lien de partage',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Créé: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(link['createdAt']))}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (link['expiryDate'] != null)
                  Text(
                    'Expire: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(link['expiryDate']))}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                Text(
                  'Vues: ${link['views'] ?? 0}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final success = await _shareService.revokeShareLink(link['id']);
              if (success) {
                _showSuccessMessage('Lien révoqué');
                _loadActiveLinks();
              } else {
                _showErrorMessage('Erreur lors de la révocation');
              }
            },
            icon:
                const Icon(CupertinoIcons.delete, color: Colors.red, size: 18),
          ),
        ],
      ),
    );
  }

  // Méthodes utilitaires sont déjà définies plus haut
}
