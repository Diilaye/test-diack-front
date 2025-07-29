import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/rdn-id.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_form_widgets.dart';
import 'package:provider/provider.dart';

class TextFieldFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;
  const TextFieldFormModern({super.key, required this.champ});

  @override
  State<TextFieldFormModern> createState() => _TextFieldFormModernState();
}

class _TextFieldFormModernState extends State<TextFieldFormModern>
    with TickerProviderStateMixin {
  bool isOpenSetting = false;
  bool isObligatoire = false;
  bool isDefaultReponse = false;

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
    const accentColor = Color(0xFF6366F1);

    return ModernQuestionCard(
      questionType: 'Champ de texte',
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
            placeholder: 'Titre de la question',
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

          // Aperçu du champ de texte
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/images/text-fields.svg",
                  height: 20,
                  width: 20,
                  color: const Color(0xFF6366F1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Zone de saisie de texte',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.withOpacity(0.6),
                    ),
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
          color: const Color(0xFF6366F1).withOpacity(0.1),
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
                  title: 'Champ obligatoire',
                  subtitle: 'L\'utilisateur doit remplir ce champ',
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
                  title: 'Réponse par défaut',
                  subtitle: 'Pré-remplir le champ avec une valeur',
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

          const SizedBox(height: 20),

          // Champ de placeholder
          ModernTextField(
            placeholder: 'Ex: Saisissez votre réponse ici...',
            label: 'Texte d\'aide (placeholder)',
            accentColor: const Color(0xFF6366F1),
          ),

          if (isDefaultReponse) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ModernTextField(
                    initialValue: widget.champ.listeReponses?.isNotEmpty == true
                        ? widget.champ.listeReponses![0].option
                        : '',
                    placeholder: 'Valeur par défaut',
                    label: 'Réponse par défaut',
                    accentColor: const Color(0xFF6366F1),
                    onSubmitted: (value) => formulaireSondeurBloc
                        .addChampFormulaireResponseTextField(
                            widget.champ.id!, makeId(20), value),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 120,
                  child: ModernTextField(
                    initialValue: widget.champ.notes,
                    placeholder: '0-100',
                    label: 'Note/Score',
                    keyboardType: TextInputType.number,
                    accentColor: const Color(0xFF6366F1),
                    onSubmitted: (value) => formulaireSondeurBloc
                        .updateChampFormulaireNotesQuestions(
                            widget.champ.id!, value),
                  ),
                ),
              ],
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
              ? const Color(0xFF6366F1).withOpacity(0.2)
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
                  activeColor: const Color(0xFF6366F1),
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
