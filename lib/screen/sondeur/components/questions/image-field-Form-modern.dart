import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:provider/provider.dart';

class ImageFieldFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const ImageFieldFormModern({super.key, required this.champ});

  @override
  State<ImageFieldFormModern> createState() => _ImageFieldFormModernState();
}

class _ImageFieldFormModernState extends State<ImageFieldFormModern>
    with TickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isRequired = false;
  bool _multipleImages = false;
  int _maxImages = 5;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.champ.nom ?? 'Télécharger une image');
    _descriptionController =
        TextEditingController(text: widget.champ.description ?? '');
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    final formulaireSondeurBloc =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);
    formulaireSondeurBloc.updateChampFormulaireNomQuestions(
        widget.champ.id!, value);
  }

  void _onDescriptionChanged(String value) {
    final formulaireSondeurBloc =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);
    formulaireSondeurBloc.updateChampFormulaireDescriptionQuestions(
        widget.champ.id!, value);
  }

  void _onDelete() {
    // TODO: Implémenter la suppression de champ dans le bloc
  }

  @override
  Widget build(BuildContext context) {
    return ModernQuestionCard(
      questionType: "Image",
      questionTitle: _titleController.text,
      isRequired: _isRequired,
      onDelete: _onDelete,
      accentColor: Colors.teal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la question
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.withOpacity(0.2)),
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
                hintText: "Titre de la question",
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description optionnelle
          TextField(
            controller: _descriptionController,
            onChanged: _onDescriptionChanged,
            decoration: InputDecoration(
              hintText: "Description (optionnelle)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.teal, width: 2),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 20),

          // Zone de drop pour images
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() => _isHovering = true);
                    _hoverController.forward();
                  },
                  onExit: (_) {
                    setState(() => _isHovering = false);
                    _hoverController.reverse();
                  },
                  child: GestureDetector(
                    onTap: () {
                      // Simuler la sélection d'image
                      _hoverController.forward().then((_) {
                        _hoverController.reverse();
                      });
                    },
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _isHovering
                              ? [
                                  Colors.teal.withOpacity(0.1),
                                  Colors.teal.withOpacity(0.05),
                                ]
                              : [
                                  Colors.grey[50]!,
                                  Colors.grey[100]!,
                                ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isHovering ? Colors.teal : Colors.grey[300]!,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: Colors.teal[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Cliquez pour sélectionner des images",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "ou glissez-déposez vos images ici",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "JPG, PNG, GIF - Max 10MB",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.teal[700],
                                fontWeight: FontWeight.w500,
                              ),
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

          const SizedBox(height: 20),

          // Options
          Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _isRequired,
                    onChanged: (value) =>
                        setState(() => _isRequired = value ?? false),
                    activeColor: Colors.teal,
                  ),
                  const Text("Champ obligatoire"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _multipleImages,
                    onChanged: (value) =>
                        setState(() => _multipleImages = value ?? false),
                    activeColor: Colors.teal,
                  ),
                  const Text("Autoriser plusieurs images"),
                ],
              ),
              if (_multipleImages) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nombre maximum d'images: $_maxImages",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.teal,
                              thumbColor: Colors.teal,
                              overlayColor: Colors.teal.withOpacity(0.2),
                            ),
                            child: Slider(
                              value: _maxImages.toDouble(),
                              min: 1,
                              max: 20,
                              divisions: 19,
                              onChanged: (value) =>
                                  setState(() => _maxImages = value.round()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
