import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/models/folder-model.dart';
import 'package:form/screen/sondeur/components/questions/Explication-Form.dart';
import 'package:form/screen/sondeur/components/questions/addresse-Form.dart';
import 'package:form/screen/sondeur/components/questions/email-Form.dart';
import 'package:form/screen/sondeur/components/questions/file-field-Form.dart';
import 'package:form/screen/sondeur/components/questions/full-Name-Form.dart';
import 'package:form/screen/sondeur/components/questions/image-field-Form.dart';
import 'package:form/screen/sondeur/components/questions/multi-selection-Form.dart';
import 'package:form/screen/sondeur/components/questions/separator-field-Form.dart';
import 'package:form/screen/sondeur/components/questions/separator-field-with-title-Form.dart';
import 'package:form/screen/sondeur/components/questions/single-selection-Form.dart';
import 'package:form/screen/sondeur/components/questions/telephone-Form.dart';
import 'package:form/screen/sondeur/components/questions/textArea-Form%20.dart';
import 'package:form/screen/sondeur/components/questions/textField-Form.dart';
import 'package:form/screen/sondeur/components/questions/yes-or-no-Form.dart';
import 'package:form/screen/sondeur/components/section-menu-form/contact-menu.dart';
import 'package:form/screen/sondeur/components/section-menu-form/essentiel-menu.dart';
import 'package:form/screen/sondeur/components/section-menu-form/media-structure.dart';
import 'package:form/screen/sondeur/components/section-menu-form/telechargement-menu.dart';
import 'package:form/utils/colors-by-dii.dart';
import 'package:form/utils/requette-by-dii.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:form/blocs/folder-bloc.dart';

class CreateFormSondeurScreen extends StatefulWidget {
  const CreateFormSondeurScreen({super.key});

  @override
  State<CreateFormSondeurScreen> createState() =>
      _CreateFormSondeurScreenState();
}

