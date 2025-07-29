import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Composant de base moderne pour tous les types de questions
/// Inclut animations, design moderne, micro-interactions
class ModernQuestionCard extends StatefulWidget {
  final Widget child;
  final String questionType;
  final String questionTitle;
  final VoidCallback? onSettings;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;
  final ValueChanged<String>? onQuestionTitleChanged;
  final bool isRequired;
  final double? height;
  final Color? accentColor;

  const ModernQuestionCard({
    super.key,
    required this.child,
    required this.questionType,
    required this.questionTitle,
    this.onSettings,
    this.onDelete,
    this.onDuplicate,
    this.onQuestionTitleChanged,
    this.isRequired = false,
    this.height,
    this.accentColor,
  });

  @override
  State<ModernQuestionCard> createState() => _ModernQuestionCardState();
}

class _ModernQuestionCardState extends State<ModernQuestionCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _settingsController;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _settingsRotation;
  late TextEditingController _titleController;
  late FocusNode _titleFocusNode;

  bool _isHovered = false;
  bool _isSettingsOpen = false;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.questionTitle);
    _titleFocusNode = FocusNode();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _settingsRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _settingsController,
      curve: Curves.easeOutCubic,
    ));

    // Écouter les changements de focus
    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus && _isEditingTitle) {
        _saveTitle(_titleController.text);
      }
    });
  }

  @override
  void didUpdateWidget(ModernQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.questionTitle != widget.questionTitle) {
      _titleController.text = widget.questionTitle;
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _settingsController.dispose();
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _toggleSettings() {
    setState(() {
      _isSettingsOpen = !_isSettingsOpen;
    });

    if (_isSettingsOpen) {
      _settingsController.forward();
    } else {
      _settingsController.reverse();
    }

    if (widget.onSettings != null) {
      widget.onSettings!();
    }
  }

  void _saveTitle(String value) {
    if (widget.onQuestionTitleChanged != null) {
      widget.onQuestionTitleChanged!(value);
    }
    setState(() {
      _isEditingTitle = false;
    });
  }

  void _startEditingTitle() {
    setState(() {
      _isEditingTitle = true;
    });
    // Donner le focus immédiatement
    Future.microtask(() {
      _titleFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? const Color(0xFF6366F1);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverController, _settingsController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isSettingsOpen
                      ? accentColor.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.1),
                  width: _isSettingsOpen ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: _elevationAnimation.value * 2,
                    color: accentColor.withOpacity(0.1),
                  ),
                  BoxShadow(
                    offset: const Offset(0, 2),
                    blurRadius: _elevationAnimation.value,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header avec type de question et actions
                  _buildHeader(accentColor),

                  // Contenu principal
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.all(20),
                    child: widget.child,
                  ),

                  // Footer avec actions supplémentaires si settings ouvert
                  if (_isSettingsOpen) _buildFooter(accentColor),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icône du type de question
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getQuestionTypeIcon(),
              size: 16,
              color: accentColor,
            ),
          ),

          const SizedBox(width: 12),

          // Type et titre de la question
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.questionType,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: _isEditingTitle ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isEditingTitle
                          ? accentColor.withOpacity(0.5)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: _isEditingTitle
                      ? TextField(
                          controller: _titleController,
                          focusNode: _titleFocusNode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                            height: 1.3,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            isDense: true,
                            hintText: 'Nom de la question',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade500,
                              height: 1.3,
                            ),
                          ),
                          onSubmitted: (value) {
                            _saveTitle(value);
                          },
                          onEditingComplete: () {
                            _saveTitle(_titleController.text);
                          },
                          textInputAction: TextInputAction.done,
                          cursorColor: accentColor,
                          cursorWidth: 1.5,
                          cursorHeight: 20,
                        )
                      : GestureDetector(
                          onTap: _startEditingTitle,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.questionTitle.isEmpty
                                        ? 'Nom de la question'
                                        : widget.questionTitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: widget.questionTitle.isEmpty
                                          ? Colors.grey.shade500
                                          : const Color(0xFF1F2937),
                                      height: 1.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  CupertinoIcons.pencil,
                                  size: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),

          // Badge obligatoire
          if (widget.isRequired)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Obligatoire',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ),

          const SizedBox(width: 12),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: CupertinoIcons.doc_on_doc,
                onTap: widget.onDuplicate,
                tooltip: 'Dupliquer',
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: CupertinoIcons.settings,
                onTap: _toggleSettings,
                tooltip: 'Paramètres',
                isActive: _isSettingsOpen,
                rotation: _settingsRotation,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: CupertinoIcons.delete,
                onTap: widget.onDelete,
                tooltip: 'Supprimer',
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
    String? tooltip,
    bool isActive = false,
    bool isDestructive = false,
    Animation<double>? rotation,
  }) {
    Widget button = GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive
              ? (widget.accentColor ?? const Color(0xFF6366F1)).withOpacity(0.1)
              : _isHovered
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: rotation != null
            ? RotationTransition(
                turns: rotation,
                child: Icon(
                  icon,
                  size: 16,
                  color: isDestructive
                      ? Colors.red
                      : isActive
                          ? (widget.accentColor ?? const Color(0xFF6366F1))
                          : const Color(0xFF6B7280),
                ),
              )
            : Icon(
                icon,
                size: 16,
                color: isDestructive
                    ? Colors.red
                    : isActive
                        ? (widget.accentColor ?? const Color(0xFF6366F1))
                        : const Color(0xFF6B7280),
              ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }

  Widget _buildFooter(Color accentColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.02),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Options de configuration rapide
          _buildQuickOption(
            icon: CupertinoIcons.checkmark_alt,
            label: 'Obligatoire',
            isActive: widget.isRequired,
            accentColor: accentColor,
          ),

          const SizedBox(width: 16),

          _buildQuickOption(
            icon: CupertinoIcons.eye,
            label: 'Aperçu',
            isActive: false,
            accentColor: accentColor,
          ),

          const Spacer(),

          // Informations supplémentaires
          Text(
            'ID: ${widget.questionType.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.withOpacity(0.6),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOption({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () {
        // Handle quick option toggle
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? accentColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isActive
                ? accentColor.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? accentColor : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? accentColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getQuestionTypeIcon() {
    switch (widget.questionType.toLowerCase()) {
      case 'texte':
      case 'textfield':
        return CupertinoIcons.textformat;
      case 'email':
        return CupertinoIcons.mail;
      case 'téléphone':
      case 'telephone':
        return CupertinoIcons.phone;
      case 'adresse':
      case 'addresse':
        return CupertinoIcons.location;
      case 'nom complet':
      case 'fullname':
        return CupertinoIcons.person;
      case 'sélection unique':
      case 'single_selection':
        return CupertinoIcons.selection_pin_in_out;
      case 'sélection multiple':
      case 'multi_selection':
        return CupertinoIcons.checkmark_square;
      case 'oui/non':
      case 'yes_or_no':
        return CupertinoIcons.question;
      case 'zone de texte':
      case 'textarea':
        return CupertinoIcons.text_alignleft;
      case 'fichier':
      case 'file':
        return CupertinoIcons.doc;
      case 'image':
        return CupertinoIcons.photo;
      case 'séparateur':
      case 'separator':
        return CupertinoIcons.minus;
      case 'explication':
        return CupertinoIcons.info;
      default:
        return CupertinoIcons.question_circle;
    }
  }
}
