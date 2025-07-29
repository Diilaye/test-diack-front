import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();

  // Theme colors
  final Color _primaryColor = const Color(0xFF4F46E5); // Indigo
  final Color _secondaryColor = const Color(0xFF7C3AED); // Purple
  final Color _accentColor = const Color(0xFF06B6D4); // Cyan
  final Color _successColor = const Color(0xFF059669); // Emerald

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Hero Section avec AppBar
          _buildHeroSection(size, isMobile),

          // Features Section
          SliverToBoxAdapter(child: _buildFeaturesSection(isMobile)),

          // How It Works Section
          SliverToBoxAdapter(child: _buildHowItWorksSection(isMobile)),

          // Benefits Section
          SliverToBoxAdapter(child: _buildBenefitsSection(isMobile)),

          // CTA Section
          SliverToBoxAdapter(child: _buildCTASection(isMobile)),

          // Footer
          SliverToBoxAdapter(child: _buildFooter()),
        ],
      ),
    );
  }

  Widget _buildHeroSection(Size size, bool isMobile) {
    return SliverAppBar(
      expandedHeight: isMobile ? 600 : 700,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _primaryColor.withOpacity(0.05),
                _secondaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60,
                vertical: 20,
              ),
              child: Column(
                children: [
                  // Navigation
                  _buildNavigation(isMobile),

                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: _buildHeroContent(isMobile),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation(bool isMobile) {
    return Row(
      children: [
        // Logo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_primaryColor, _secondaryColor]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'FormBuilder',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const Spacer(),

        if (!isMobile) ...[
          _buildNavItem('Fonctionnalités', () => _scrollToSection(1)),
          const SizedBox(width: 30),
          _buildNavItem('Comment ça marche', () => _scrollToSection(2)),
          const SizedBox(width: 30),
          _buildNavItem('Avantages', () => _scrollToSection(3)),
          const SizedBox(width: 30),
        ],

        ElevatedButton(
          onPressed: () => context.go('/sign-in'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Se connecter',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildHeroContent(bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main Title
        Text(
          'Créez des formulaires\npuissants en quelques minutes',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: isMobile ? 32 : 48,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 20),

        // Subtitle
        Container(
          constraints:
              BoxConstraints(maxWidth: isMobile ? double.infinity : 600),
          child: Text(
            'Une plateforme intuitive pour créer, distribuer et analyser vos formulaires. '
            'Collectez des données précieuses avec style et simplicité.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 20,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 40),

        // CTA Buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.go('/sign-in'),
              icon: const Icon(Icons.rocket_launch, size: 20),
              label: Text(
                'Commencer gratuitement',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _scrollToSection(1),
              icon: Icon(Icons.play_arrow, color: _primaryColor, size: 20),
              label: Text(
                'Voir la démo',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: _primaryColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // Hero Image
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 800,
            maxHeight: isMobile ? 200 : 300,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryColor.withOpacity(0.1),
                    _accentColor.withOpacity(0.1)
                  ],
                ),
              ),
              child: Icon(
                Icons.dashboard_customize,
                size: isMobile ? 80 : 120,
                color: _primaryColor.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 100,
      ),
      child: Column(
        children: [
          // Section Title
          Text(
            'Fonctionnalités puissantes',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Tout ce dont vous avez besoin pour créer des formulaires exceptionnels',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 60),

          // Features Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 3,
            childAspectRatio: isMobile ? 2.5 : 1.2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            children: [
              _buildFeatureCard(
                Icons.design_services,
                'Interface intuitive',
                'Créez des formulaires avec un éditeur visuel simple et puissant',
                _primaryColor,
              ),
              _buildFeatureCard(
                Icons.analytics,
                'Analyses avancées',
                'Obtenez des insights détaillés sur vos réponses en temps réel',
                _accentColor,
              ),
              _buildFeatureCard(
                Icons.security,
                'Sécurité garantie',
                'Vos données sont protégées avec un chiffrement de niveau entreprise',
                _successColor,
              ),
              _buildFeatureCard(
                Icons.mobile_friendly,
                'Responsive',
                'Vos formulaires s\'adaptent automatiquement à tous les appareils',
                _secondaryColor,
              ),
              _buildFeatureCard(
                Icons.integration_instructions,
                'Intégrations',
                'Connectez facilement vos outils favoris via notre API',
                Colors.orange.shade600,
              ),
              _buildFeatureCard(
                Icons.support_agent,
                'Support 24/7',
                'Notre équipe est là pour vous aider à chaque étape',
                Colors.pink.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 100,
      ),
      color: Colors.grey.shade50,
      child: Column(
        children: [
          Text(
            'Comment ça marche',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Créez votre premier formulaire en 3 étapes simples',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          Column(
            children: [
              _buildStep(
                  1,
                  'Créez',
                  'Utilisez notre éditeur pour créer votre formulaire',
                  isMobile),
              const SizedBox(height: 40),
              _buildStep(
                  2,
                  'Partagez',
                  'Distribuez votre formulaire via un lien ou intégration',
                  isMobile),
              const SizedBox(height: 40),
              _buildStep(3, 'Analysez',
                  'Consultez les réponses et générez des rapports', isMobile),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
      int number, String title, String description, bool isMobile) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_primaryColor, _secondaryColor]),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 100,
      ),
      child: Row(
        children: [
          if (!isMobile)
            Expanded(
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _accentColor.withOpacity(0.1),
                      _primaryColor.withOpacity(0.1)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.trending_up,
                  size: 120,
                  color: _primaryColor.withOpacity(0.7),
                ),
              ),
            ),
          if (!isMobile) const SizedBox(width: 60),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pourquoi choisir notre plateforme ?',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 24),
                _buildBenefit('Gain de temps considérable',
                    'Créez des formulaires en minutes, pas en heures'),
                _buildBenefit('Taux de réponse élevé',
                    'Interface engageante qui encourage la participation'),
                _buildBenefit('Données de qualité',
                    'Validation automatique pour des réponses précises'),
                _buildBenefit('Évolutivité',
                    'De quelques réponses à des milliers, nous nous adaptons'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _successColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: 50,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 30 : 60,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _secondaryColor],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Prêt à commencer ?',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Rejoignez des milliers d\'utilisateurs qui font confiance à notre plateforme',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/sign-in'),
            icon: const Icon(Icons.arrow_forward, size: 20),
            label: Text(
              'Créer mon premier formulaire',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      color: Colors.grey.shade900,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [_primaryColor, _secondaryColor]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'FormBuilder',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '© 2025 FormBuilder. Tous droits réservés.',
            style: GoogleFonts.inter(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToSection(int section) {
    double offset = 0;
    switch (section) {
      case 1: // Features
        offset = 800;
        break;
      case 2: // How it works
        offset = 1600;
        break;
      case 3: // Benefits
        offset = 2400;
        break;
    }

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}
