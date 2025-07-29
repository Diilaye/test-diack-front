import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/models/formulaire-sondeur-model.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/services/share-service.dart';
import 'package:form/services/formulaire-service.dart';
import 'package:form/screen/shared/widgets/form-response-field.dart';
import 'package:form/screen/shared/response-success-page.dart';
import 'package:form/utils/colors-by-dii.dart';

class FormResponsePage extends StatefulWidget {
  final String shareId;
  final FormulaireSondeurModel? formulaire;
  final bool requirePassword;

  const FormResponsePage({
    Key? key,
    required this.shareId,
    this.formulaire,
    this.requirePassword = false,
  }) : super(key: key);

  @override
  State<FormResponsePage> createState() => _FormResponsePageState();
}

class _FormResponsePageState extends State<FormResponsePage>
    with TickerProviderStateMixin {
  final ShareService _shareService = ShareService();
  final FormulaireService _formulaireService = FormulaireService();
  final PageController _pageController = PageController();

  late AnimationController _progressAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  FormulaireSondeurModel? _formulaire;
  List<ChampsFormulaireModel> _champs = [];
  Map<String, dynamic> _responses = {};
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  int _currentPage = 0;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadFormData();
  }

  void _initAnimations() {
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeOut),
    );

    _fadeAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      FormulaireSondeurModel? formulaire = widget.formulaire;

      if (formulaire == null) {
        final shareDetails =
            await _shareService.getShareDetails(widget.shareId);
        if (shareDetails != null && shareDetails['formulaireId'] != null) {
          formulaire =
              FormulaireSondeurModel.fromJson(shareDetails['formulaireId']);
        }
      }

      if (formulaire == null) {
        throw Exception('Formulaire non trouvé');
      }

      if (_isTestFormulaire(formulaire.id!)) {
        _champs = _createTestChamps();
      } else {
        _champs = await _formulaireService.getFormulaireChamps(formulaire.id!);
      }

      _totalPages = _calculateTotalPages();

      setState(() {
        _formulaire = formulaire;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
        _isLoading = false;
      });
    }
  }

  bool _isTestFormulaire(String formulaireId) {
    return formulaireId.startsWith('test-') ||
        formulaireId.startsWith('direct-');
  }

  List<ChampsFormulaireModel> _createTestChamps() {
    return [
      ChampsFormulaireModel(
        id: 'champ-1',
        nom: 'Votre nom complet',
        description: 'Nom et prénom',
        type: 'textField',
        isObligatoire: '1',
        haveResponse: '0',
        formulaire: 'test-form-123',
      ),
      ChampsFormulaireModel(
        id: 'champ-2',
        nom: 'Votre adresse email',
        description: 'Pour vous envoyer une confirmation',
        type: 'email',
        isObligatoire: '1',
        haveResponse: '0',
        formulaire: 'test-form-123',
      ),
      ChampsFormulaireModel(
        id: 'champ-3',
        nom: 'Comment évaluez-vous notre service ?',
        description: 'Donnez votre avis sur la qualité',
        type: 'singleChoice',
        isObligatoire: '1',
        haveResponse: '0',
        formulaire: 'test-form-123',
        listeOptions: [
          ListeOptions(id: 'option-1', option: 'Excellent'),
          ListeOptions(id: 'option-2', option: 'Très bien'),
          ListeOptions(id: 'option-3', option: 'Bien'),
          ListeOptions(id: 'option-4', option: 'Passable'),
          ListeOptions(id: 'option-5', option: 'Insuffisant'),
        ],
      ),
      ChampsFormulaireModel(
        id: 'champ-4',
        nom: 'Commentaires additionnels',
        description: 'Partagez vos suggestions ou remarques',
        type: 'textArea',
        isObligatoire: '0',
        haveResponse: '0',
        formulaire: 'test-form-123',
      ),
    ];
  }

  int _calculateTotalPages() {
    if (_champs.isEmpty) return 1;
    return ((_champs.length - 1) ~/ 3) + 1; // 3 champs par page
  }

  List<ChampsFormulaireModel> _getChampsForPage(int pageIndex) {
    final startIndex = pageIndex * 3;
    final endIndex = (startIndex + 3).clamp(0, _champs.length);
    return _champs.sublist(startIndex, endIndex);
  }

  void _updateResponse(String champId, dynamic value) {
    setState(() {
      _responses[champId] = value;
    });
  }

  bool _isCurrentPageValid() {
    final champsForPage = _getChampsForPage(_currentPage);
    for (final champ in champsForPage) {
      if (champ.isObligatoire == '1') {
        final response = _responses[champ.id];
        if (response == null ||
            (response is String && response.trim().isEmpty) ||
            (response is List && response.isEmpty)) {
          return false;
        }
      }
    }
    return true;
  }

  void _nextPage() {
    if (!_isCurrentPageValid()) {
      _showValidationError();
      return;
    }

    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitForm();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Veuillez remplir tous les champs obligatoires'),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _submitForm() async {
    setState(() => _isSubmitting = true);

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulation

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResponseSuccessPage(
            formulaireTitle: _formulaire!.titre!,
            shareId: widget.shareId,
            responses: _responses,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la soumission: $e';
        _isSubmitting = false;
      });
    }
  }

  double _getProgress() {
    if (_totalPages <= 1) return 1.0;
    return (_currentPage + 1) / _totalPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? _buildLoadingView()
          : _errorMessage != null
              ? _buildErrorView()
              : _buildModernFormView(),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Colors.white],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [btnColor, btnColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Chargement du formulaire...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Veuillez patienter quelques instants',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 40,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Une erreur s\'est produite',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loadFormData,
                  icon: const Icon(CupertinoIcons.refresh),
                  label: const Text('Réessayer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernFormView() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset:
                Offset(0, _slideAnimation.value * (1 - _fadeAnimation.value)),
            child: SafeArea(
              child: Column(
                children: [
                  _buildModernHeader(),
                  Expanded(child: _buildFormContent()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formulaire?.titre ?? 'Formulaire',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (_formulaire?.description != null) ...[
            const SizedBox(height: 8),
            Text(
              _formulaire!.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Étape ${_currentPage + 1} sur $_totalPages',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: btnColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${((_currentPage + 1) / _totalPages * 100).round()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: btnColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(3),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: constraints.maxWidth * _getProgress(),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [btnColor, btnColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _totalPages,
                itemBuilder: (context, index) {
                  return _buildPageContent(index);
                },
              ),
            ),
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int pageIndex) {
    final champsForPage = _getChampsForPage(pageIndex);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...champsForPage.map((champ) => Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: FormResponseField(
                  champ: champ,
                  value: _responses[champ.id],
                  onChanged: (value) => _updateResponse(champ.id!, value),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousPage,
                icon: const Icon(CupertinoIcons.chevron_left),
                label: const Text('Précédent'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _nextPage,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(_currentPage == _totalPages - 1
                      ? CupertinoIcons.checkmark_alt
                      : CupertinoIcons.chevron_right),
              label: Text(
                  _currentPage == _totalPages - 1 ? 'Terminer' : 'Suivant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
