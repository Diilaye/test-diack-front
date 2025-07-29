import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/services/formulaire-service.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:go_router/go_router.dart';

class FormulaireResultsPage extends StatefulWidget {
  final String formulaireId;
  final FormulaireSondeurModel? formulaire;

  const FormulaireResultsPage({
    Key? key,
    required this.formulaireId,
    this.formulaire,
  }) : super(key: key);

  @override
  State<FormulaireResultsPage> createState() => _FormulaireResultsPageState();
}

class _FormulaireResultsPageState extends State<FormulaireResultsPage>
    with TickerProviderStateMixin {
  final FormulaireService _formulaireService = FormulaireService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  FormulaireSondeurModel? _formulaire;
  List<ChampsFormulaireModel> _champsData = [];
  List<dynamic> _responses = [];
  List<dynamic> _filteredResponses = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedTabIndex = 0;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  final List<String> _tabs = [
    'Vue d\'ensemble',
    'Réponses individuelles',
    'Statistiques'
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadFormulaireData();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFormulaireData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Charger le formulaire s'il n'est pas fourni
      FormulaireSondeurModel? formulaire = widget.formulaire;
      if (formulaire == null) {
        formulaire = await _formulaireService.one(widget.formulaireId);
      }

      if (formulaire == null) {
        throw Exception('Formulaire non trouvé');
      }

      // Charger les champs du formulaire
      final champsData =
          await _formulaireService.getFormulaireChamps(widget.formulaireId);

      print("DEBUG: CHARGEMENT COMPLET DES DONNÉES");
      print("DEBUG: Nombre de champs chargés: ${champsData.length}");
      print(
          "DEBUG: Nombre de réponses: ${formulaire.responseSondee?.length ?? 0}");

      // Debug des champs avec leurs options
      for (var champ in champsData) {
        print(
            "DEBUG: Champ ID=${champ.id}, Type=${champ.type}, Nom=${champ.nom}");
        if (champ.listeOptions != null) {
          print("  Options (${champ.listeOptions!.length}):");
          for (var option in champ.listeOptions!) {
            print("    - ID: ${option.id}, Option: ${option.option}");
          }
        } else {
          print("  Aucune option");
        }
      }

      // Debug des réponses
      if (formulaire.responseSondee != null) {
        print("DEBUG: STRUCTURE DES RÉPONSES:");
        for (int i = 0; i < formulaire.responseSondee!.length && i < 3; i++) {
          var response = formulaire.responseSondee![i];
          print("  Réponse $i: ${response.toString()}");
          if (response.containsKey('responses')) {
            print("    Sous-réponses: ${response['responses']}");
          }
        }
      }

      setState(() {
        _formulaire = formulaire;
        _champsData = champsData;
        _responses = formulaire?.responseSondee ?? [];
        _filteredResponses = _responses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
        _isLoading = false;
      });
    }
  }

  void _filterResponses(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredResponses = _responses;
      } else {
        _filteredResponses = _responses.where((response) {
          final responseId = response['responseId']?.toString() ??
              response['id']?.toString() ??
              '';
          final sondeId = response['sondeId']?.toString() ?? '';
          return responseId.toLowerCase().contains(query.toLowerCase()) ||
              sondeId.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage != null
              ? _buildErrorView()
              : _buildResultsView(),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement des résultats...'),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadFormulaireData,
              icon: const Icon(CupertinoIcons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset:
                Offset(0, _slideAnimation.value * (1 - _fadeAnimation.value)),
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildTabBar(),
                Expanded(child: _buildTabContent()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Résultats du formulaire',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formulaire?.titre ?? 'Formulaire',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: btnColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.person_2,
                  size: 16,
                  color: btnColor,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_filteredResponses.length} réponse${_filteredResponses.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: btnColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterResponses,
        decoration: InputDecoration(
          hintText: 'Rechercher par ID de réponse ou ID de sonde...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(
            CupertinoIcons.search,
            color: Colors.grey.shade500,
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    CupertinoIcons.clear,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _filterResponses('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTabIndex == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = index),
            child: Container(
              margin: const EdgeInsets.only(right: 32),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(bottom: BorderSide(color: btnColor, width: 3))
                    : null,
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? btnColor : Colors.grey.shade600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildIndividualResponsesTab();
      case 2:
        return _buildStatisticsTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsCards(),
          const SizedBox(height: 32),
          _buildRecentResponses(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final totalResponses = _responses.length;
    final filteredResponses = _filteredResponses.length;
    final completedResponses =
        _responses.where((r) => r['statut'] == 'complete').length;
    final filteredCompletedResponses =
        _filteredResponses.where((r) => r['statut'] == 'complete').length;
    final completionRate = totalResponses > 0
        ? (completedResponses / totalResponses * 100).round()
        : 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total des réponses',
            value: '$filteredResponses / $totalResponses',
            icon: CupertinoIcons.doc_text,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Réponses complètes',
            value: '$filteredCompletedResponses / $completedResponses',
            icon: CupertinoIcons.checkmark_circle,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Taux de complétion',
            value: '$completionRate%',
            icon: CupertinoIcons.chart_pie,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentResponses() {
    if (_filteredResponses.isEmpty) {
      return _buildEmptyState();
    }

    final recentResponses = _filteredResponses.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Réponses récentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: btnColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Filtrées',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: btnColor,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        ...recentResponses.map((response) => _buildResponseCard(response)),
      ],
    );
  }

  Widget _buildResponseCard(dynamic response) {
    final responseId = response['responseId'] ??
        response['id'] ??
        'R-${DateTime.now().millisecondsSinceEpoch}';
    final sondeId = response['sondeId'] ?? 'Inconnu';
    final dateSubmission = response['dateSubmission'] ?? '';
    final statut = response['statut'] ?? 'incomplete';
    final reponses = response['reponses'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statut == 'complete'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              statut == 'complete'
                  ? CupertinoIcons.checkmark_circle
                  : CupertinoIcons.clock,
              color: statut == 'complete' ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Réponse: $responseId',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sonde: $sondeId • ${reponses.length} réponse${reponses.length > 1 ? 's' : ''} • $dateSubmission',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statut == 'complete'
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statut == 'complete' ? 'Complète' : 'Incomplète',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statut == 'complete' ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndividualResponsesTab() {
    if (_filteredResponses.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _filteredResponses.length,
      itemBuilder: (context, index) {
        final response = _filteredResponses[index];
        return _buildDetailedResponseCard(response, index);
      },
    );
  }

  Widget _buildDetailedResponseCard(dynamic response, int index) {
    final responseId = response['responseId'] ??
        response['id'] ??
        'R-${DateTime.now().millisecondsSinceEpoch}';
    final sondeId = response['sondeId'] ?? 'Inconnu';
    final dateSubmission = response['dateSubmission'] ?? '';
    final reponses = response['reponses'] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: btnColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            CupertinoIcons.doc_text,
            color: btnColor,
            size: 20,
          ),
        ),
        title: Text(
          'Réponse: $responseId',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sonde: $sondeId',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Soumis le: $dateSubmission',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${reponses.length} réponse${reponses.length > 1 ? 's' : ''} • Cliquez pour voir les détails',
              style: TextStyle(
                fontSize: 12,
                color: btnColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        children: [
          const Divider(),
          ...reponses.map<Widget>((reponse) => _buildResponseItem(reponse)),
        ],
      ),
    );
  }

  Widget _buildResponseItem(dynamic reponse) {
    final champId = reponse['champId'] ?? 'Champ inconnu';
    final champNom = reponse['champNom'] ?? 'Question inconnue';
    final valeur = reponse['valeur']?.toString() ?? 'Pas de réponse';
    final champType = reponse['champType'] ?? '';

    // Formater l'affichage de la valeur selon le type de champ
    String displayValue = _formatResponseValue(valeur, champType, champId);

    // print("DEBUG displayValue : ${displayValue}");

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et type de champ
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      btnColor.withOpacity(0.1),
                      btnColor.withOpacity(0.05)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: btnColor.withOpacity(0.2)),
                ),
                child: Icon(
                  _getIconForChampType(champType),
                  size: 18,
                  color: btnColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      champNom,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: btnColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            champType,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: btnColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ID: $champId',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Séparateur
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade200,
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Réponse avec style adapté
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Réponse:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatResponseValue(String value, String type, String champId) {
    print("DEBUG _formatResponseValue ${type}");
    // Pour les choix uniques, multiples et yesno, essayer de récupérer les vrais libellés.
    //// type == 'singleChoice'
    if (type == 'multiChoice' || type == 'yesno' || type == 'singleChoice') {
      return _getOptionLabelsFromIds(value, champId, type);
    }

    // Si la valeur semble être un ID (caractères aléatoires), essayer de la décoder
    if (value.length > 10 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      //   // Pour les autres types de champs, retourner la valeur telle quelle
      return value;
    }

    // Traitement spécial selon le type
    switch (type) {
      case 'textArea':
        // Pour les zones de texte, préserver les retours à la ligne
        return value.replaceAll('\\n', '\n');
      default:
        break;
    }

    return value;
  }

  String _getOptionLabelsFromIds(String value, String champId, String type) {
    print(
        "DEBUG _getOptionLabelsFromIds DÉBUT: value='$value', champId='$champId', type='$type'");

    if (_champsData.isEmpty) {
      print("DEBUG: _champsData est vide!");
      return value; // Retourner la valeur originale si pas de champs
    }

    print("DEBUG: _champsData contient ${_champsData.length} champs");

    // Trouver le champ correspondant dans les champs chargés
    ChampsFormulaireModel? champData;
    try {
      champData = _champsData.where((champ) => champ.id == champId).firstOrNull;
      print("DEBUG: Champ trouvé: ${champData?.id}, nom: ${champData?.nom}");
    } catch (e) {
      print("DEBUG: Erreur lors de la recherche du champ: $e");
      return value; // Retourner la valeur originale si champ non trouvé
    }

    if (champData == null) {
      print("DEBUG: Aucun champ trouvé avec l'ID $champId");
      print("DEBUG: IDs disponibles: ${_champsData.map((c) => c.id).toList()}");
      return value; // Retourner la valeur originale si pas d'options
    }

    if (champData.listeOptions == null) {
      print("DEBUG: Le champ ${champData.id} n'a pas d'options");
      return value;
    }

    List<ListeOptions> options = champData.listeOptions!;
    print(
        "DEBUG: Le champ a ${options.length} options: ${options.map((o) => '${o.id}:${o.option}').join(', ')}");

    if (type == 'multiChoice') {
      // Pour les choix multiples, traiter les valeurs multiples
      try {
        List<String> selectedIds;

        // Gérer différents formats de valeurs multiples
        if (value.startsWith('[') && value.endsWith(']')) {
          // Format JSON array string
          String cleanValue = value.substring(1, value.length - 1);
          selectedIds = cleanValue
              .split(',')
              .map((id) => id.trim().replaceAll('"', ''))
              .toList();
        } else if (value.contains(',')) {
          // Format séparé par virgules
          selectedIds = value.split(',').map((id) => id.trim()).toList();
        } else {
          // Valeur unique
          selectedIds = [value];
        }

        List<String> labels = [];
        for (String selectedId in selectedIds) {
          if (selectedId.isNotEmpty) {
            try {
              ListeOptions? option =
                  options.where((opt) => opt.id == selectedId).firstOrNull;

              if (option != null && option.option != null) {
                labels.add(option.option!);
              } else {
                labels.add(selectedId); // Fallback à l'ID si libellé non trouvé
              }
            } catch (e) {
              labels.add(selectedId); // Fallback à l'ID en cas d'erreur
            }
          }
        }

        String result = labels.isNotEmpty ? labels.join(', ') : value;
        print('DEBUG: Résultat multipleChoice: $result');
        return result;
      } catch (e) {
        print('DEBUG: Erreur multipleChoice: $e');
        return value; // Retourner la valeur originale en cas d'erreur
      }
    } else if (type == 'singleChoice' || type == 'yesno') {
      // Pour les choix uniques et yesno
      try {
        ListeOptions? option =
            options.where((opt) => opt.id == value).firstOrNull;

        print(
            'DEBUG: Recherche singleChoice/yesno pour id=$value, trouvé: ${option?.option}');

        if (option != null && option.option != null) {
          print('DEBUG: Résultat singleChoice/yesno: ${option.option!}');
          return option.option!;
        }
      } catch (e) {
        print('DEBUG: Erreur singleChoice/yesno: $e');
        // En cas d'erreur, retourner la valeur originale
      }
    }

    print('DEBUG: Retour valeur originale: $value');
    return value; // Fallback à la valeur originale
  }

  IconData _getIconForChampType(String type) {
    switch (type) {
      case 'singleChoice':
        return CupertinoIcons.check_mark_circled;
      case 'multipleChoice':
        return CupertinoIcons.square_list;
      case 'yesno':
        return CupertinoIcons.question_circle;
      case 'textField':
        return CupertinoIcons.textformat;
      case 'textArea':
        return CupertinoIcons.text_alignleft;
      default:
        return CupertinoIcons.doc_text;
    }
  }

  Widget _buildStatisticsTab() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.chart_bar_alt_fill,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Statistiques avancées',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cette fonctionnalité sera bientôt disponible',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFiltered = _searchQuery.isNotEmpty;
    final title =
        isFiltered ? 'Aucun résultat trouvé' : 'Aucune réponse pour le moment';
    final subtitle = isFiltered
        ? 'Essayez de modifier votre recherche ou effacez les filtres pour voir toutes les réponses.'
        : 'Les réponses apparaîtront ici une fois que des personnes auront rempli votre formulaire.';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFiltered ? CupertinoIcons.search : CupertinoIcons.doc_text,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            if (isFiltered) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  _filterResponses('');
                },
                icon: const Icon(CupertinoIcons.clear),
                label: const Text('Effacer les filtres'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
