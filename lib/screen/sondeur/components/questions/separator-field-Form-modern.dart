import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:provider/provider.dart';

class SeparatorFieldFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const SeparatorFieldFormModern({super.key, required this.champ});

  @override
  State<SeparatorFieldFormModern> createState() =>
      _SeparatorFieldFormModernState();
}

class _SeparatorFieldFormModernState extends State<SeparatorFieldFormModern>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  String _selectedStyle = 'solid';
  Color _selectedColor = Colors.grey;

  final List<Map<String, dynamic>> _separatorStyles = [
    {'name': 'solid', 'label': 'Trait plein', 'icon': Icons.horizontal_rule},
    {'name': 'dashed', 'label': 'Trait tirets', 'icon': Icons.more_horiz},
    {'name': 'dotted', 'label': 'Trait pointillés', 'icon': Icons.more_horiz},
    {'name': 'gradient', 'label': 'Dégradé', 'icon': Icons.gradient},
  ];

  final List<Color> _colors = [
    Colors.grey,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDelete() {
    final formulaireSondeurBloc =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);
    formulaireSondeurBloc.deleteChampFormulaire(widget.champ.id!);
  }

  Widget _buildSeparator() {
    switch (_selectedStyle) {
      case 'solid':
        return Container(
          height: 2,
          decoration: BoxDecoration(
            color: _selectedColor,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      case 'dashed':
        return CustomPaint(
          size: const Size(double.infinity, 2),
          painter: DashedLinePainter(color: _selectedColor),
        );
      case 'dotted':
        return CustomPaint(
          size: const Size(double.infinity, 2),
          painter: DottedLinePainter(color: _selectedColor),
        );
      case 'gradient':
        return Container(
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _selectedColor.withOpacity(0.0),
                _selectedColor,
                _selectedColor.withOpacity(0.0),
              ],
            ),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      default:
        return Container(height: 2, color: _selectedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModernQuestionCard(
      questionType: "Séparateur",
      questionTitle: "Ligne de séparation",
      onDelete: _onDelete,
      accentColor: Colors.indigo,
      height: 180,
      child: AnimatedBuilder(
        animation: _opacityAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Aperçu du séparateur
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo.withOpacity(0.2)),
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
                      const SizedBox(height: 16),
                      _buildSeparator(),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Style du séparateur
                Text(
                  "Style:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _separatorStyles
                      .map((style) => GestureDetector(
                            onTap: () =>
                                setState(() => _selectedStyle = style['name']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedStyle == style['name']
                                    ? Colors.indigo
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedStyle == style['name']
                                      ? Colors.indigo
                                      : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    style['icon'],
                                    size: 16,
                                    color: _selectedStyle == style['name']
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    style['label'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedStyle == style['name']
                                          ? Colors.white
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Couleur
                Text(
                  "Couleur:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _colors
                      .map((color) => GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _selectedColor == color
                                      ? Colors.black87
                                      : Colors.grey[300]!,
                                  width: _selectedColor == color ? 3 : 1,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom painters pour les lignes personnalisées
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
