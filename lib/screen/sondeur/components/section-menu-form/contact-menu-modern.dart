import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:provider/provider.dart';

class ContactSectionMenu extends StatelessWidget {
  const ContactSectionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Informations de contact",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ..._buildContactFields(formulaireSondeur),
      ],
    );
  }

  List<Widget> _buildContactFields(FormulaireSondeurBloc formulaireSondeur) {
    final fields = [
      {
        'text': 'Nom complet',
        'subtitle': 'Prénom et nom',
        'iconData': 'assets/images/person.svg',
        'color': const Color(0xFF3B82F6),
        'onpress': () async {
          formulaireSondeur.addChampFormulaireType(
              formulaireSondeur.formulaireSondeurModel!.id!, "nomComplet");
        },
      },
      {
        'text': 'Adresse email',
        'subtitle': 'Adresse électronique',
        'iconData': 'assets/images/email.svg',
        'color': const Color(0xFFF59E0B),
        'onpress': () async {
          formulaireSondeur.addChampFormulaireType(
              formulaireSondeur.formulaireSondeurModel!.id!, "email");
        },
      },
      {
        'text': 'Adresse postale',
        'subtitle': 'Adresse complète',
        'iconData': 'assets/images/address.svg',
        'color': const Color(0xFF8B5CF6),
        'onpress': () async {
          formulaireSondeur.addChampFormulaireType(
              formulaireSondeur.formulaireSondeurModel!.id!, "addresse");
        },
      },
      {
        'text': 'Numéro de téléphone',
        'subtitle': 'Téléphone mobile ou fixe',
        'iconData': 'assets/images/telephone.svg',
        'color': const Color(0xFF10B981),
        'onpress': () async {
          formulaireSondeur.addChampFormulaireType(
              formulaireSondeur.formulaireSondeurModel!.id!, "telephone");
        },
      },
    ];

    return fields.map((field) => _buildModernFieldItem(field)).toList();
  }

  Widget _buildModernFieldItem(Map<String, dynamic> field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => field['onpress'](),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (field['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset(
                    field['iconData'],
                    color: field['color'],
                    width: 20,
                    height: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field['text'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Rubik',
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        field['subtitle'],
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Rubik',
                          color: Colors.grey[600],
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.add,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
