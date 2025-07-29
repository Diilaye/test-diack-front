import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';
import 'base/modern_question_card.dart';

class YesOrNoFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const YesOrNoFormModern({super.key, required this.champ});

  @override
  State<YesOrNoFormModern> createState() => _YesOrNoFormModernState();
}

class _YesOrNoFormModernState extends State<YesOrNoFormModern>
    with SingleTickerProviderStateMixin {
  bool isObligatoire = false;
  bool isDefaultReponse = false;
  String? selectedOption;
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

    // Vérifier s'il y a une réponse par défaut
    if (widget.champ.listeOptions != null &&
        widget.champ.listeOptions!.isNotEmpty) {
      // Dans ce contexte, on cherche juste la première option pour simplicité
      // car Yes/No n'a que 2 options max
      if (widget.champ.listeOptions!.length > 0) {
        selectedOption =
            'Oui'; // Par défaut, on considère la première comme "Oui"
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);
    const accentColor = Colors.orange;

    return ModernQuestionCard(
      questionType: 'Oui / Non',
      questionTitle: widget.champ.nom ?? '',
      isRequired: isObligatoire,
      accentColor: accentColor,
      onQuestionTitleChanged: (newTitle) {
        formulaireSondeurBloc.updateChampFormulaireNomQuestions(
          widget.champ.id!,
          newTitle,
        );
      },
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
          // Yes/No options
          _buildYesNoOptions(formulaireSondeurBloc),

          const SizedBox(height: 24),

          // Settings
          _buildSettingsSection(formulaireSondeurBloc),
        ],
      ),
    );
  }

  Widget _buildYesNoOptions(FormulaireSondeurBloc formulaireSondeurBloc) {
    return Column(
      children: [
        // Option Oui
        _buildOptionTile(
          'Oui',
          Icons.check_circle_outline,
          Colors.green,
          formulaireSondeurBloc,
        ),

        const SizedBox(height: 12),

        // Option Non
        _buildOptionTile(
          'Non',
          Icons.cancel_outlined,
          Colors.red,
          formulaireSondeurBloc,
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    String option,
    IconData icon,
    Color color,
    FormulaireSondeurBloc formulaireSondeurBloc,
  ) {
    final bool isSelected = selectedOption == option;
    final bool canSelect = isDefaultReponse;

    return GestureDetector(
      onTap: canSelect
          ? () {
              setState(() {
                selectedOption = isSelected ? null : option;
              });

              // Mettre à jour les options dans le bloc
              _updateSelection(formulaireSondeurBloc, option, !isSelected);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected && canSelect
              ? color.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected && canSelect ? color : Colors.grey.shade300,
            width: isSelected && canSelect ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected && canSelect ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected && canSelect ? color : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected && canSelect
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Icon(
              icon,
              color: isSelected && canSelect ? color : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected && canSelect ? color : Colors.black87,
              ),
            ),
            const Spacer(),
            if (!canSelect)
              Text(
                'Aperçu',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateSelection(FormulaireSondeurBloc formulaireSondeurBloc,
      String option, bool isSelected) {
    // Pour Yes/No, on utilise des méthodes simples du bloc car c'est un cas particulier
    // qui n'a besoin que de 2 options fixes
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
            activeColor: Colors.blue,
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
          subtitle: 'Présélectionner une option',
          value: isDefaultReponse,
          onChanged: (value) {
            formulaireSondeurBloc.updateChampFormulaireHaveReponseQuestions(
              widget.champ.id!,
              value ? '1' : '0',
            );
            setState(() {
              isDefaultReponse = value;
              if (!value) {
                selectedOption = null;
              }
            });
          },
        ),

        if (isDefaultReponse) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cliquez sur une option pour la présélectionner',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
