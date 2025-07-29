import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/services/share-service.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:form/blocs/folder-bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareFormSondeurScreen extends StatefulWidget {
  const ShareFormSondeurScreen({super.key});

  @override
  State<ShareFormSondeurScreen> createState() => _ShareFormSondeurScreenState();
}

class _ShareFormSondeurScreenState extends State<ShareFormSondeurScreen> {
  final ShareService _shareService = ShareService();

  int selectedTabIndex = 0;
  bool _isLoading = false;
  String? _shareUrl;
  String? _errorMessage;
  String? _generatedPassword; // Nouveau : stocker le mot de passe généré

  // Configuration du lien
  bool _isPublic = true;
  bool _requirePassword = false;
  // Supprimé : _passwordController car plus de saisie manuelle
  DateTime? _expiryDate;
  int? _maxUses;

  // Email - nouvelles variables pour l'envoi automatique
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sendPasswordByEmail = false; // Nouveau : option d'envoi par email

  // Variables pour l'envoi par email multiple
  final _recipientEmailController = TextEditingController();
  final List<String> _recipientEmails = [];
  bool _includeCurrentUserEmail = false; // Inclure l'email du sondeur
  bool _isEmailLoading = false;

  // Programmation et statistiques - à implémenter plus tard

  final List<Map<String, dynamic>> tabs = [
    {
      'title': 'Lien de partage',
      'icon': CupertinoIcons.link,
      'description': 'Créer et configurer un lien de partage'
    },
    {
      'title': 'Envoi par email',
      'icon': CupertinoIcons.mail,
      'description': 'Envoyer le formulaire par email'
    },
    {
      'title': 'Programmation',
      'icon': CupertinoIcons.clock,
      'description': 'Programmer l\'envoi automatique'
    },
    {
      'title': 'Statistiques',
      'icon': CupertinoIcons.chart_bar_alt_fill,
      'description': 'Voir les performances de partage'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadShareStats();
    _loadActiveLinks();
  }

  @override
  void dispose() {
    // Supprimé : _passwordController.dispose(); car plus de saisie manuelle
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _recipientEmailController.dispose();
    super.dispose();
  }

  Future<void> _loadShareStats() async {
    // final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context, listen: false);
    // final stats = await _shareService.getShareStats(formulaireSondeur.formulaireSondeurModel?.id ?? '');
    // TODO: implémenter les statistiques
  }

  Future<void> _loadActiveLinks() async {
    // final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context, listen: false);
    // final links = await _shareService.getActiveShareLinks(formulaireSondeur.formulaireSondeurModel?.id ?? '');
    // TODO: implémenter les liens actifs
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildModernHeader(context, formulaireSondeur, folderBloc),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, FolderBloc folderBloc) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF8FAFC),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            _buildBreadcrumb(context, formulaireSondeur, folderBloc),
            const Spacer(),
            _buildHeaderActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, FolderBloc folderBloc) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (formulaireSondeur.formulaireSondeurModel!.folderForm ==
                  null) {
                folderBloc.setFolder(null);
                context.go("/");
              } else {
                FolderModel f = folderBloc.folders
                    .where((e) =>
                        e.id! ==
                        formulaireSondeur
                            .formulaireSondeurModel!.folderForm!.id!)
                    .first;
                folderBloc.setFolder(f);
                context.go("/");
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(CupertinoIcons.folder,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    formulaireSondeur.formulaireSondeurModel!.folderForm == null
                        ? "Mes formulaires"
                        : formulaireSondeur
                            .formulaireSondeurModel!.folderForm!.titre!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(CupertinoIcons.chevron_right,
              color: Colors.grey.shade400, size: 16),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go(
                '/formulaire/${formulaireSondeur.formulaireSondeurModel!.id!}'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                formulaireSondeur.formulaireSondeurModel!.titre!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(CupertinoIcons.chevron_right,
              color: Colors.grey.shade400, size: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [btnColor, btnColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: btnColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Partager',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Rubik',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(BuildContext context) {
    return Row(
      children: [
        _buildHeaderTab('Construire', CupertinoIcons.building_2_fill, false,
            onTap: () => context.go(
                '/formulaire/${Provider.of<FormulaireSondeurBloc>(context, listen: false).formulaireSondeurModel!.id!}')),
        const SizedBox(width: 8),
        _buildHeaderTab('Paramètres', CupertinoIcons.settings, false,
            onTap: () => context.go(
                '/formulaire/${Provider.of<FormulaireSondeurBloc>(context, listen: false).formulaireSondeurModel!.id!}/params')),
        const SizedBox(width: 8),
        _buildHeaderTab('Partager', CupertinoIcons.share, true),
        const SizedBox(width: 8),
        _buildHeaderTab('Résultats', CupertinoIcons.chart_bar_alt_fill, false),
        const SizedBox(width: 32),
        _buildActionButton(
          icon: CupertinoIcons.xmark,
          tooltip: 'Fermer',
          isPrimary: false,
          onTap: () => context.go(
              '/formulaire/${Provider.of<FormulaireSondeurBloc>(context, listen: false).formulaireSondeurModel!.id!}'),
        ),
      ],
    );
  }

  Widget _buildHeaderTab(String label, IconData icon, bool isActive,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? btnColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border(bottom: BorderSide(color: btnColor, width: 3))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: isActive ? btnColor : Colors.grey.shade600, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? btnColor : Colors.grey.shade600,
                fontFamily: 'Rubik',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? label,
    required String tooltip,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 20 : 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [btnColor, btnColor.withOpacity(0.8)])
                  : null,
              color: isPrimary ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isPrimary
                      ? btnColor.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isPrimary ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: !isPrimary
                  ? Border.all(color: Colors.grey.shade300, width: 1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isPrimary ? Colors.white : Colors.grey.shade700,
                  size: 16,
                ),
                if (label != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = selectedTabIndex == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? btnColor.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: isSelected
                              ? Border.all(color: btnColor, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? btnColor
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                tab['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tab['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? btnColor
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tab['description'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                CupertinoIcons.chevron_right,
                                color: btnColor,
                                size: 16,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [btnColor, btnColor.withOpacity(0.8)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(CupertinoIcons.share, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Partage de formulaire",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Partagez votre formulaire avec votre audience",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: IndexedStack(
        index: selectedTabIndex,
        children: [
          _buildLinkTab(),
          _buildEmailTab(),
          _buildScheduleTab(),
          _buildStatsTab(),
        ],
      ),
    );
  }

  Widget _buildLinkTab() {
    return SingleChildScrollView(
      child: Container(
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
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Générer un lien de partage',
                'Créez un lien sécurisé pour partager votre formulaire',
                CupertinoIcons.link,
              ),
              const SizedBox(height: 32),
              _buildConfigSection(),
              const SizedBox(height: 32),
              _buildGenerateButton(),
              if (_shareUrl != null) ...[
                const SizedBox(height: 32),
                _buildGeneratedLink(),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                _buildErrorMessage(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTab() {
    return SingleChildScrollView(
      child: Container(
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
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Envoi par email',
                'Envoyez le lien de partage directement par email',
                CupertinoIcons.mail,
              ),
              const SizedBox(height: 32),
              _buildEmailSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      child: Container(
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
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Programmer l\'envoi',
                'Planifiez l\'envoi automatique de votre formulaire',
                CupertinoIcons.clock,
              ),
              const SizedBox(height: 32),
              _buildScheduleSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      child: Container(
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
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Statistiques de partage',
                'Suivez les performances de vos partages',
                CupertinoIcons.chart_bar_alt_fill,
              ),
              const SizedBox(height: 32),
              _buildStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: btnColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: btnColor, size: 24),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSwitchCard(
          'Lien public',
          'Accessible à tous sans restriction',
          _isPublic,
          (value) {
            setState(() {
              _isPublic = value;
              // Si le formulaire devient public, pas besoin de mot de passe
              if (value) {
                _requirePassword = false;
                _sendPasswordByEmail = false;
              }
            });
          },
          CupertinoIcons.globe,
        ),

        // Afficher l'option de mot de passe seulement si le formulaire n'est pas public
        if (!_isPublic) ...[
          const SizedBox(height: 16),
          _buildSwitchCard(
            'Protection par mot de passe',
            'Un mot de passe sera généré automatiquement',
            _requirePassword,
            (value) {
              setState(() {
                _requirePassword = value;
                // Si on active la protection, activer l'envoi par email
                if (value) {
                  _sendPasswordByEmail = true;
                } else {
                  _sendPasswordByEmail = false;
                }
              });
            },
            CupertinoIcons.lock,
          ),

          // Option d'envoi par email si mot de passe activé
          if (_requirePassword) ...[
            const SizedBox(height: 16),
            _buildEmailPasswordCard(),
          ],
        ],

        const SizedBox(height: 16),
        _buildDateField(),
        const SizedBox(height: 16),
        _buildNumberField(),
      ],
    );
  }

  // Nouveau widget pour la configuration de l'envoi par email
  Widget _buildEmailPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(CupertinoIcons.mail,
                    color: Colors.blue[600], size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Envoi automatique par email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Le mot de passe sera généré automatiquement et envoyé par email',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              CupertinoSwitch(
                value: _sendPasswordByEmail,
                onChanged: (value) =>
                    setState(() => _sendPasswordByEmail = value),
                activeColor: Colors.blue[600],
              ),
            ],
          ),
          if (_sendPasswordByEmail) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Email du destinataire',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'email@exemple.com',
                prefixIcon: const Icon(CupertinoIcons.mail),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwitchCard(String title, String subtitle, bool value,
      Function(bool) onChanged, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: value ? btnColor.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: value ? btnColor : Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildDateField() {
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
          const Text(
            'Date d\'expiration (optionnel)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate:
                    _expiryDate ?? DateTime.now().add(const Duration(days: 7)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                setState(() => _expiryDate = date);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _expiryDate != null
                          ? DateFormat('dd/MM/yyyy').format(_expiryDate!)
                          : 'Sélectionner une date',
                      style: TextStyle(
                        fontSize: 16,
                        color: _expiryDate != null
                            ? Colors.black87
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_down, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField() {
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
          const Text(
            'Nombre maximum d\'utilisations (optionnel)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => _maxUses = int.tryParse(value),
            decoration: InputDecoration(
              hintText: 'Illimité',
              prefixIcon: const Icon(CupertinoIcons.number),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _generateShareLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.arrow_right_circle_fill, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Générer le lien de partage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGeneratedLink() {
    return Container(
      padding: const EdgeInsets.all(24),
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
              Icon(CupertinoIcons.checkmark_circle_fill,
                  color: btnColor, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Lien généré avec succès !',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Affichage du lien
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
                  tooltip: 'Copier le lien',
                ),
              ],
            ),
          ),

          // Affichage du mot de passe généré s'il existe
          if (_generatedPassword != null && !_isPublic) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(CupertinoIcons.lock_fill,
                          color: Colors.amber[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Mot de passe généré',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[300]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            _generatedPassword!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _copyPassword(),
                          icon: const Icon(CupertinoIcons.doc_on_clipboard),
                          tooltip: 'Copier le mot de passe',
                        ),
                      ],
                    ),
                  ),
                  if (_sendPasswordByEmail &&
                      _emailController.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '✅ Mot de passe envoyé à ${_emailController.text}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.red[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section de génération du lien si pas encore fait
        if (_shareUrl == null) ...[
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.info_circle,
                    color: Colors.orange[600], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lien de partage requis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Vous devez d\'abord générer un lien de partage dans l\'onglet "Lien de partage"',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Configuration des destinataires
        _buildRecipientsSection(),
        const SizedBox(height: 24),

        // Configuration du message
        _buildMessageSection(),
        const SizedBox(height: 32),

        // Bouton d'envoi
        _buildSendEmailButton(),

        // Affichage du résultat d'envoi
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          _buildErrorMessage(),
        ],
      ],
    );
  }

  Widget _buildScheduleSection() {
    return const Center(
      child: Text(
        'Section Programmation - À implémenter',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildStatsSection() {
    return const Center(
      child: Text(
        'Section Statistiques - À implémenter',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  // Section des destinataires pour l'envoi d'emails
  Widget _buildRecipientsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: btnColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(CupertinoIcons.person_2_fill,
                    color: btnColor, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destinataires',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ajoutez les emails des destinataires',
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
          const SizedBox(height: 20),

          // Option pour inclure l'email du sondeur
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.person_circle,
                    color: Colors.blue[600], size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Inclure mon email (sondeur)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                CupertinoSwitch(
                  value: _includeCurrentUserEmail,
                  onChanged: (value) =>
                      setState(() => _includeCurrentUserEmail = value),
                  activeColor: Colors.blue[600],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Ajout d'emails
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _recipientEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Ajouter un email (ex: user@exemple.com)',
                    prefixIcon: const Icon(CupertinoIcons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onSubmitted: _addRecipientEmail,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () =>
                    _addRecipientEmail(_recipientEmailController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.add, size: 16),
                    SizedBox(width: 8),
                    Text('Ajouter'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Liste des emails ajoutés
          if (_recipientEmails.isNotEmpty) ...[
            const Text(
              'Destinataires ajoutés:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recipientEmails
                  .map((email) => _buildEmailChip(email))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Widget pour afficher un email sous forme de chip
  Widget _buildEmailChip(String email) {
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
          Icon(CupertinoIcons.mail, color: btnColor, size: 16),
          const SizedBox(width: 8),
          Text(
            email,
            style: TextStyle(
              fontSize: 14,
              color: btnColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _removeRecipientEmail(email),
            child: Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Colors.red[600],
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Section du message à envoyer
  Widget _buildMessageSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: btnColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(CupertinoIcons.chat_bubble_text,
                    color: btnColor, size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message personnalisé',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Personnalisez le message d\'invitation',
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
          const SizedBox(height: 20),

          // Sujet de l'email
          const Text(
            'Sujet de l\'email',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Invitation à remplir un formulaire',
              prefixIcon: const Icon(CupertinoIcons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Message de l'email
          const Text(
            'Message personnalisé',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'Bonjour,\n\nVous êtes invité(e) à remplir ce formulaire...',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 60),
                child: Icon(CupertinoIcons.text_alignleft),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Bouton d'envoi des emails
  Widget _buildSendEmailButton() {
    final bool canSend = _shareUrl != null &&
        (_recipientEmails.isNotEmpty || _includeCurrentUserEmail);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            (canSend && !_isEmailLoading) ? _sendEmailToRecipients : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isEmailLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.paperplane, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    canSend
                        ? 'Envoyer le formulaire par email'
                        : _shareUrl == null
                            ? 'Générez d\'abord un lien'
                            : 'Ajoutez au moins un destinataire',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _generateShareLink() async {
    final formulaireSondeur =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);

    final formulaireId = formulaireSondeur.formulaireSondeurModel?.id ?? '';
    print('DEBUG: FormulaireSondeur ID: $formulaireId');

    if (formulaireId.isEmpty) {
      setState(() {
        _errorMessage = 'Aucun formulaire sélectionné';
      });
      return;
    }

    // Validation : si pas public et mot de passe requis avec envoi email, vérifier l'email
    if (!_isPublic &&
        _requirePassword &&
        _sendPasswordByEmail &&
        _emailController.text.isEmpty) {
      setState(() {
        _errorMessage =
            'Veuillez saisir un email pour recevoir le mot de passe';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _generatedPassword = null; // Reset du mot de passe précédent
    });

    try {
      print('DEBUG: Appel du service avec les paramètres:');
      print('  - formulaireId: $formulaireId');
      print('  - requirePassword: $_requirePassword');
      print('  - sendPasswordByEmail: $_sendPasswordByEmail');
      print('  - recipientEmail: ${_emailController.text}');
      print('  - expiryDate: $_expiryDate');
      print('  - maxUses: $_maxUses');
      print('  - isPublic: $_isPublic');

      final result = await _shareService.generateShareLink(
        formulaireId,
        requirePassword: _requirePassword,
        // Plus de customPassword - sera généré automatiquement côté backend
        expiryDate: _expiryDate,
        maxUses: _maxUses,
        isPublic: _isPublic,
        // Nouveaux paramètres pour l'envoi automatique
        sendPasswordByEmail: _sendPasswordByEmail,
        recipientEmail: _sendPasswordByEmail ? _emailController.text : null,
      );

      print('DEBUG: Résultat du service: $result');

      if (result != null) {
        setState(() {
          _shareUrl = result['shareUrl'];
          // Récupérer le mot de passe généré s'il existe
          _generatedPassword = result['generatedPassword'];
        });

        // DEBUG: Afficher l'URL générée
        print('DEBUG: URL générée par le backend: ${result['shareUrl']}');

        _showSuccessMessage('Lien de partage généré avec succès !');
      } else {
        setState(() {
          _errorMessage =
              'Erreur lors de la génération du lien - Aucun résultat retourné';
        });
      }
    } catch (e) {
      print('DEBUG: Erreur capturée: $e');
      setState(() {
        _errorMessage = 'Erreur: $e';
      });
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

  Future<void> _copyPassword() async {
    if (_generatedPassword != null) {
      await Clipboard.setData(ClipboardData(text: _generatedPassword!));
      _showSuccessMessage('Mot de passe copié dans le presse-papiers !');
    }
  }

  // Ajouter un email à la liste des destinataires
  void _addRecipientEmail(String email) {
    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty) return;

    // Validation simple de l'email
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(cleanEmail)) {
      _showErrorMessage('Format d\'email invalide');
      return;
    }

    // Vérifier si l'email n'est pas déjà dans la liste
    if (_recipientEmails.contains(cleanEmail)) {
      _showErrorMessage('Cet email est déjà dans la liste');
      return;
    }

    setState(() {
      _recipientEmails.add(cleanEmail);
      _recipientEmailController.clear();
    });
  }

  // Supprimer un email de la liste des destinataires
  void _removeRecipientEmail(String email) {
    setState(() {
      _recipientEmails.remove(email);
    });
  }

  // Envoyer le formulaire par email à tous les destinataires
  Future<void> _sendEmailToRecipients() async {
    if (_shareUrl == null) {
      _showErrorMessage('Aucun lien de partage généré');
      return;
    }

    // Construire la liste complète des destinataires
    List<String> allRecipients = List.from(_recipientEmails);

    // Ajouter l'email du sondeur si demandé
    if (_includeCurrentUserEmail) {
      final currentUserEmail = await _getCurrentUserEmail();
      if (currentUserEmail != null && currentUserEmail.isNotEmpty) {
        allRecipients.add(currentUserEmail);
      }
    }

    if (allRecipients.isEmpty) {
      _showErrorMessage('Aucun destinataire sélectionné');
      return;
    }

    setState(() {
      _isEmailLoading = true;
      _errorMessage = null;
    });

    try {
      final subject = _subjectController.text.trim().isNotEmpty
          ? _subjectController.text.trim()
          : 'Invitation à remplir un formulaire';

      final message = _messageController.text.trim().isNotEmpty
          ? _messageController.text.trim()
          : 'Bonjour,\n\nVous êtes invité(e) à remplir ce formulaire.';

      print('DEBUG Email: Envoi à ${allRecipients.length} destinataires');
      print('DEBUG Email: Destinataires: $allRecipients');
      print('DEBUG Email: Formulaire public: $_isPublic');
      print('DEBUG Email: URL de partage: $_shareUrl');
      print('DEBUG Email: Type URL: ${_shareUrl.runtimeType}');
      print('DEBUG Email: Longueur URL: ${_shareUrl?.length}');
      int successCount = 0;
      int totalCount = allRecipients.length;

      // Logique selon le type de formulaire
      if (_isPublic) {
        // Formulaire public : un seul envoi pour tous les destinataires, pas de mot de passe
        print('DEBUG Email: Envoi groupé pour formulaire public');

        final success = await _shareService.sendEmailShare(
          formulaireId:
              Provider.of<FormulaireSondeurBloc>(context, listen: false)
                      .formulaireSondeurModel
                      ?.id ??
                  '',
          shareUrl: _shareUrl!,
          recipients: allRecipients,
          subject: subject,
          message: message,
          password: null, // Pas de mot de passe pour formulaire public
          includePassword: false, // Pas d'inclusion de mot de passe
        );

        if (success) {
          successCount = totalCount;
          _showSuccessMessage(
              'Emails envoyés avec succès à ${allRecipients.length} destinataire(s) !');
        } else {
          _showErrorMessage('Erreur lors de l\'envoi des emails');
        }
      } else {
        // Formulaire privé : envoi individuel avec mot de passe unique pour chaque destinataire
        print('DEBUG Email: Envoi individuel pour formulaire privé');

        for (String recipient in allRecipients) {
          try {
            print('DEBUG Email: Envoi à $recipient');

            // Générer un mot de passe unique pour ce destinataire (vous pouvez personnaliser la logique)
            String uniquePassword = _generatedPassword ??
                'temp123'; // Utiliser le mot de passe généré ou un temporaire

            final success = await _shareService.sendEmailShare(
              formulaireId:
                  Provider.of<FormulaireSondeurBloc>(context, listen: false)
                          .formulaireSondeurModel
                          ?.id ??
                      '',
              shareUrl: _shareUrl!,
              recipients: [recipient], // Un seul destinataire à la fois
              subject: subject,
              message: message,
              password: uniquePassword,
              includePassword: true, // Inclure le mot de passe dans l'email
            );

            if (success) {
              successCount++;
              print('DEBUG Email: Succès pour $recipient');
            } else {
              print('DEBUG Email: Échec pour $recipient');
            }
          } catch (e) {
            print('DEBUG Email: Erreur pour $recipient: $e');
          }
        }

        if (successCount == totalCount) {
          _showSuccessMessage(
              'Emails envoyés avec succès à tous les $totalCount destinataire(s) !');
        } else if (successCount > 0) {
          _showSuccessMessage(
              '$successCount/$totalCount emails envoyés avec succès');
        } else {
          _showErrorMessage('Aucun email n\'a pu être envoyé');
        }
      }

      // Optionnel: Réinitialiser les champs après envoi réussi
      if (successCount > 0) {
        setState(() {
          _recipientEmails.clear();
          _includeCurrentUserEmail = false;
          _subjectController.clear();
          _messageController.clear();
        });
      }
    } catch (e) {
      print('DEBUG Email: Erreur générale = $e');
      _showErrorMessage('Erreur: $e');
    } finally {
      setState(() {
        _isEmailLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Récupérer l'email de l'utilisateur connecté
  Future<String?> _getCurrentUserEmail() async {
    try {
      // TODO: Implémenter la récupération de l'email depuis SharedPreferences ou API
      // Pour l'instant, retourner un email par défaut
      // Dans une vraie implémentation, vous récupéreriez cela depuis:
      // - SharedPreferences (si stocké lors de la connexion)
      // - Un appel API pour récupérer les infos de l'utilisateur
      // - Le contexte d'authentification

      // Exemple d'implémentation avec SharedPreferences:
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_email') ?? 'sondeur@exemple.com';
    } catch (e) {
      print('Erreur lors de la récupération de l\'email utilisateur: $e');
      return null;
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
