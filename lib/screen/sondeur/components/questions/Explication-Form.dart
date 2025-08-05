import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';

class ExplicationForm extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const ExplicationForm({super.key, required this.champ});

  @override
  State<ExplicationForm> createState() => _ExplicationFormState();
}

class _ExplicationFormState extends State<ExplicationForm> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.champ.nom ?? '');
    _descriptionController = TextEditingController(text: widget.champ.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec bouton de suppression
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.info_circle,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Texte d\'explication',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => dialogRequest(
                    context: context, 
                    title: 'Voulez-vous supprimer ce texte d\'explication ?'
                  ).then((value) {
                    if (value) {
                      formulaireSondeurBloc.deleteChampFormulaire(widget.champ.id!);
                    }
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Icon(
                      CupertinoIcons.delete,
                      size: 16,
                      color: Colors.red.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Champ de titre
            TextField(
              controller: _titleController,
              onChanged: (value) {
                formulaireSondeurBloc.updateChampFormulaireNomQuestions(
                  widget.champ.id!, 
                  value
                );
              },
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Titre de l\'explication...',
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            // Champ de description
            TextField(
              controller: _descriptionController,
              onChanged: (value) {
                formulaireSondeurBloc.updateChampFormulaireDescriptionQuestions(
                  widget.champ.id!, 
                  value
                );
              },
              maxLines: 5,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Ajoutez votre texte d\'explication ici...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
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
                  borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
