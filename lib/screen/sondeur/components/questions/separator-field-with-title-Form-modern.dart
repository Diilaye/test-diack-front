import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:provider/provider.dart';

class SeparatorFieldWithTitleFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const SeparatorFieldWithTitleFormModern({super.key, required this.champ});

  @override
  State<SeparatorFieldWithTitleFormModern> createState() =>
      _SeparatorFieldWithTitleFormModernState();
}

class _SeparatorFieldWithTitleFormModernState
    extends State<SeparatorFieldWithTitleFormModern>
    with TickerProviderStateMixin {
  late TextEditingController _titleController;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  String _titlePosition = 'center';
  String _separatorStyle = 'solid';
  Color _separatorColor = Colors.grey;
  Color _titleColor = Colors.black87;

  final List<String> _positions = ['left', 'center', 'right'];
  final List<Map<String, dynamic>> _styles = [
    {'name': 'solid', 'label': 'Trait plein'},
    {'name': 'dashed', 'label': 'Tirets'},
    {'name': 'dotted', 'label': 'Points'},
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.champ.nom ?? 'Titre de section');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    final formulaireSondeurBloc =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);
    formulaireSondeurBloc.updateChampFormulaireNomQuestions(
        widget.champ.id!, value);
  }

  void _onDelete() {
    final formulaireSondeurBloc =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);
    formulaireSondeurBloc.deleteChampFormulaire(widget.champ.id!);
  }

  Widget _buildSeparatorLine() {
    switch (_separatorStyle) {
      case 'dashed':
        return CustomPaint(
          size: const Size(double.infinity, 2),
          painter: DashedLinePainter(color: _separatorColor),
        );
      case 'dotted':
        return CustomPaint(
          size: const Size(double.infinity, 2),
          painter: DottedLinePainter(color: _separatorColor),
        );
      default:
        return Container(
          height: 2,
          decoration: BoxDecoration(
            color: _separatorColor,
            borderRadius: BorderRadius.circular(1),
          ),
        );
    }
  }

  Widget _buildSeparatorWithTitle() {
    final title = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        _titleController.text.isEmpty
            ? 'Titre de section'
            : _titleController.text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _titleColor,
        ),
      ),
    );

    switch (_titlePosition) {
      case 'left':
        return Row(
          children: [
            title,
            const SizedBox(width: 16),
            Expanded(child: _buildSeparatorLine()),
          ],
        );
      case 'right':
        return Row(
          children: [
            Expanded(child: _buildSeparatorLine()),
            const SizedBox(width: 16),
            title,
          ],
        );
      default: // center
        return Row(
          children: [
            Expanded(child: _buildSeparatorLine()),
            title,
            Expanded(child: _buildSeparatorLine()),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModernQuestionCard(
      questionType: "Séparateur avec titre",
      questionTitle: _titleController.text,
      onDelete: _onDelete,
      accentColor: Colors.deepPurple,
      child: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 20 * (1 - _slideAnimation.value)),
            child: Opacity(
              opacity: _slideAnimation.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ titre
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.deepPurple.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _titleController,
                      onChanged: _onTitleChanged,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Titre de la section",
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Aperçu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Aperçu",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildSeparatorWithTitle(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Position du titre
                  Text(
                    "Position du titre:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: _positions
                        .map((position) => Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _titlePosition = position),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _titlePosition == position
                                        ? Colors.deepPurple
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _titlePosition == position
                                          ? Colors.deepPurple
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Text(
                                    position == 'left'
                                        ? 'Gauche'
                                        : position == 'center'
                                            ? 'Centre'
                                            : 'Droite',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _titlePosition == position
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Style du séparateur
                  Text(
                    "Style du trait:",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _styles
                        .map((style) => GestureDetector(
                              onTap: () => setState(
                                  () => _separatorStyle = style['name']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _separatorStyle == style['name']
                                      ? Colors.deepPurple
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _separatorStyle == style['name']
                                        ? Colors.deepPurple
                                        : Colors.grey[300]!,
                                  ),
                                ),
                                child: Text(
                                  style['label'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _separatorStyle == style['name']
                                        ? Colors.white
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painters pour les lignes
class DashedLinePainter extends CustomPainter {
  final Color color;

  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    const dashWidth = 8.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    const dotRadius = 1.5;
    const dotSpace = 6.0;
    double startX = dotRadius;

    while (startX < size.width) {
      canvas.drawCircle(
        Offset(startX, size.height / 2),
        dotRadius,
        paint,
      );
      startX += dotSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
