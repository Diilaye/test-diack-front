import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/utils/app_theme.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/widget/padding-global.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:form/blocs/folder-bloc.dart';

class ParamsFormSondeurScreen extends StatefulWidget {
  const ParamsFormSondeurScreen({super.key});

  @override
  State<ParamsFormSondeurScreen> createState() =>
      _ParamsFormSondeurScreenState();
}

class _ParamsFormSondeurScreenState extends State<ParamsFormSondeurScreen> {
  int selectedTabIndex = 0;
  bool connectionRequired = false;
  bool notificationsEnabled = true;
  bool autoSave = true;
  bool publicForm = false;
  bool anonymousResponses = false;
  bool limitResponses = false;
  int maxResponses = 100;
  DateTime? startDate;
  DateTime? endDate;
  String selectedLanguage = 'fr';
  String selectedTimezone = 'Europe/Paris';

  final List<Map<String, dynamic>> tabs = [
    {
      'title': 'Général',
      'icon': CupertinoIcons.gear_alt,
      'description': 'Paramètres généraux du formulaire'
    },
    {
      'title': 'Notifications',
      'icon': CupertinoIcons.bell,
      'description': 'Gestion des notifications'
    },
    {
      'title': 'Planification',
      'icon': CupertinoIcons.calendar,
      'description': 'Planification et durée'
    },
    {
      'title': 'Localisation',
      'icon': CupertinoIcons.globe,
      'description': 'Langue et région'
    },
    {
      'title': 'Sécurité',
      'icon': CupertinoIcons.lock,
      'description': 'Confidentialité et accès'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context, formulaireSondeur, folderBloc),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, FolderBloc folderBloc) {
    return AppBar(
      centerTitle: false,
      toolbarHeight: 80,
      elevation: 0,
      backgroundColor: blanc,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.1),
      title: Row(
        children: [
          paddingHorizontalGlobal(8),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.folder,
                      color: Colors.grey[600],
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formulaireSondeur.formulaireSondeurModel!.folderForm ==
                              null
                          ? "Mes formulaires"
                          : formulaireSondeur
                              .formulaireSondeurModel!.folderForm!.titre!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          paddingHorizontalGlobal(8),
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 16,
          ),
          paddingHorizontalGlobal(8),
          Text(
            formulaireSondeur.formulaireSondeurModel!.titre!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontFamily: 'Rubik',
            ),
          ),
        ],
      ),
      actions: [
        _buildHeaderTab('Construire', CupertinoIcons.building_2_fill, false,
            onTap: () => context.go(
                '/formulaire/${formulaireSondeur.formulaireSondeurModel!.id!}/create')),
        const SizedBox(width: 8),
        _buildHeaderTab(
          'Paramètres',
          CupertinoIcons.settings,
          true,
        ),
        const SizedBox(width: 8),
        _buildHeaderTab('Partager', CupertinoIcons.share, false,
            onTap: () => context.go(
                '/formulaire/${formulaireSondeur.formulaireSondeurModel!.id!}/share')),
        const SizedBox(width: 8),
        _buildHeaderTab('Résultats', CupertinoIcons.chart_bar_alt_fill, false,
            onTap: () => context.go(
                '/formulaire/${formulaireSondeur.formulaireSondeurModel!.id!}/results')),
        const SizedBox(width: 32),
        _buildActionButton(
          icon: CupertinoIcons.eye,
          tooltip: 'Aperçu',
          isPrimary: false,
          onTap: () {
            // Naviguer vers l'aperçu du formulaire
            context
                .go('/form/${formulaireSondeur.formulaireSondeurModel!.id!}');
          },
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.save_rounded,
          label: 'Sauvegarder',
          tooltip: 'Sauvegarder le formulaire',
          isPrimary: true,
          onTap: () {},
        ),
        const SizedBox(width: 32),
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
          color: isActive
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border(
                  bottom: BorderSide(color: AppTheme.primaryColor, width: 3))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.primaryColor : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppTheme.primaryColor : Colors.grey.shade600,
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

  Widget _buildNavButton(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isActive ? btnColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? btnColor : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isActive ? btnColor : Colors.grey[600],
                    fontFamily: 'Rubik',
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 30,
                    height: 2,
                    decoration: BoxDecoration(
                      color: btnColor,
                      borderRadius: BorderRadius.circular(1),
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
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: btnColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    CupertinoIcons.settings,
                    color: btnColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Paramètres",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Configurez votre formulaire",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final tab = tabs[index];
                final isSelected = index == selectedTabIndex;

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Material(
                    color: isSelected
                        ? btnColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected ? btnColor : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                tab['icon'],
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[600],
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tab['title'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? btnColor
                                          : Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    tab['description'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 4,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: btnColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
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

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tabs[selectedTabIndex]['title'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Sauvegarde automatique",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            tabs[selectedTabIndex]['description'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0:
        return _buildGeneralSettings();
      case 1:
        return _buildNotificationSettings();
      case 2:
        return _buildSchedulingSettings();
      case 3:
        return _buildLocalizationSettings();
      case 4:
        return _buildSecuritySettings();
      default:
        return _buildGeneralSettings();
    }
  }

  Widget _buildGeneralSettings() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: "Paramètres de base",
            icon: CupertinoIcons.gear_alt,
            children: [
              _buildSwitchTile(
                title: "Connexion requise",
                subtitle:
                    "Les utilisateurs doivent être connectés pour répondre",
                value: connectionRequired,
                onChanged: (value) =>
                    setState(() => connectionRequired = value),
              ),
              _buildSwitchTile(
                title: "Sauvegarde automatique",
                subtitle: "Sauvegarde automatique des réponses en cours",
                value: autoSave,
                onChanged: (value) => setState(() => autoSave = value),
              ),
              _buildSwitchTile(
                title: "Formulaire public",
                subtitle: "Accessible via un lien public",
                value: publicForm,
                onChanged: (value) => setState(() => publicForm = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionCard(
            title: "Limite de réponses",
            icon: CupertinoIcons.number,
            children: [
              _buildSwitchTile(
                title: "Limiter les réponses",
                subtitle: "Définir un nombre maximum de réponses",
                value: limitResponses,
                onChanged: (value) => setState(() => limitResponses = value),
              ),
              if (limitResponses) ...[
                const SizedBox(height: 16),
                _buildNumberInput(
                  title: "Nombre maximum de réponses",
                  value: maxResponses,
                  onChanged: (value) => setState(() => maxResponses = value),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: "Notifications",
            icon: CupertinoIcons.bell,
            children: [
              _buildSwitchTile(
                title: "Activer les notifications",
                subtitle:
                    "Recevoir des notifications pour les nouvelles réponses",
                value: notificationsEnabled,
                onChanged: (value) =>
                    setState(() => notificationsEnabled = value),
              ),
              if (notificationsEnabled) ...[
                _buildSwitchTile(
                  title: "Notifications par email",
                  subtitle: "Recevoir un email pour chaque nouvelle réponse",
                  value: true,
                  onChanged: (value) {},
                ),
                _buildSwitchTile(
                  title: "Résumé quotidien",
                  subtitle: "Recevoir un résumé quotidien des réponses",
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSchedulingSettings() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: "Planification",
            icon: CupertinoIcons.calendar,
            children: [
              _buildDatePicker(
                title: "Date de début",
                subtitle: "Quand le formulaire sera disponible",
                date: startDate,
                onChanged: (date) => setState(() => startDate = date),
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                title: "Date de fin",
                subtitle: "Quand le formulaire sera fermé",
                date: endDate,
                onChanged: (date) => setState(() => endDate = date),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocalizationSettings() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: "Langue et région",
            icon: CupertinoIcons.globe,
            children: [
              _buildDropdown(
                title: "Langue",
                value: selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'fr', child: Text('Français')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'es', child: Text('Español')),
                ],
                onChanged: (value) => setState(() => selectedLanguage = value!),
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                title: "Fuseau horaire",
                value: selectedTimezone,
                items: const [
                  DropdownMenuItem(
                      value: 'Europe/Paris', child: Text('Europe/Paris')),
                  DropdownMenuItem(
                      value: 'America/New_York',
                      child: Text('America/New_York')),
                  DropdownMenuItem(
                      value: 'Asia/Tokyo', child: Text('Asia/Tokyo')),
                ],
                onChanged: (value) => setState(() => selectedTimezone = value!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            title: "Confidentialité",
            icon: CupertinoIcons.lock,
            children: [
              _buildSwitchTile(
                title: "Réponses anonymes",
                subtitle: "Ne pas collecter d'informations personnelles",
                value: anonymousResponses,
                onChanged: (value) =>
                    setState(() => anonymousResponses = value),
              ),
              _buildSwitchTile(
                title: "Chiffrement des données",
                subtitle: "Chiffrer les réponses stockées",
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: btnColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: btnColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
          const SizedBox(width: 16),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: btnColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberInput({
    required String title,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(height: 8),
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              initialValue: value.toString(),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (val) {
                final intValue = int.tryParse(val) ?? value;
                onChanged(intValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String title,
    required String subtitle,
    required DateTime? date,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (pickedDate != null) {
                onChanged(pickedDate);
              }
            },
            child: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    date != null
                        ? '${date.day}/${date.month}/${date.year}'
                        : 'Sélectionner une date',
                    style: TextStyle(
                      fontSize: 14,
                      color: date != null ? Colors.black87 : Colors.grey[600],
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

  Widget _buildDropdown<T>({
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          const SizedBox(height: 8),
          Container(
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonFormField<T>(
              value: value,
              items: items,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
