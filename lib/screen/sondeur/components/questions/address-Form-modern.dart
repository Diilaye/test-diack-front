import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:provider/provider.dart';
import 'base/modern_question_card.dart';
import 'base/modern_form_widgets.dart';

class AddressFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;

  const AddressFormModern({super.key, required this.champ});

  @override
  State<AddressFormModern> createState() => _AddressFormModernState();
}

class _AddressFormModernState extends State<AddressFormModern>
    with SingleTickerProviderStateMixin {
  bool isObligatoire = false;
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);
    const accentColor = Color(0xFF059669);

    return ModernQuestionCard(
      questionType: 'Adresse',
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
            onSubmitted: (value) => formulaireSondeurBloc
                .updateChampFormulaireNomQuestions(widget.champ.id!, value),
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

          // Aperçu du champ
          _buildPreview(),

          const SizedBox(height: 20),

          // Paramètres
          _buildSettingsSection(formulaireSondeurBloc),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                'Aperçu',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Champ adresse
          _buildPreviewField('Adresse complète'),

          const SizedBox(height: 12),

          // Ville et Code postal
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildPreviewField('Ville'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPreviewField('Code postal'),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Pays
          _buildPreviewField('Pays'),
        ],
      ),
    );
  }

  Widget _buildPreviewField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
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
            activeColor: const Color(0xFF059669),
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
          subtitle: 'L\'utilisateur doit remplir ce champ',
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
      ],
    );
  }
}
