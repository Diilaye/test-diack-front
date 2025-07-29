import 'package:flutter/material.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/models/response-sondeur-model.dart';
import 'package:form/services/formulaire-service.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/responsive.dart';

class FormulaireResultsPreview extends S                  Text(
                    champ.nom ?? 'Question sans titre',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),Widget {
  final String formulaireId;

  const FormulaireResultsPreview({
    Key? key,
    required this.formulaireId,
  }) : super(key: key);

  @override
  State<FormulaireResultsPreview> createState() =>
      _FormulaireResultsPreviewState();
}

class _FormulaireResultsPreviewState extends State<FormulaireResultsPreview>
    with TickerProviderStateMixin {
  final FormulaireService _formulaireService = FormulaireService();
  
  FormulaireSondeurModel? _formulaire;
  List<ChampsFormulaireModel> _champs = [];
  Map<String, List<ReponseSondeurModel>> _responses = {};
  bool _isLoading = true;
  String? _error;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadFormulaireData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  Future<void> _loadFormulaireData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Charger le formulaire
      final formulaire = await _formulaireService.one(widget.formulaireId);
      if (formulaire == null) {
        throw Exception('Formulaire introuvable');
      }

      // Charger les champs
      final champs = await _formulaireService.getFormulaireChamps(widget.formulaireId);
      
      // Charger les réponses pour chaque champ
      Map<String, List<ReponseSondeurModel>> responses = {};
      for (var champ in champs) {
        final champsResponses = await _formulaireService.getReponseFormulaire(champ.id ?? '');
        responses[champ.id ?? ''] = champsResponses;
      }

      setState(() {
        _formulaire = formulaire;
        _champs = champs;
        _responses = responses;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Résultats du formulaire',
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadFormulaireData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormulaireHeader(),
              const SizedBox(height: 32),
              _buildStatisticsOverview(),
              const SizedBox(height: 32),
              _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormulaireHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.poll,
                    color: primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formulaire?.titre ?? 'Formulaire',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_formulaire?.description?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        Text(
                          _formulaire!.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsOverview() {
    final totalResponses = _responses.values
        .expand((responses) => responses)
        .length;

    final totalChamps = _champs.length;
    
    final champsWithResponses = _responses.entries
        .where((entry) => entry.value.isNotEmpty)
        .length;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques générales',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total réponses',
                    totalResponses.toString(),
                    Icons.reply_all,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Questions',
                    totalChamps.toString(),
                    Icons.quiz,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Questions répondues',
                    champsWithResponses.toString(),
                    Icons.check_circle,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail des réponses',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _champs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final champ = _champs[index];
            final responses = _responses[champ.id] ?? [];
            return _buildChampResults(champ, responses);
          },
        ),
      ],
    );
  }

  Widget _buildChampResults(ChampsFormulaireModel champ, List<ReponseSondeurModel> responses) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(champ.type ?? '').withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getTypeLabel(champ.type ?? ''),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getTypeColor(champ.type ?? ''),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    champ.label ?? 'Question sans titre',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${responses.length} réponse${responses.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (responses.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Aucune réponse pour cette question',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              _buildResponsesList(champ, responses),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsesList(ChampsFormulaireModel champ, List<ReponseSondeurModel> responses) {
    // Grouper les réponses identiques pour les afficher avec leur nombre d'occurrences
    final Map<String, int> responseCounts = {};
    for (var response in responses) {
      final value = response.value ?? '';
      responseCounts[value] = (responseCounts[value] ?? 0) + 1;
    }

    final sortedEntries = responseCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((entry) {
        final percentage = (entry.value / responses.length * 100).round();
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key.isNotEmpty ? entry.key : 'Réponse vide',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${entry.value} ($percentage%)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / responses.length,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColor.primaryColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'text':
      case 'textarea':
        return Colors.blue;
      case 'choix_unique':
        return Colors.green;
      case 'choix_multiple':
        return Colors.orange;
      case 'note':
        return Colors.purple;
      case 'date':
        return Colors.teal;
      case 'email':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'text':
        return 'Texte';
      case 'textarea':
        return 'Texte long';
      case 'choix_unique':
        return 'Choix unique';
      case 'choix_multiple':
        return 'Choix multiple';
      case 'note':
        return 'Note';
      case 'date':
        return 'Date';
      case 'email':
        return 'Email';
      default:
        return type.toUpperCase();
    }
  }
}