class _CreateFormSondeurScreenState extends State<CreateFormSondeurScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _headerAnimationController;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int selectedTab = 0;
  bool isSidebarExpanded = true;
  String searchQuery = '';

  final List<Tab> tabs = [
    Tab(icon: 'shapes', label: 'Champs', index: 0),
    Tab(icon: 'design', label: 'Design', index: 1),
    Tab(icon: 'logic', label: 'Logique', index: 2),
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _sidebarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _headerAnimationController.forward();
    _sidebarAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _headerAnimationController.dispose();
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);
    final folderBloc = Provider.of<FolderBloc>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Column(
              children: [
                _buildModernHeader(
                    context, formulaireSondeur, folderBloc, size),
                Expanded(
                  child: Row(
                    children: [
                      _buildModernSidebar(context, formulaireSondeur, size),
                      _buildMainContent(context, formulaireSondeur, size),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(formulaireSondeur),
    );
  }

  Widget _buildModernHeader(
      BuildContext context,
      FormulaireSondeurBloc formulaireSondeur,
      FolderBloc folderBloc,
      Size size) {
    return AnimatedBuilder(
      animation: _headerAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0, _slideAnimation.value * _headerAnimationController.value),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  const Color(0xFFF8FAFC),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  _buildBreadcrumb(context, formulaireSondeur, folderBloc),
                  const Spacer(),
                  _buildHeaderActions(context, formulaireSondeur, size),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreadcrumb(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, FolderBloc folderBloc) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (formulaireSondeur.formulaireSondeurModel!.folderForm ==
                  null) {
                folderBloc.setFolder(null);
                context.go("/");
              } else {
                FolderModel f = folderBloc.folders
                    .where((e) =>
                        e.id! ==
                        formulaireSondeur
                            .formulaireSondeurModel!.folderForm!.id!)
                    .first;
                folderBloc.setFolder(f);
                context.go("/");
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.folder,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formulaireSondeur.formulaireSondeurModel!.folderForm == null
                        ? "Mes formulaires"
                        : formulaireSondeur
                            .formulaireSondeurModel!.folderForm!.titre!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(
            CupertinoIcons.chevron_right,
            color: Colors.grey.shade400,
            size: 16,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [btnColor, btnColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: btnColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            formulaireSondeur.formulaireSondeurModel!.titre!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Rubik',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    return Row(
      children: [
        _buildHeaderTab('Construire', CupertinoIcons.building_2_fill, true),
        const SizedBox(width: 8),
        _buildHeaderTab('Paramètres', CupertinoIcons.settings, false,
            onTap: () => context.go(
                '/formulaire/${formulaireSondeur.formulaireSondeurModel!.id!}/params')),
        const SizedBox(width: 8),
        _buildHeaderTab('Partager', CupertinoIcons.share, false),
        const SizedBox(width: 8),
        _buildHeaderTab('Résultats', CupertinoIcons.chart_bar_alt_fill, false),
        const SizedBox(width: 32),
        _buildActionButton(
          icon: CupertinoIcons.eye,
          tooltip: 'Aperçu',
          isPrimary: false,
          onTap: () {},
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.save_rounded,
          label: 'Sauvegarder',
          tooltip: 'Sauvegarder le formulaire',
          isPrimary: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHeaderTab(String label, IconData icon, bool isActive,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? btnColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border(bottom: BorderSide(color: btnColor, width: 3))
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? btnColor : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? btnColor : Colors.grey.shade600,
                fontFamily: 'Rubik',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? label,
    required String tooltip,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: label != null ? 20 : 12,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? LinearGradient(
                      colors: [btnColor, btnColor.withOpacity(0.8)])
                  : null,
              color: isPrimary ? null : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isPrimary
                      ? btnColor.withOpacity(0.3)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isPrimary ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: !isPrimary
                  ? Border.all(color: Colors.grey.shade300, width: 1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isPrimary ? Colors.white : Colors.grey.shade700,
                  size: 16,
                ),
                if (label != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSidebar(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    return AnimatedBuilder(
      animation: _sidebarAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              _slideAnimation.value * _sidebarAnimationController.value, 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isSidebarExpanded ? 320 : 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(4, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSidebarHeader(),
                if (isSidebarExpanded) _buildSearchBar(),
                Expanded(child: _buildSidebarContent(formulaireSondeur)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          if (isSidebarExpanded) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [btnColor, btnColor.withOpacity(0.8)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                "assets/images/shapes.svg",
                height: 20,
                width: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Composants",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  "Glissez pour ajouter",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: SvgPicture.asset(
                "assets/images/shapes.svg",
                height: 24,
                width: 24,
                color: btnColor,
              ),
            ),
          ],
          const Spacer(),
          IconButton(
            icon: Icon(
              isSidebarExpanded
                  ? CupertinoIcons.sidebar_left
                  : CupertinoIcons.sidebar_right,
              color: Colors.grey.shade600,
            ),
            onPressed: () {
              setState(() {
                isSidebarExpanded = !isSidebarExpanded;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Rechercher des composants...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(CupertinoIcons.search,
              color: Colors.grey.shade500, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSidebarContent(FormulaireSondeurBloc formulaireSondeur) {
    if (!isSidebarExpanded) {
      return Column(
        children: tabs.map((tab) => _buildCollapsedTab(tab)).toList(),
      );
    }

    return Column(
      children: [
        _buildTabBar(),
        Expanded(
          child: _buildTabContent(formulaireSondeur),
        ),
      ],
    );
  }

  Widget _buildCollapsedTab(Tab tab) {
    final isSelected = selectedTab == tab.index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab.index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? btnColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: btnColor, width: 2) : null,
        ),
        child: SvgPicture.asset(
          "assets/images/${tab.icon}.svg",
          height: 20,
          width: 20,
          color: isSelected ? btnColor : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.map((tab) => _buildTabItem(tab)).toList(),
      ),
    );
  }

  Widget _buildTabItem(Tab tab) {
    final isSelected = selectedTab == tab.index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = tab.index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/${tab.icon}.svg",
                height: 16,
                width: 16,
                color: isSelected ? btnColor : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                tab.label,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Rubik',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? btnColor : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(FormulaireSondeurBloc formulaireSondeur) {
    switch (selectedTab) {
      case 0:
        return _buildFieldsTab();
      case 1:
        return _buildDesignTab();
      case 2:
        return _buildLogicTab();
      default:
        return _buildFieldsTab();
    }
  }

  Widget _buildFieldsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        EssentielSectionMenu(),
        SizedBox(height: 8),
        ContactSectionMenu(),
        SizedBox(height: 8),
        TelechargementSectionMenu(),
        SizedBox(height: 8),
        MediaStructureSectionMenu(),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _buildDesignTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDesignSection('Thème', CupertinoIcons.paintbrush, [
            'Couleurs',
            'Typographie',
            'Espacement',
          ]),
          const SizedBox(height: 16),
          _buildDesignSection('Layout', CupertinoIcons.rectangle_grid_2x2, [
            'Colonnes',
            'Sections',
            'Marges',
          ]),
        ],
      ),
    );
  }

  Widget _buildLogicTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildLogicSection('Conditions', CupertinoIcons.arrow_branch, [
            'Logique conditionnelle',
            'Questions dépendantes',
            'Sauts de page',
          ]),
          const SizedBox(height: 16),
          _buildLogicSection('Validation', CupertinoIcons.checkmark_shield, [
            'Règles de validation',
            'Messages d\'erreur',
            'Champs obligatoires',
          ]),
        ],
      ),
    );
  }

  Widget _buildDesignSection(String title, IconData icon, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: btnColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          ...items.map((item) => Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLogicSection(String title, IconData icon, List<String> items) {
    return _buildDesignSection(title, icon, items);
  }

  Widget _buildMainContent(BuildContext context,
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    return Expanded(
      child: Container(
        color: const Color(0xFFF8FAFC),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: _buildFormHeaderSection(formulaireSondeur, size),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: _buildFormContentSection(formulaireSondeur, size),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final champ = formulaireSondeur.listeChampForm[index];
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                            0,
                            _slideAnimation.value *
                                (1 - _animationController.value)),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 8),
                            child: _buildQuestionWidget(champ),
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: formulaireSondeur.listeChampForm.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 200),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormHeaderSection(
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCoverSection(formulaireSondeur, size),
          _buildFormTitleSection(formulaireSondeur, size),
        ],
      ),
    );
  }

  Widget _buildCoverSection(
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    return GestureDetector(
      onTap: () => formulaireSondeur.upadteCover(),
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient:
                      formulaireSondeur.formulaireSondeurModel!.cover == null
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.shade100,
                                Colors.grey.shade200,
                              ],
                            )
                          : null,
                ),
                child: formulaireSondeur.formulaireSondeurModel!.cover == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "assets/images/upload-minimalistic.svg",
                                height: 32,
                                width: 32,
                                color: btnColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Cliquez pour ajouter une image de couverture",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              "Dimensions recommandées : 2400 × 240px",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: BASE_URL_ASSET +
                              formulaireSondeur
                                  .formulaireSondeurModel!.cover!.url!,
                          placeholder: (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(child: Icon(Icons.error)),
                          ),
                        ),
                      ),
              ),
            ),
            if (formulaireSondeur.formulaireSondeurModel!.cover != null)
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.delete,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              bottom: -25,
              left: 32,
              child: _buildLogoSection(formulaireSondeur),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(FormulaireSondeurBloc formulaireSondeur) {
    return GestureDetector(
      onTap: () => formulaireSondeur.upadteLogo(),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: formulaireSondeur.formulaireSondeurModel!.logo == null
            ? Center(
                child: SvgPicture.asset(
                  "assets/images/upload-minimalistic.svg",
                  height: 24,
                  width: 24,
                  color: btnColor,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: BASE_URL_ASSET +
                      formulaireSondeur.formulaireSondeurModel!.logo!.url!,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildFormTitleSection(
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            onChanged: (value) => formulaireSondeur.updateTitreForm(value),
            controller: formulaireSondeur.titreCtrl,
            cursorColor: btnColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: formulaireSondeur.formulaireSondeurModel!.titre!,
              hintStyle: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            minLines: 3,
            maxLines: 6,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            onChanged: (value) => formulaireSondeur.updateDescrForm(value),
            controller: formulaireSondeur.descCtrl,
            cursorColor: btnColor,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              labelText: 'Description du formulaire',
              hintText: formulaireSondeur.formulaireSondeurModel!.description,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: btnColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContentSection(
      FormulaireSondeurBloc formulaireSondeur, Size size) {
    if (formulaireSondeur.listeChampForm.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.grey.shade200, width: 2, style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: btnColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                CupertinoIcons.add_circled,
                size: 48,
                color: btnColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Commencez à créer votre formulaire",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Glissez des composants depuis la barre latérale ou cliquez sur le bouton + pour ajouter votre première question",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildQuestionWidget(dynamic champ) {
    Widget questionWidget;

    switch (champ.type!) {
      case 'textField':
        questionWidget = TextFieldForm(champ: champ);
        break;
      case "textArea":
        questionWidget = TextAreaForm(champ: champ);
        break;
      case "singleChoice":
        questionWidget = SingleSelectionForm(champ: champ);
        break;
      case "yesno":
        questionWidget = YesOrnOForm(champ: champ);
        break;
      case "multiChoice":
        questionWidget = MultiSelectionForm(champ: champ);
        break;
      case "nomComplet":
        questionWidget = FullNameForm(champ: champ);
        break;
      case "email":
        questionWidget = EmailForm(champ: champ);
        break;
      case "addresse":
        questionWidget = AddresseForm(champ: champ);
        break;
      case "telephone":
        questionWidget = TelephoneForm(champ: champ);
        break;
      case "image":
        questionWidget = ImageFieldForm(champ: champ);
        break;
      case "file":
        questionWidget = FileFieldForm(champ: champ);
        break;
      case "separator":
        // Pour le séparateur, on retourne directement le widget sans conteneur
        return SeparatorFielForm(champ: champ);
      case "separator-title":
        // Pour le séparateur avec titre, on retourne directement le widget sans conteneur
        return SeparatorFielWithTitleForm(champ: champ);
      case "explication":
        // Pour l'explication, on retourne directement le widget sans conteneur
        return ExplicationForm(champ: champ);
      default:
        questionWidget = Container();
    }

    // Pour les autres types de questions, on applique la décoration normale
    return Container(
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
      child: questionWidget,
    );
  }

  Widget _buildFloatingActionButton(FormulaireSondeurBloc formulaireSondeur) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: () async {
              await formulaireSondeur.addChampFormulaire(
                formulaireSondeur.formulaireSondeurModel!.id!,
              );
            },
            backgroundColor: btnColor,
            foregroundColor: Colors.white,
            elevation: 8,
            icon: const Icon(CupertinoIcons.add),
            label: const Text(
              'Ajouter une question',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        );
      },
    );
  }
}

class Tab {
  final String icon;
  final String label;
  final int index;

  Tab({required this.icon, required this.label, required this.index});
}
