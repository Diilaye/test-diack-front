import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_form_widgets.dart';
import 'package:provider/provider.dart';

class EmailFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;
  const EmailFormModern({super.key, required this.champ});

  @override
  State<EmailFormModern> createState() => _EmailFormModernState();
}

class _EmailFormModernState extends State<EmailFormModern>
    with TickerProviderStateMixin {
  bool isOpenSetting = false;
  bool isObligatoire = false;

  late AnimationController _settingsController;
  late Animation<double> _settingsHeightAnimation;

  @override
  void initState() {
    super.initState();

    isObligatoire = widget.champ.isObligatoire == '1';

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
    const accentColor = Color(0xFF3B82F6);

    return ModernQuestionCard(
      questionType: 'Adresse e-mail',
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
            placeholder: 'Ex: Quelle est votre adresse e-mail ?',
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
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
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

          // Aperçu du champ email
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SvgPicture.asset(
                    "assets/images/email.svg",
                    height: 18,
                    width: 18,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'exemple@email.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  size: 20,
                  color: Colors.green.withOpacity(0.7),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Indicateur de validation
          Row(
            children: [
              Icon(
                CupertinoIcons.info_circle,
                size: 14,
                color: const Color(0xFF3B82F6).withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                'Validation automatique de l\'adresse e-mail',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF3B82F6).withOpacity(0.7),
                ),
              ),
            ],
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
          color: const Color(0xFF3B82F6).withOpacity(0.1),
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

          // Option obligatoire
          _buildToggleOption(
            title: 'Champ obligatoire',
            subtitle: 'L\'utilisateur doit saisir une adresse e-mail valide',
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

          // Options de validation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_shield,
                      size: 20,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Validation automatique',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Format d\'e-mail valide (nom@domaine.com)\n'
                  '• Vérification de la syntaxe en temps réel\n'
                  '• Message d\'erreur automatique si format invalide',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Champ de placeholder personnalisé
          ModernTextField(
            placeholder: 'Ex: Saisissez votre adresse e-mail...',
            label: 'Texte d\'aide (placeholder)',
            accentColor: const Color(0xFF3B82F6),
          ),
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
              ? const Color(0xFF3B82F6).withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
        ),
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
              activeColor: const Color(0xFF3B82F6),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
