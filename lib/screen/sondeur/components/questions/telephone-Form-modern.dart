import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/champs-formulaire-model.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_question_card.dart';
import 'package:form/screen/sondeur/components/questions/base/modern_form_widgets.dart';
import 'package:provider/provider.dart';

class TelephoneFormModern extends StatefulWidget {
  final ChampsFormulaireModel champ;
  const TelephoneFormModern({super.key, required this.champ});

  @override
  State<TelephoneFormModern> createState() => _TelephoneFormModernState();
}

class _TelephoneFormModernState extends State<TelephoneFormModern>
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
    const accentColor = Color(0xFF059669);

    return ModernQuestionCard(
      questionType: 'Numéro de téléphone',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernTextField(
            initialValue: widget.champ.nom,
            placeholder: 'Ex: Quel est votre numéro de téléphone ?',
            label: 'Question',
            isRequired: true,
            accentColor: accentColor,
            onSubmitted: (value) => formulaireSondeurBloc
                .updateChampFormulaireNomQuestions(widget.champ.id!, value),
          ),
          const SizedBox(height: 16),
          ModernTextField(
            initialValue: widget.champ.description,
            placeholder: 'Description optionnelle',
            label: 'Description',
            maxLines: 2,
            accentColor: accentColor,
            onSubmitted: (value) =>
                formulaireSondeurBloc.updateChampFormulaireDescriptionQuestions(
                    widget.champ.id!, value),
          ),
          const SizedBox(height: 20),
          _buildPreview(),
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
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF059669).withOpacity(0.2),
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF059669).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SvgPicture.asset(
                    "assets/images/telephone.svg",
                    height: 18,
                    width: 18,
                    color: const Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '+33 6 12 34 56 78',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  size: 20,
                  color: Colors.green.withOpacity(0.7),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                CupertinoIcons.info_circle,
                size: 14,
                color: const Color(0xFF059669).withOpacity(0.7),
              ),
              const SizedBox(width: 6),
              Text(
                'Validation automatique du format téléphone',
                style: TextStyle(
                  fontSize: 11,
                  color: const Color(0xFF059669).withOpacity(0.7),
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
          color: const Color(0xFF059669).withOpacity(0.1),
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
          _buildToggleOption(
            title: 'Champ obligatoire',
            subtitle: 'L\'utilisateur doit saisir un numéro valide',
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF059669).withOpacity(0.1),
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
                      color: const Color(0xFF059669),
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
                  '• Format français (+33) et international\n'
                  '• Vérification de la longueur du numéro\n'
                  '• Formatage automatique lors de la saisie',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
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
              ? const Color(0xFF059669).withOpacity(0.2)
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
              activeColor: const Color(0xFF059669),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
