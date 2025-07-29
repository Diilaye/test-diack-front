import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DateFieldFormModern extends StatefulWidget {
  final dynamic champ;

  const DateFieldFormModern({super.key, required this.champ});

  @override
  State<DateFieldFormModern> createState() => _DateFieldFormModernState();
}

class _DateFieldFormModernState extends State<DateFieldFormModern>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  bool _isHovered = false;
  bool _isExpanded = false;
  DateTime? _selectedDate;
  String _dateFormat = 'DD/MM/YYYY';
  bool _allowPastDates = true;
  bool _allowFutureDates = true;

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _placeholderController = TextEditingController();
  final TextEditingController _helpTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initializeData();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _initializeData() {
    _labelController.text = widget.champ.nom ?? 'Sélectionnez une date';
    _placeholderController.text = 'Choisir une date...';
    _helpTextController.text = widget.champ.description ?? '';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hoverController.dispose();
    _labelController.dispose();
    _placeholderController.dispose();
    _helpTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: MouseRegion(
                onEnter: (_) => _onHover(true),
                onExit: (_) => _onHover(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isHovered
                          ? btnColor.withOpacity(0.3)
                          : Colors.grey.shade200,
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? btnColor.withOpacity(0.1)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: _isHovered ? 12 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildHeader(formulaireSondeur),
                      _buildContent(formulaireSondeur),
                      if (_isExpanded) _buildSettings(formulaireSondeur),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(FormulaireSondeurBloc formulaireSondeur) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.calendar,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Champ Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Permet de sélectionner une date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          _buildActionButtons(formulaireSondeur),
        ],
      ),
    );
  }

  Widget _buildActionButtons(FormulaireSondeurBloc formulaireSondeur) {
    return Row(
      children: [
        _buildActionButton(
          icon: _isExpanded
              ? CupertinoIcons.settings_solid
              : CupertinoIcons.settings,
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          color: Colors.blue,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: CupertinoIcons.doc_on_clipboard,
          onTap: () => _duplicateField(formulaireSondeur),
          color: Colors.green,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: CupertinoIcons.delete,
          onTap: () => _deleteField(formulaireSondeur),
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildContent(FormulaireSondeurBloc formulaireSondeur) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelField(),
          const SizedBox(height: 16),
          _buildDatePreview(),
          const SizedBox(height: 16),
          _buildPlaceholderField(),
          const SizedBox(height: 16),
          _buildHelpTextField(),
        ],
      ),
    );
  }

  Widget _buildLabelField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Libellé de la question',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _labelController,
          onChanged: (value) => _updateField('nom', value),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: btnColor, width: 2),
            ),
            hintText: 'Ex: Date de naissance',
          ),
        ),
      ],
    );
  }

  Widget _buildDatePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aperçu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.calendar,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : _placeholderController.text.isNotEmpty
                            ? _placeholderController.text
                            : 'Choisir une date...',
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_down,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Texte de substitution',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _placeholderController,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: btnColor, width: 2),
            ),
            hintText: 'Ex: Sélectionnez votre date de naissance',
          ),
        ),
      ],
    );
  }

  Widget _buildHelpTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (optionnel)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _helpTextController,
          onChanged: (value) => _updateField('description', value),
          maxLines: 2,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: btnColor, width: 2),
            ),
            hintText: 'Informations supplémentaires pour aider l\'utilisateur',
          ),
        ),
      ],
    );
  }

  Widget _buildSettings(FormulaireSondeurBloc formulaireSondeur) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paramètres avancés',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          _buildDateFormatSelector(),
          const SizedBox(height: 16),
          _buildDateRestrictions(),
          const SizedBox(height: 16),
          _buildRequiredToggle(formulaireSondeur),
        ],
      ),
    );
  }

  Widget _buildDateFormatSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Format de date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildFormatOption('DD/MM/YYYY', '23/12/2024'),
              _buildFormatOption('MM/DD/YYYY', '12/23/2024'),
              _buildFormatOption('YYYY-MM-DD', '2024-12-23'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormatOption(String format, String example) {
    final isSelected = _dateFormat == format;
    return GestureDetector(
      onTap: () => setState(() => _dateFormat = format),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? btnColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? btnColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: btnColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    format,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? btnColor : Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    example,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRestrictions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restrictions de date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildToggleOption(
                'Dates passées',
                _allowPastDates,
                (value) => setState(() => _allowPastDates = value),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildToggleOption(
                'Dates futures',
                _allowFutureDates,
                (value) => setState(() => _allowFutureDates = value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleOption(
      String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
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

  Widget _buildRequiredToggle(FormulaireSondeurBloc formulaireSondeur) {
    final isRequired = widget.champ.isObligatoire == '1';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.exclamationmark_shield,
            color: isRequired ? Colors.red : Colors.grey.shade500,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Champ obligatoire',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'L\'utilisateur doit sélectionner une date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: isRequired,
            onChanged: (value) => _toggleRequired(formulaireSondeur, value),
            activeColor: btnColor,
          ),
        ],
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: _allowPastDates ? DateTime(1900) : DateTime.now(),
      lastDate: _allowFutureDates ? DateTime(2100) : DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: btnColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    switch (_dateFormat) {
      case 'MM/DD/YYYY':
        return DateFormat('MM/dd/yyyy').format(date);
      case 'YYYY-MM-DD':
        return DateFormat('yyyy-MM-dd').format(date);
      default: // DD/MM/YYYY
        return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  void _updateField(String field, String value) {
    final formulaireSondeur =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);

    switch (field) {
      case 'nom':
        formulaireSondeur.updateChampFormulaireNomQuestions(
            widget.champ.id!, value);
        break;
      case 'description':
        formulaireSondeur.updateChampFormulaireDescriptionQuestions(
            widget.champ.id!, value);
        break;
    }
  }

  void _toggleRequired(FormulaireSondeurBloc formulaireSondeur, bool value) {
    formulaireSondeur.updateChampFormulaireObligatoireQuestions(
        widget.champ.id!, value ? '1' : '0');
  }

  void _duplicateField(FormulaireSondeurBloc formulaireSondeur) {
    // Implémentation de la duplication du champ
    formulaireSondeur.addChampFormulaireType(
      formulaireSondeur.formulaireSondeurModel!.id!,
      'date',
    );
  }

  void _deleteField(FormulaireSondeurBloc formulaireSondeur) {
    formulaireSondeur.deleteChampFormulaire(widget.champ.id!);
  }
}
