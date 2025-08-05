import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';

class SeparatorFielWithTitleForm extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const SeparatorFielWithTitleForm({super.key, required this.champ});

  @override
  State<SeparatorFielWithTitleForm> createState() =>
      _SeparatorFielWithTitleFormState();
}

class _SeparatorFielWithTitleFormState
    extends State<SeparatorFielWithTitleForm> {
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.champ.nom ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                    color: btnColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: btnColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.textformat,
                        size: 16,
                        color: btnColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Séparateur avec titre',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: btnColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => dialogRequest(
                    context: context, 
                    title: 'Voulez-vous supprimer ce séparateur ?'
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Titre du séparateur...',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            const SizedBox(height: 16),
            // Ligne de séparation moderne
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    btnColor.withOpacity(0.3),
                    btnColor,
                    btnColor.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
