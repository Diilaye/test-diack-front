import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:provider/provider.dart';

class TelechargementSectionMenu extends StatefulWidget {
  const TelechargementSectionMenu({super.key});

  @override
  State<TelechargementSectionMenu> createState() =>
      _TelechargementSectionMenuState();
}

class _TelechargementSectionMenuState extends State<TelechargementSectionMenu>
    with SingleTickerProviderStateMixin {
  bool isOpen = true;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (isOpen) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSection() {
    setState(() {
      isOpen = !isOpen;
    });
    if (isOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleSection,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.file_upload_rounded,
                        color: const Color(0xFFEF4444),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Téléchargements",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159,
                          child: Icon(
                            CupertinoIcons.chevron_down,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isOpen ? null : 0,
            child: isOpen
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey[100],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Champs de fichiers",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._buildUploadFields(formulaireSondeur),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUploadFields(FormulaireSondeurBloc formulaireSondeur) {
    final fields = [
      {
        'text': 'Image',
        'subtitle': 'Téléchargement d\'image',
        'iconData': 'assets/images/image-plus.svg',
        'color': const Color(0xFF8B5CF6),
        'onpress': () async {
          formulaireSondeur.addChampFormulaireType(
              formulaireSondeur.formulaireSondeurModel!.id!, "image");
        },
      },
      {
        'text': 'Fichier',
        'subtitle': 'Téléchargement de fichier',
        'iconData': 'assets/images/file-plus.svg',
        'color': const Color(0xFFEF4444),
        'onpress': () async {
          formulaireSondeur.addChampFormulaireType(
              formulaireSondeur.formulaireSondeurModel!.id!, "file");
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
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (field['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    field['iconData'],
                    color: field['color'],
                    width: 18,
                    height: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field['text'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Rubik',
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        field['subtitle'],
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Rubik',
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.add,
                  size: 16,
                  color: Colors.grey[500],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
