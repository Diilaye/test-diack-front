import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Widget moderne pour les champs de texte des questions
class ModernTextField extends StatefulWidget {
  final String? initialValue;
  final String? placeholder;
  final String? label;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool isRequired;
  final bool isEnabled;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? accentColor;

  const ModernTextField({
    super.key,
    this.initialValue,
    this.placeholder,
    this.label,
    this.onChanged,
    this.onSubmitted,
    this.isRequired = false,
    this.isEnabled = true,
    this.maxLines = 1,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.accentColor,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  late TextEditingController _textController;

  bool _isFocused = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    _focusController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeOutCubic,
    ));

    _textController = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _focusController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });

    if (hasFocus) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor ?? const Color(0xFF6366F1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(
                widget.label!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              if (widget.isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
        ],
        AnimatedBuilder(
          animation: _focusAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasError
                      ? Colors.red
                      : _isFocused
                          ? accentColor
                          : Colors.grey.withOpacity(0.3),
                  width: _isFocused ? 2 : 1,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          offset: const Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 4,
                          color: accentColor.withOpacity(0.1),
                        ),
                      ]
                    : null,
              ),
              child: Focus(
                onFocusChange: _onFocusChange,
                child: TextField(
                  controller: _textController,
                  enabled: widget.isEnabled,
                  maxLines: widget.maxLines,
                  keyboardType: widget.keyboardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.prefixIcon != null ? 12 : 16,
                      vertical: widget.maxLines == 1 ? 16 : 12,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  },
                  onSubmitted: (value) {
                    if (widget.onSubmitted != null) {
                      widget.onSubmitted!(value);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Widget pour les options de choix multiples/uniques
class ModernChoiceOption extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool isMultiple;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Color? accentColor;

  const ModernChoiceOption({
    super.key,
    required this.text,
    this.isSelected = false,
    this.isMultiple = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.accentColor,
  });

  @override
  State<ModernChoiceOption> createState() => _ModernChoiceOptionState();
}

class _ModernChoiceOptionState extends State<ModernChoiceOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
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
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? accentColor.withOpacity(0.1)
                      : _isHovered
                          ? Colors.grey.withOpacity(0.05)
                          : Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected
                        ? accentColor
                        : Colors.grey.withOpacity(0.2),
                    width: widget.isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Indicateur de sélection
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? accentColor
                            : Colors.transparent,
                        border: Border.all(
                          color: widget.isSelected
                              ? accentColor
                              : Colors.grey.withOpacity(0.4),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          widget.isMultiple ? 4 : 10,
                        ),
                      ),
                      child: widget.isSelected
                          ? Icon(
                              widget.isMultiple
                                  ? CupertinoIcons.checkmark
                                  : CupertinoIcons.circle_filled,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),

                    const SizedBox(width: 12),

                    // Texte de l'option
                    Expanded(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: widget.isSelected
                              ? accentColor
                              : const Color(0xFF374151),
                        ),
                      ),
                    ),

                    // Actions (edit/delete) visibles au hover
                    if (_isHovered) ...[
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.onEdit != null)
                            GestureDetector(
                              onTap: widget.onEdit,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  CupertinoIcons.pencil,
                                  size: 12,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          if (widget.onDelete != null) ...[
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: widget.onDelete,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  size: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
