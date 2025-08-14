import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form/blocs/formulaire-sondeur-bloc.dart';
import 'package:form/utils/get-date-by-dii.dart';
import 'package:form/utils/request-dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class IndexSondeur extends StatefulWidget {
  const IndexSondeur({super.key});

  @override
  State<IndexSondeur> createState() => _IndexSondeurState();
}

class _IndexSondeurState extends State<IndexSondeur>
    with TickerProviderStateMixin {
  // Controllers et animations
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables
  String _searchQuery = '';
  String _sortBy = 'date';
  bool _sortAscending = false;
  int _currentTab = 0;
  String _viewMode = 'grid'; // 'grid' ou 'list'

  // Theme colors - Plus professionnel
  final Color _primaryColor = const Color(0xFF1E293B); // Slate 800
  final Color _accentColor = const Color(0xFF3B82F6); // Blue 500
  final Color _successColor = const Color(0xFF10B981); // Emerald 500
  final Color _warningColor = const Color(0xFFF59E0B); // Amber 500
  final Color _backgroundColor = const Color(0xFFF8FAFC); // Slate 50
  final Color _cardColor = Colors.white;
  final Color _textPrimary = const Color(0xFF1E293B); // Slate 800
  final Color _textSecondary = const Color(0xFF64748B); // Slate 500

  // Stats
  Map<String, dynamic> _stats = {
    'total': 0,
    'today': 0,
    'week': 0,
    'responses': 0,
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Initialiser les animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Démarrer les animations
    _fadeController.forward();
    _slideController.forward();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 768;
    final bool isTablet = size.width >= 768 && size.width < 1024;
    final formulaireSondeur = Provider.of<FormulaireSondeurBloc>(context);

    // Update stats
    _updateStats(formulaireSondeur);

    // Filter and sort forms
    final filteredForms = _getFilteredForms(formulaireSondeur);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Row(
        children: [
          // Sidebar pour desktop
          if (!isMobile && !isTablet) _buildSidebar(),

          // Contenu principal
          Expanded(
            child: Column(
              children: [
                // Header moderne
                _buildModernHeader(isMobile),

                // Corps principal avec animations
                Expanded(
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              // Dashboard stats
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(isMobile ? 16 : 32),
                                  child: _buildDashboardContent(filteredForms,
                                      formulaireSondeur, isMobile),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildModernFAB(formulaireSondeur, isMobile),
    );
  }

  // ============== NOUVELLE INTERFACE MODERNE ==============

  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _primaryColor,
            _primaryColor.withOpacity(0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo et titre
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    CupertinoIcons.doc_text_fill,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'FormCraft',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Centre de contrôle',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Navigation
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildSidebarItem(
                    CupertinoIcons.home,
                    'Tableau de bord',
                    true,
                    () {},
                  ),
                  _buildSidebarItem(
                    CupertinoIcons.doc_text,
                    'Formulaires',
                    false,
                    () {},
                  ),
                  _buildSidebarItem(
                    CupertinoIcons.chart_bar,
                    'Analytiques',
                    false,
                    () {},
                  ),
                  _buildSidebarItem(
                    CupertinoIcons.settings,
                    'Paramètres',
                    false,
                    () {},
                  ),
                  const Spacer(),
                  _buildSidebarItem(
                    CupertinoIcons.power,
                    'Déconnexion',
                    false,
                    _logout,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: Colors.white.withOpacity(0.2))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: _cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu pour mobile
          if (isMobile) ...[
            IconButton(
              icon: Icon(CupertinoIcons.line_horizontal_3, color: _textPrimary),
              onPressed: () {},
            ),
            const SizedBox(width: 12),
          ],

          // Titre et breadcrumb
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tableau de bord',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Gérez et créez vos formulaires • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions header
          Row(
            children: [
              // Notifications
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  CupertinoIcons.bell,
                  color: _textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Profil et déconnexion
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_accentColor, _accentColor.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        CupertinoIcons.person_fill,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Admin',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _logout,
                        child: Icon(
                          CupertinoIcons.power,
                          color: _textSecondary,
                          size: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
      List filteredForms, FormulaireSondeurBloc bloc, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section bienvenue
        _buildWelcomeSection(isMobile),

        const SizedBox(height: 32),

        // Statistiques
        _buildModernStatsGrid(isMobile),

        const SizedBox(height: 32),

        // Outils et filtres
        _buildToolsSection(isMobile),

        const SizedBox(height: 24),

        // Liste des formulaires
        _buildModernFormsList(filteredForms, bloc, isMobile),
      ],
    );
  }

  Widget _buildWelcomeSection(bool isMobile) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Bonjour'
        : hour < 18
            ? 'Bon après-midi'
            : 'Bonsoir';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accentColor,
            _accentColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting ! 👋',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Prêt à créer de nouveaux formulaires ?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      Provider.of<FormulaireSondeurBloc>(context, listen: false)
                          .addFormSondeur(""),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _accentColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(CupertinoIcons.add, size: 18),
                  label: Text(
                    'Nouveau formulaire',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                CupertinoIcons.doc_text_fill,
                size: 48,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _updateStats(FormulaireSondeurBloc bloc) {
    _stats['total'] = bloc.formulaires.length;
    _stats['today'] = bloc.formulaires.where((e) => isSameDate(e.date!)).length;
    _stats['week'] = bloc.formulaires.where((e) {
      final difference =
          DateTime.now().difference(DateTime.parse(e.date!)).inDays;
      return difference <= 7;
    }).length;
    _stats['responses'] = math.Random().nextInt(500) + 100;
  }

  List _getFilteredForms(FormulaireSondeurBloc bloc) {
    List forms = bloc.formulaires;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      forms = forms.where((form) {
        return form.titre!.toLowerCase().contains(_searchQuery) ||
            form.description!.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Filter by tab
    switch (_currentTab) {
      case 0: // Today
        forms = forms.where((e) => isSameDate(e.date!)).toList();
        break;
      case 1: // This week
        forms = forms.where((e) {
          final difference =
              DateTime.now().difference(DateTime.parse(e.date!)).inDays;
          return difference <= 7;
        }).toList();
        break;
      case 2: // All
        break;
    }

    // Sort
    switch (_sortBy) {
      case 'date':
        forms.sort((a, b) => _sortAscending
            ? a.date!.compareTo(b.date!)
            : b.date!.compareTo(a.date!));
        break;
      case 'title':
        forms.sort((a, b) => _sortAscending
            ? a.titre!.compareTo(b.titre!)
            : b.titre!.compareTo(a.titre!));
        break;
    }

    return forms;
  }

  // Helper methods
  AppBar _buildSimpleAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Tableau de bord',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded, color: Colors.grey.shade700),
          onPressed: () {
            SharedPreferences.getInstance().then((prefs) {
              prefs.clear().then((value) {
                if (value) {
                  js.context.callMethod(
                      'open', ['https://test-diag.saharux.com/', '_self']);
                }
              });
            });
          },
        ),
      ],
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour! 👋',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Gérez vos formulaires en toute simplicité',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total',
          _stats['total'].toString(),
          Icons.assessment_outlined,
          _primaryColor,
        ),
        _buildStatCard(
          'Aujourd\'hui',
          _stats['today'].toString(),
          Icons.today_outlined,
          _successColor,
        ),
        _buildStatCard(
          'Cette semaine',
          _stats['week'].toString(),
          Icons.date_range_outlined,
          _warningColor,
        ),
        _buildStatCard(
          'Réponses',
          _stats['responses'].toString(),
          Icons.reply_outlined,
          _accentColor,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher des formulaires...',
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
          border: InputBorder.none,
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _searchController.clear(),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Aujourd\'hui', 0),
          _buildTab('Cette semaine', 1),
          _buildTab('Tous', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isActive = _currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? _primaryColor : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormsList(
      List forms, FormulaireSondeurBloc bloc, bool isMobile) {
    if (forms.isEmpty) {
      return _buildEmptyState(bloc);
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: forms.length,
      itemBuilder: (context, index) {
        final form = forms[index];
        final isToday = isSameDate(form.date!);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.description_outlined,
                color: _primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              form.titre ?? 'Sans titre',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  form.description ?? 'Aucune description',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isToday
                            ? _successColor.withOpacity(0.1)
                            : _warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isToday ? 'Aujourd\'hui' : 'Récent',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isToday ? _successColor : _warningColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(form.date!)),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'view') {
                  bloc.setSelectedFormSondeurModel(form);
                  context.go('/formulaire/${form.id!}/create');
                } else if (value == 'delete') {
                  _deleteForm(form, bloc);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility_outlined, size: 16),
                      SizedBox(width: 8),
                      Text('Voir'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              bloc.setSelectedFormSondeurModel(form);
              context.go('/formulaire-sondeur/${form.id!}/');
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(FormulaireSondeurBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun formulaire',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier formulaire pour commencer',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => bloc.addFormSondeur(""),
            icon: const Icon(Icons.add),
            label: const Text('Créer un formulaire'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(FormulaireSondeurBloc bloc) {
    return FloatingActionButton.extended(
      onPressed: () => bloc.addFormSondeur(""),
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      icon: bloc.chargement
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(Icons.add),
      label: Text(
        'Nouveau',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _deleteForm(dynamic form, FormulaireSondeurBloc bloc) async {
    bool confirm = await dialogRequest(
      context: context,
      title: 'Êtes-vous sûr de vouloir supprimer ce formulaire ?',
    );

    if (confirm) {
      await bloc.deleteFformulaire(form.id!);

      if (bloc.resultDelete != null) {
        html.window.location.reload();
      } else {
        Fluttertoast.showToast(
          msg: "Ce formulaire ne peut pas être supprimé",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red.shade700,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  // ============== MÉTHODES MODERNES SUPPLÉMENTAIRES ==============

  Widget _buildModernStatsGrid(bool isMobile) {
    return GridView.count(
      crossAxisCount: isMobile ? 2 : 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.3 : 1.5,
      children: [
        _buildModernStatCard(
          'Formulaires totaux',
          _stats['total'].toString(),
          CupertinoIcons.doc_text_fill,
          _primaryColor,
          '+12% ce mois',
          true,
        ),
        _buildModernStatCard(
          'Créés aujourd\'hui',
          _stats['today'].toString(),
          CupertinoIcons.calendar_today,
          _successColor,
          'Excellent !',
          false,
        ),
        _buildModernStatCard(
          'Cette semaine',
          _stats['week'].toString(),
          CupertinoIcons.chart_bar_fill,
          _warningColor,
          '+5 cette semaine',
          true,
        ),
        _buildModernStatCard(
          'Total réponses',
          '${_stats['responses']}',
          CupertinoIcons.reply_all,
          _accentColor,
          '+23% vs semaine passée',
          true,
        ),
      ],
    );
  }

  Widget _buildModernStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
    bool isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Icon(
                isPositive
                    ? CupertinoIcons.arrow_up
                    : CupertinoIcons.arrow_down,
                color: isPositive ? _successColor : Colors.red,
                size: 16,
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: _textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isPositive ? _successColor : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsSection(bool isMobile) {
    return Row(
      children: [
        // Barre de recherche moderne
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher des formulaires...',
                prefixIcon: Icon(CupertinoIcons.search,
                    color: _textSecondary, size: 20),
                border: InputBorder.none,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(CupertinoIcons.clear, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Filtres et vues
        Row(
          children: [
            _buildFilterButton(
              CupertinoIcons.calendar_today,
              'Aujourd\'hui',
              _currentTab == 0,
              () => setState(() => _currentTab = 0),
            ),
            const SizedBox(width: 8),
            _buildFilterButton(
              CupertinoIcons.calendar,
              'Semaine',
              _currentTab == 1,
              () => setState(() => _currentTab = 1),
            ),
            const SizedBox(width: 8),
            _buildFilterButton(
              CupertinoIcons.list_bullet,
              'Tous',
              _currentTab == 2,
              () => setState(() => _currentTab = 2),
            ),

            const SizedBox(width: 16),

            // Toggle view mode
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildViewToggle(CupertinoIcons.square_grid_2x2, 'grid'),
                  _buildViewToggle(CupertinoIcons.list_bullet, 'list'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterButton(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? _accentColor : _cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? _accentColor : Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : _textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(IconData icon, String mode) {
    final isActive = _viewMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _viewMode = mode),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isActive ? _textPrimary : _textSecondary,
        ),
      ),
    );
  }

  Widget _buildModernFormsList(
      List filteredForms, FormulaireSondeurBloc bloc, bool isMobile) {
    if (filteredForms.isEmpty) {
      return _buildModernEmptyState(bloc);
    }

    if (_viewMode == 'grid') {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isMobile ? 3 : 1.2,
        ),
        itemCount: filteredForms.length,
        itemBuilder: (context, index) {
          final form = filteredForms[index];
          return _buildModernFormCard(form, bloc);
        },
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredForms.length,
        itemBuilder: (context, index) {
          final form = filteredForms[index];
          return _buildModernFormListItem(form, bloc);
        },
      );
    }
  }

  Widget _buildModernFormCard(dynamic form, FormulaireSondeurBloc bloc) {
    final isToday = isSameDate(form.date!);

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            bloc.setSelectedFormSondeurModel(form);
            context.go('/formulaire/${form.id!}/create');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        CupertinoIcons.doc_text_fill,
                        color: _accentColor,
                        size: 20,
                      ),
                    ),
                    const Spacer(),
                    _buildFormMenu(form, bloc),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  form.titre ?? 'Sans titre',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  form.description ?? 'Aucune description',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isToday
                            ? _successColor.withOpacity(0.1)
                            : _warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isToday ? 'Aujourd\'hui' : 'Récent',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isToday ? _successColor : _warningColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd/MM').format(DateTime.parse(form.date!)),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernFormListItem(dynamic form, FormulaireSondeurBloc bloc) {
    final isToday = isSameDate(form.date!);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            bloc.setSelectedFormSondeurModel(form);
            context.go('/formulaire/${form.id!}/create');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    CupertinoIcons.doc_text_fill,
                    color: _accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form.titre ?? 'Sans titre',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        form.description ?? 'Aucune description',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: _textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isToday
                            ? _successColor.withOpacity(0.1)
                            : _warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isToday ? 'Aujourd\'hui' : 'Récent',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isToday ? _successColor : _warningColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(form.date!)),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                _buildFormMenu(form, bloc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormMenu(dynamic form, FormulaireSondeurBloc bloc) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          bloc.setSelectedFormSondeurModel(form);
          context.go('/formulaire/${form.id!}/create');
        } else if (value == 'preview') {
          context.go('/form/${form.id!}');
        } else if (value == 'share') {
          bloc.setSelectedFormSondeurModel(form);
          context.go('/formulaire/${form.id!}/share');
        } else if (value == 'delete') {
          _deleteForm(form, bloc);
        }
      },
      icon: Icon(CupertinoIcons.ellipsis_vertical,
          color: _textSecondary, size: 20),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(CupertinoIcons.pencil, size: 16, color: _textSecondary),
              const SizedBox(width: 12),
              Text('Modifier'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'preview',
          child: Row(
            children: [
              Icon(CupertinoIcons.eye, size: 16, color: _textSecondary),
              const SizedBox(width: 12),
              Text('Aperçu'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              Icon(CupertinoIcons.share, size: 16, color: _textSecondary),
              const SizedBox(width: 12),
              Text('Partager'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(CupertinoIcons.delete, size: 16, color: Colors.red),
              const SizedBox(width: 12),
              Text('Supprimer', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernEmptyState(FormulaireSondeurBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              CupertinoIcons.doc_text_fill,
              size: 64,
              color: _accentColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun formulaire trouvé',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier formulaire pour commencer à collecter des données',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: _textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => bloc.addFormSondeur(""),
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(CupertinoIcons.add, size: 20),
            label: Text(
              'Créer un formulaire',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernFAB(FormulaireSondeurBloc bloc, bool isMobile) {
    return FloatingActionButton.extended(
      onPressed: () => bloc.addFormSondeur(""),
      backgroundColor: _accentColor,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: bloc.chargement
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Icon(CupertinoIcons.add, size: 20),
      label: Text(
        isMobile ? 'Nouveau' : 'Nouveau formulaire',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear().then((value) {
        if (value) {
          js.context
              .callMethod('open', ['https://test-diag.saharux.com/', '_self']);
        }
      });
    });
  }
}
