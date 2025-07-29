import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/rdn-id.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_form_widgets.dart';
import 'package:provider/provider.dart';

class SingleSelectionFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;
  const SingleSelectionFormModern({super.key, required this.champ});

  @override
  State<SingleSelectionFormModern> createState() =>
      _SingleSelectionFormModernState();
}

class _SingleSelectionFormModernState extends State<SingleSelectionFormModern>
    with TickerProviderStateMixin {
  bool isOpenSetting = false;
  bool isObligatoire = false;
  bool isDefaultReponse = false;
  int selectedPreviewIndex = 0;

  late AnimationController _settingsController;
  late Animation<double> _settingsHeightAnimation;

  @override
  void initState() {
    super.initState();

    isObligatoire = widget.champ.isObligatoire == '1';
    isDefaultReponse = widget.champ.haveResponse == '1';

    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _settingsHeightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _settingsController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _settingsController.dispose();
    super.dispose();
  }

  void _toggleSettings() {
    setState(() {
      isOpenSetting = !isOpenSetting;
    });

    if (isOpenSetting) {
      _settingsController.forward();
    } else {
      _settingsController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeurBloc = Provider.of<FormulaireSondeurBloc>(context);
    const accentColor = Color(0xFF10B981);

    return ModernQuestionCard(
      questionType: 'Choix unique',
      questionTitle: widget.champ.nom ?? '',
      isRequired: isObligatoire,
      accentColor: accentColor,
      onSettings: _toggleSettings,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Configuration du titre de la question
          ModernTextField(
            initialValue: widget.champ.nom,
            placeholder: 'Ex: Quel est votre niveau de satisfaction ?',
            label: 'Question',
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

          // Gestion des options
          _buildOptionsSection(formulaireSondeurBloc),

          const SizedBox(height: 20),

          // Aperçu du champ
          _buildPreview(),

          // Paramètres avancés
          AnimatedBuilder(
            animation: _settingsHeightAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _settingsHeightAnimation.value,
                  child: child,
                ),
              );
            },
            child: _buildAdvancedSettings(formulaireSondeurBloc),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(FormulaireSondeurBloc formulaireSondeurBloc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.list_bullet,
                size: 18,
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              const Text(
                'Options de réponse',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Ajouter une nouvelle option
                  formulaireSondeurBloc.addChampFormulaireResponseMultiChoice(
                    widget.champ.id!,
                    makeId(20),
                    'Nouvelle option',
                    'false',
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Ajouter option',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Liste des options
          if (widget.champ.listeOptions?.isNotEmpty == true)
            ...widget.champ.listeOptions!.asMap().entries.map((entry) {
              final option = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    // Handle de réordonnement
                    Icon(
                      CupertinoIcons.bars,
                      size: 16,
                      color: Colors.grey.withOpacity(0.5),
                    ),

                    const SizedBox(width: 12),

                    // Champ d'édition de l'option
                    Expanded(
                      child: ModernTextField(
                        initialValue: option.option,
                        placeholder: 'Saisissez une option',
                        accentColor: const Color(0xFF10B981),
                        onSubmitted: (value) => formulaireSondeurBloc
                            .addChampFormulaireResponseMultiChoice(
                          widget.champ.id!,
                          option.id!,
                          value,
                          'false',
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Actions
                    GestureDetector(
                      onTap: () {
                        formulaireSondeurBloc
                            .addChampFormulaireResponseMultiChoice(
                          widget.champ.id!,
                          option.id!,
                          option.option ?? '',
                          'true',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          CupertinoIcons.delete,
                          size: 14,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          // Message si aucune option
          if (widget.champ.listeOptions?.isEmpty != false)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.info_circle,
                    size: 16,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Aucune option ajoutée. Cliquez sur "Ajouter" pour créer des options.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.eye,
                size: 16,
                color: Colors.grey.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Aperçu',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Aperçu des options
          if (widget.champ.listeOptions?.isNotEmpty == true)
            ...widget.champ.listeOptions!.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;

              return ModernChoiceOption(
                text: option.option ?? 'Option ${index + 1}',
                isSelected: selectedPreviewIndex == index,
                isMultiple: false,
                accentColor: const Color(0xFF10B981),
                onTap: () {
                  setState(() {
                    selectedPreviewIndex = index;
                  });
                },
              );
            })
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.question_circle,
                    size: 16,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ajoutez des options pour voir l\'aperçu',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(FormulaireSondeurBloc formulaireSondeurBloc) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paramètres avancés',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 20),

          // Options de configuration
          Row(
            children: [
              Expanded(
                child: _buildToggleOption(
                  title: 'Choix obligatoire',
                  subtitle: 'L\'utilisateur doit sélectionner une option',
                  value: isObligatoire,
                  onChanged: (value) {
                    formulaireSondeurBloc
                        .updateChampFormulaireObligatoireQuestions(
                      widget.champ.id!,
                      value ? '1' : '0',
                    );
                    setState(() {
                      isObligatoire = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildToggleOption(
                  title: 'Option pré-sélectionnée',
                  subtitle: 'Une option sera sélectionnée par défaut',
                  value: isDefaultReponse,
                  onChanged: (value) {
                    formulaireSondeurBloc
                        .updateChampFormulaireHaveReponseQuestions(
                      widget.champ.id!,
                      value ? '1' : '0',
                    );
                    setState(() {
                      isDefaultReponse = value;
                    });
                  },
                ),
              ),
            ],
          ),

          if (isDefaultReponse &&
              widget.champ.listeOptions?.isNotEmpty == true) ...[
            const SizedBox(height: 20),

            // Sélection de l'option par défaut
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Option pré-sélectionnée',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    hint: const Text('Sélectionnez l\'option par défaut'),
                    items: widget.champ.listeOptions!.map((option) {
                      return DropdownMenuItem<String>(
                        value: option.id,
                        child: Text(option.option ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      // Mettre à jour l'option par défaut
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value
              ? const Color(0xFF10B981).withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: CupertinoSwitch(
                  value: value,
                  activeColor: const Color(0xFF10B981),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
