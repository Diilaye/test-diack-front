import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';

class ExplanationFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const ExplanationFormModern({super.key, required this.champ});

  @override
  State<ExplanationFormModern> createState() => _ExplanationFormModernState();
}

class _ExplanationFormModernState extends State<ExplanationFormModern>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.champ.nom ?? '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    final formulaireSondeurBloc =
        Provider.of<FormulaireSondeurBloc>(context, listen: false);
    formulaireSondeurBloc.updateChampFormulaireNomQuestions(
        widget.champ.id!, value);
  }

  void _onDelete() {
    dialogRequest(context: context, title: 'Voulez-vous supprimer ce champ ?')
        .then((value) {
      if (value) {
        final formulaireSondeurBloc =
            Provider.of<FormulaireSondeurBloc>(context, listen: false);
        formulaireSondeurBloc.deleteChampFormulaire(widget.champ.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModernQuestionCard(
      questionType: "Explication",
      questionTitle: "Zone d'explication",
      onDelete: _onDelete,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec icône et titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.orange[700],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Zone d'explication",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Zone de texte
          GestureDetector(
            onTap: () => setState(() => _isEditing = true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isEditing ? Colors.white : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isEditing ? Colors.orange : Colors.grey[300]!,
                  width: _isEditing ? 2 : 1,
                ),
                boxShadow: _isEditing
                    ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: _isEditing
                  ? TextField(
                      controller: _textController,
                      maxLines: 6,
                      minLines: 6,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Saisissez votre texte d'explication...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      onChanged: _onTextChanged,
                      onTapOutside: (_) => setState(() => _isEditing = false),
                      autofocus: true,
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Text(
                        _textController.text.isEmpty
                            ? "Cliquez pour ajouter votre texte d'explication..."
                            : _textController.text,
                        style: TextStyle(
                          fontSize: 14,
                          color: _textController.text.isEmpty
                              ? Colors.grey[500]
                              : Colors.grey[800],
                          height: 1.5,
                          fontStyle: _textController.text.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),
            ),
          ),

          if (!_isEditing && _textController.text.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  "Cliquez pour modifier",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
