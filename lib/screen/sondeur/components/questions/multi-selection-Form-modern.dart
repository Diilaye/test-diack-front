import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/utils/rdn-id.dart';
import 'package:provider/provider.dart';
import 'base/modern_question_card.dart';
import 'base/modern_form_widgets.dart';

class MultiSelectionFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const MultiSelectionFormModern({super.key, required this.champ});

  @override
  State<MultiSelectionFormModern> createState() =>
      _MultiSelectionFormModernState();
}

class _MultiSelectionFormModernState extends State<MultiSelectionFormModern>
    with SingleTickerProviderStateMixin {
  bool isObligatoire = false;
  bool isDefaultReponse = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();

    // Initialiser les valeurs depuis le modèle
    isObligatoire = widget.champ.isObligatoire == '1';
    isDefaultReponse = widget.champ.haveResponse == '1';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);
    const accentColor = Colors.purple;

    return ModernQuestionCard(
      questionType: 'Choix multiples',
      questionTitle: widget.champ.nom ?? '',
      isRequired: isObligatoire,
      accentColor: accentColor,
      onSettings: () {
        // Toggle settings peut être géré ici si besoin
      },
      onDelete: () {
        dialogRequest(
          context: context,
          title: 'Voulez-vous supprimer ce champ ?',
        ).then((value) {
          if (value) {
            formulaireSondeurBloc.deleteChampFormulaire(widget.champ.id!);
          }
        });
      },
      onDuplicate: () {
        // Logique de duplication à implémenter
      },
      child: Column(
        children: [
          // Configuration du titre
          ModernTextField(
            initialValue: widget.champ.nom,
            placeholder: 'Entrez le titre de la question',
            label: 'Titre de la question',
            isRequired: true,
            accentColor: accentColor,
            onSubmitted: (value) {
              formulaireSondeurBloc.updateChampFormulaireNomQuestions(
                  widget.champ.id!, value);
            },
          ),

          const SizedBox(height: 16),

          // Configuration de la description
          ModernTextField(
            initialValue: widget.champ.description,
            placeholder: 'Description optionnelle de la question',
            label: 'Description',
            maxLines: 2,
            accentColor: accentColor,
            onSubmitted: (value) =>
                formulaireSondeurBloc.updateChampFormulaireDescriptionQuestions(
                    widget.champ.id!, value),
          ),

          const SizedBox(height: 20),

          // Options list
          _buildOptionsList(formulaireSondeurBloc),

          const SizedBox(height: 16),

          // Add option button
          _buildAddOptionButton(formulaireSondeurBloc),

          const SizedBox(height: 24),

          // Settings
          _buildSettingsSection(formulaireSondeurBloc),
        ],
      ),
    );
  }

  Widget _buildOptionsList(FormulaireSondeurBloc formulaireSondeurBloc) {
    if (widget.champ.listeOptions == null ||
        widget.champ.listeOptions!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              'Aucune option ajoutée',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: widget.champ.listeOptions!.asMap().entries.map((entry) {
        int index = entry.key;
        var option = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: _buildOptionField(option, index, formulaireSondeurBloc),
        );
      }).toList(),
    );
  }

  Widget _buildOptionField(
      dynamic option, int index, FormulaireSondeurBloc formulaireSondeurBloc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // Handle de réordonnement
            Icon(
              Icons.drag_indicator,
              size: 16,
              color: Colors.grey.withOpacity(0.5),
            ),

            const SizedBox(width: 12),

            // Checkbox (non fonctionnelle pour la preview)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child:
                  const Icon(Icons.check, size: 16, color: Colors.transparent),
            ),

            const SizedBox(width: 12),

            // Champ d'édition de l'option - édition inline
            Expanded(
              child: ModernTextField(
                initialValue: option.option,
                placeholder: 'Saisissez une option',
                accentColor: Colors.purple,
                onSubmitted: (value) {
                  formulaireSondeurBloc.addChampFormulaireResponseMultiChoice(
                    widget.champ.id!,
                    option.id!,
                    value,
                    'false',
                  );
                },
              ),
            ),

            const SizedBox(width: 8),

            // Delete button
            GestureDetector(
              onTap: () {
                if (widget.champ.listeOptions!.length > 1) {
                  formulaireSondeurBloc.addChampFormulaireResponseMultiChoice(
                    widget.champ.id!,
                    option.id!,
                    option.option ?? '',
                    'true', // Marquer pour suppression
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (widget.champ.listeOptions!.length <= 1)
                      ? Colors.grey.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.delete,
                  size: 14,
                  color: (widget.champ.listeOptions!.length <= 1)
                      ? Colors.grey
                      : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOptionButton(FormulaireSondeurBloc formulaireSondeurBloc) {
    bool canAddOption = widget.champ.listeOptions == null ||
        widget.champ.listeOptions!.length < 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: canAddOption
              ? () {
                  // Ajouter une nouvelle option avec un ID unique
                  formulaireSondeurBloc.addChampFormulaireResponseMultiChoice(
                    widget.champ.id!,
                    makeId(20),
                    'Nouvelle option',
                    'false',
                  );
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color:
                  canAddOption ? Colors.purple.shade50 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: canAddOption
                    ? Colors.purple.shade200
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 18,
                  color: canAddOption
                      ? Colors.purple.shade700
                      : Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ajouter une option',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: canAddOption
                        ? Colors.purple.shade700
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!canAddOption)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Nombre maximum d\'options atteint (10)',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(FormulaireSondeurBloc formulaireSondeurBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Question obligatoire
        _buildToggleOption(
          title: 'Question obligatoire',
          subtitle: 'L\'utilisateur doit répondre à cette question',
          value: isObligatoire,
          onChanged: (value) {
            formulaireSondeurBloc.updateChampFormulaireObligatoireQuestions(
              widget.champ.id!,
              value ? '1' : '0',
            );
            setState(() {
              isObligatoire = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // Réponse par défaut
        _buildToggleOption(
          title: 'Réponse par défaut',
          subtitle: 'Permettre de présélectionner des options',
          value: isDefaultReponse,
          onChanged: (value) {
            formulaireSondeurBloc.updateChampFormulaireHaveReponseQuestions(
              widget.champ.id!,
              value ? '1' : '0',
            );
            setState(() {
              isDefaultReponse = value;
            });
          },
        ),

        const SizedBox(height: 16),

        // Validation automatique activée par défaut
        // Les contrôles de validation avancée sont simplifiés
      ],
    );
  }
}
