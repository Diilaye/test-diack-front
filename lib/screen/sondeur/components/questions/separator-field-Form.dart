import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';

class SeparatorFielForm extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const SeparatorFielForm({super.key, required this.champ});

  @override
  State<SeparatorFielForm> createState() => _SeparatorFielFormState();
}

class _SeparatorFielFormState extends State<SeparatorFielForm> {
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
          children: [
            // Header avec bouton de suppression
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.minus_rectangle,
                        size: 16,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Séparateur',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange.shade700,
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
            // Ligne de séparation moderne
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.grey.shade300,
                    Colors.grey.shade400,
                    Colors.grey.shade300,
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
