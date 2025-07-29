import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:provider/provider.dart';

class FileFieldFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const FileFieldFormModern({super.key, required this.champ});

  @override
  State<FileFieldFormModern> createState() => _FileFieldFormModernState();
}

class _FileFieldFormModernState extends State<FileFieldFormModern>
    with TickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isRequired = false;
  bool _multipleFiles = false;
  List<String> _allowedTypes = ['PDF', 'DOC', 'JPG', 'PNG'];
  late AnimationController _dragController;
  late Animation<double> _scaleAnimation;
  bool _isDragOver = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.champ.nom ?? 'Télécharger un fichier');
    _descriptionController =
        TextEditingController(text: widget.champ.description ?? '');
    _dragController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _dragController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dragController.dispose();
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

  void _toggleFileType(String type) {
    setState(() {
      if (_allowedTypes.contains(type)) {
        _allowedTypes.remove(type);
      } else {
        _allowedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModernQuestionCard(
      questionType: "Fichier",
      questionTitle: _titleController.text,
      isRequired: _isRequired,
      onDelete: _onDelete,
      accentColor: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la question
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.withOpacity(0.2)),
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
                borderSide: const BorderSide(color: Colors.purple, width: 2),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 2,
          ),

          const SizedBox(height: 20),

          // Zone de drop
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: () {
                    // Simuler la sélection de fichier
                    _dragController.forward().then((_) {
                      _dragController.reverse();
                    });
                  },
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: _isDragOver
                          ? Colors.purple.withOpacity(0.1)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isDragOver ? Colors.purple : Colors.grey[300]!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            size: 32,
                            color: Colors.purple[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Cliquez pour sélectionner",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "ou glissez-déposez vos fichiers ici",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Types de fichiers autorisés
          Text(
            "Types de fichiers autorisés:",
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
            children: ['PDF', 'DOC', 'DOCX', 'JPG', 'PNG', 'TXT', 'XLS', 'XLSX']
                .map((type) => GestureDetector(
                      onTap: () => _toggleFileType(type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _allowedTypes.contains(type)
                              ? Colors.purple
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _allowedTypes.contains(type)
                                ? Colors.purple
                                : Colors.grey[400]!,
                          ),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _allowedTypes.contains(type)
                                ? Colors.white
                                : Colors.grey[700],
                          ),
                        ),
                      ),
                    ))
                .toList(),
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
                    activeColor: Colors.purple,
                  ),
                  const Text("Champ obligatoire"),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _multipleFiles,
                    onChanged: (value) =>
                        setState(() => _multipleFiles = value ?? false),
                    activeColor: Colors.purple,
                  ),
                  const Text("Autoriser plusieurs fichiers"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
