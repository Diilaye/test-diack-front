import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:form/utils/app_theme.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with TickerProviderStateMixin {
  late final AnimationController _mainAnimationController;
  late final AnimationController _heroAnimationController;
  late final AnimationController _cardAnimationController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _heroOpacity;
  late final Animation<Offset> _heroSlide;

  final ScrollController _scrollController = ScrollController();

  // Track disposal state
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _heroAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create sophisticated animations
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _heroOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    ));

    // Start animations in sequence
    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    if (!mounted || _isDisposed) return;

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted || _isDisposed) return;
    _heroAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted || _isDisposed) return;
    _mainAnimationController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted || _isDisposed) return;
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mainAnimationController.dispose();
    _heroAnimationController.dispose();
    _cardAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern Hero Section with Glass Morphism
          _buildModernHeroSection(size, isMobile, isTablet),

          // Enhanced Features Section with Cards Animation
          SliverToBoxAdapter(
              child: _buildEnhancedFeaturesSection(isMobile, isTablet)),

          // Process Section with Timeline
          SliverToBoxAdapter(
              child: _buildProcessTimelineSection(isMobile, isTablet)),

          // Statistics & Testimonials
          SliverToBoxAdapter(
              child: _buildStatsTestimonialsSection(isMobile, isTablet)),

          // Benefits with Visual Enhancement
          SliverToBoxAdapter(
              child: _buildEnhancedBenefitsSection(isMobile, isTablet)),

          // Premium CTA Section
          SliverToBoxAdapter(
              child: _buildPremiumCTASection(isMobile, isTablet)),

          // Professional Footer
          SliverToBoxAdapter(child: _buildProfessionalFooter(isMobile)),
        ],
      ),
    );
  }

  Widget _buildModernHeroSection(Size size, bool isMobile, bool isTablet) {
    // Calculer la hauteur de manière responsive mais plus conservatrice
    final heroHeight = isMobile
        ? size.height * 0.85 // 85% de la hauteur d'écran sur mobile
        : isTablet
            ? size.height * 0.80 // 80% sur tablette
            : size.height * 0.75; // 75% sur desktop

    return SliverToBoxAdapter(
      child: Container(
        width: size.width,
        height: heroHeight,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              AppTheme.primaryColor.withOpacity(0.08),
              AppTheme.accentColor.withOpacity(0.05),
              AppTheme.backgroundColor,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile
                  ? 16
                  : isTablet
                      ? 32
                      : 64,
              vertical: 16,
            ),
            child: Column(
              children: [
                // Professional Navigation
                _buildProfessionalNavigation(isMobile, isTablet),

                // Contenu principal du hero avec gestion d'overflow
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: AnimatedBuilder(
                      animation: Listenable.merge(
                          [_heroAnimationController, _mainAnimationController]),
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _heroOpacity,
                          child: SlideTransition(
                            position: _heroSlide,
                            child: ScaleTransition(
                              scale: _scaleAnimation,
                              child: _buildResponsiveHeroContent(
                                  size, isMobile, isTablet),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalNavigation(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Premium Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              //  gradient: LinearGradient(
              //  colors: [AppTheme.primaryColor],
              //begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
              //),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.7),
                  //blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppTheme.surfaceColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Simplon Forms',
                  style: GoogleFonts.inter(
                    color: AppTheme.surfaceColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Navigation Items (Desktop/Tablet only)
          if (!isMobile) ...[
            _buildModernNavItem('Fonctionnalités', () => _scrollToSection(1)),
            const SizedBox(width: 32),
            _buildModernNavItem('Processus', () => _scrollToSection(2)),
            const SizedBox(width: 32),
            _buildModernNavItem('Avantages', () => _scrollToSection(3)),
            const SizedBox(width: 40),
          ],

          // CTA Button with Premium Design
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.accentColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/sign-in'),
              icon: Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppTheme.surfaceColor,
              ),
              label: Text(
                isMobile ? 'Connexion' : 'Se connecter',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppTheme.surfaceColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppTheme.surfaceColor,
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernNavItem(String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeroContent(bool isMobile, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge/Chip for credibility
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.successColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.successColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: AppTheme.successColor,
              ),
              const SizedBox(width: 6),
              Text(
                '✨ Approuvé par +10,000 utilisateurs',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.successColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Main Title with enhanced typography
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile
                ? double.infinity
                : isTablet
                    ? 600
                    : 800,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: isMobile
                    ? 36
                    : isTablet
                        ? 48
                        : 64,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -1.5,
              ),
              children: [
                TextSpan(
                  text: 'Créez des ',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                TextSpan(
                  text: 'formulaires\n',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [AppTheme.primaryColor, AppTheme.accentColor],
                      ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
                TextSpan(
                  text: 'exceptionnels ',
                  style: TextStyle(color: AppTheme.textPrimary),
                ),
                TextSpan(
                  text: 'en minutes',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [AppTheme.accentColor, AppTheme.successColor],
                      ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Enhanced subtitle
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile
                ? double.infinity
                : isTablet
                    ? 500
                    : 650,
          ),
          child: Text(
            'Plateforme tout-en-un pour créer, distribuer et analyser vos formulaires. '
            'Interface intuitive, analyses avancées et sécurité entreprise.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile
                  ? 17
                  : isTablet
                      ? 19
                      : 21,
              color: AppTheme.textSecondary,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        const SizedBox(height: 40),

        // Enhanced CTA buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            // Primary CTA
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.accentColor],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => context.go('/sign-in'),
                icon: Icon(Icons.rocket_launch_rounded,
                    size: 20, color: AppTheme.surfaceColor),
                label: Text(
                  'Commencer gratuitement',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.surfaceColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            // Secondary CTA
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppTheme.surfaceColor,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: OutlinedButton.icon(
                onPressed: () => _scrollToSection(1),
                icon: Icon(Icons.play_circle_outline_rounded,
                    color: AppTheme.textPrimary, size: 20),
                label: Text(
                  'Voir la démo',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide.none,
                  backgroundColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: isMobile ? 40 : 60),

        // Enhanced Professional Hero Visual
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile
                ? double.infinity
                : isTablet
                    ? 700
                    : 1000,
            maxHeight: isMobile
                ? 320
                : isTablet
                    ? 420
                    : 480,
          ),
          child: Stack(
            children: [
              // Main container with enhanced design
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.surfaceColor,
                      AppTheme.backgroundColor,
                      AppTheme.primaryColor.withOpacity(0.02),
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                  boxShadow: [
                    // Main shadow
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.12),
                      blurRadius: 60,
                      offset: const Offset(0, 25),
                      spreadRadius: -5,
                    ),
                    // Secondary shadow for depth
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                      spreadRadius: -8,
                    ),
                    // Subtle inner glow
                    BoxShadow(
                      color: AppTheme.accentColor.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    children: [
                      // Animated background pattern
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.center,
                              radius: 1.2,
                              colors: [
                                AppTheme.primaryColor.withOpacity(0.06),
                                AppTheme.accentColor.withOpacity(0.04),
                                AppTheme.secondaryColor.withOpacity(0.02),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                          child: CustomPaint(
                            painter: _ModernPatternPainter(),
                          ),
                        ),
                      ),

                      // Floating elements for visual interest
                      ..._buildFloatingElements(isMobile, isTablet),

                      // Main content container
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 24 : 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Professional icon container with enhanced design
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutBack,
                                padding: EdgeInsets.all(isMobile ? 20 : 16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.accentColor,
                                      AppTheme.secondaryColor,
                                    ],
                                    stops: const [0.0, 0.6, 1.0],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withOpacity(0.4),
                                      blurRadius: 25,
                                      offset: const Offset(0, 12),
                                      spreadRadius: -3,
                                    ),
                                    BoxShadow(
                                      color:
                                          AppTheme.accentColor.withOpacity(0.3),
                                      blurRadius: 40,
                                      offset: const Offset(0, 20),
                                      spreadRadius: -10,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: isMobile
                                      ? 64
                                      : isTablet
                                          ? 80
                                          : 96,
                                  color: AppTheme.surfaceColor,
                                ),
                              ),

                              SizedBox(height: isMobile ? 24 : 32),

                              // Professional tagline
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.primaryColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '🚀 Interface Nouvelle Génération',
                                  style: GoogleFonts.inter(
                                    fontSize: isMobile ? 14 : 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),

                              SizedBox(height: isMobile ? 16 : 20),

                              // Feature highlights
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildFeatureHighlight(
                                    Icons.speed_rounded,
                                    'Rapide',
                                    isMobile,
                                  ),
                                  _buildFeatureHighlight(
                                    Icons.security_rounded,
                                    'Sécurisé',
                                    isMobile,
                                  ),
                                  _buildFeatureHighlight(
                                    Icons.analytics_rounded,
                                    'Intelligent',
                                    isMobile,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Decorative corner elements
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                backgroundColor: AppTheme.primaryColor,
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
              icon: Icon(Icons.play_arrow,
                  color: AppTheme.primaryColor, size: 20),
              label: Text(
                'Voir la démo',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.primaryColor),
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
                    AppTheme.primaryColor.withOpacity(0.1),
                    AppTheme.accentColor.withOpacity(0.1)
                  ],
                ),
              ),
              child: Icon(
                Icons.dashboard_customize,
                size: isMobile ? 80 : 120,
                color: AppTheme.primaryColor.withOpacity(0.7),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFeaturesSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
                ? 40
                : 80,
        vertical: isMobile ? 80 : 120,
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          // Enhanced Section Header
          _buildSectionHeader(
            'Fonctionnalités de pointe',
            'Tous les outils nécessaires pour créer des formulaires professionnels',
            isMobile,
            isTablet,
          ),

          SizedBox(height: isMobile ? 60 : 80),

          // Enhanced Features Grid with Staggered Animation
          AnimatedBuilder(
            animation: _cardAnimationController,
            builder: (context, child) {
              return _buildStaggeredGrid(
                isMobile,
                isTablet,
                [
                  _buildEnhancedFeatureCard(
                    Icons.brush_rounded,
                    'Éditeur Visuel',
                    'Interface drag-and-drop intuitive avec prévisualisation en temps réel',
                    AppTheme.secondaryColor,
                    0,
                  ),
                  _buildEnhancedFeatureCard(
                    Icons.analytics_rounded,
                    'Analytics IA',
                    'Analyses prédictives et insights automatiques sur vos données',
                    AppTheme.accentColor,
                    1,
                  ),
                  _buildEnhancedFeatureCard(
                    Icons.shield_rounded,
                    'Sécurité Avancée',
                    'Chiffrement de bout en bout et conformité RGPD intégrée',
                    AppTheme.successColor,
                    2,
                  ),
                  _buildEnhancedFeatureCard(
                    Icons.devices_rounded,
                    'Multi-plateforme',
                    'Optimisé pour tous les appareils avec performance native',
                    AppTheme.primaryColor,
                    3,
                  ),
                  _buildEnhancedFeatureCard(
                    Icons.api_rounded,
                    'API Puissante',
                    'Intégration seamless avec vos outils existants',
                    AppTheme.warningColor,
                    4,
                  ),
                  _buildEnhancedFeatureCard(
                    Icons.support_agent_rounded,
                    'Support Expert',
                    'Assistance 24/7 par des experts en formulaires',
                    Colors.pink.shade500,
                    5,
                  ),
                ],
              );
            },
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
            gradient: LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor]),
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
                      AppTheme.accentColor.withOpacity(0.1),
                      AppTheme.primaryColor.withOpacity(0.1)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.trending_up,
                  size: 120,
                  color: AppTheme.primaryColor.withOpacity(0.7),
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
              color: AppTheme.successColor,
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
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
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
              foregroundColor: AppTheme.primaryColor,
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
                  gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor]),
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

  // Utility Methods for Enhanced Design
  Widget _buildSectionHeader(
      String title, String subtitle, bool isMobile, bool isTablet,
      [String? badge, Color? badgeColor]) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: (badgeColor ?? AppTheme.secondaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (badgeColor ?? AppTheme.secondaryColor).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            badge ?? 'FONCTIONNALITÉS',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: badgeColor ?? AppTheme.secondaryColor,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: isMobile
                ? 32
                : isTablet
                    ? 40
                    : 48,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            height: 1.2,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: BoxConstraints(
            maxWidth: isMobile
                ? double.infinity
                : isTablet
                    ? 500
                    : 600,
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 16 : 18,
              color: AppTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaggeredGrid(
      bool isMobile, bool isTablet, List<Widget> children) {
    if (isMobile) {
      return Column(
        children: children
            .map((child) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: child,
                ))
            .toList(),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 2 : 3,
      childAspectRatio: isTablet ? 1.3 : 1.2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      children: children,
    );
  }

  Widget _buildEnhancedFeatureCard(
    IconData icon,
    String title,
    String description,
    Color color,
    int index,
  ) {
    final delay = index * 0.1;
    final endInterval = (0.8 + delay).clamp(0.0, 1.0);
    final animationValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    )
        .animate(CurvedAnimation(
          parent: _cardAnimationController,
          curve: Interval(delay.clamp(0.0, 1.0), endInterval,
              curve: Curves.easeOutCubic),
        ))
        .value;

    return Transform.translate(
      offset: Offset(0, 20 * (1 - animationValue)),
      child: Opacity(
        opacity: animationValue,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.surfaceColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced sections implementation
  Widget _buildProcessTimelineSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
                ? 40
                : 80,
        vertical: isMobile ? 80 : 120,
      ),
      child: Column(
        children: [
          // Section Header
          _buildSectionHeader(
            'Comment ça marche',
            'Créez votre premier formulaire en 3 étapes simples et intuitives',
            isMobile,
            isTablet,
            'PROCESSUS',
            AppTheme.accentColor,
          ),

          SizedBox(height: isMobile ? 60 : 80),

          // Timeline
          if (isMobile)
            _buildMobileTimeline()
          else
            _buildDesktopTimeline(isTablet),
        ],
      ),
    );
  }

  Widget _buildMobileTimeline() {
    return Column(
      children: [
        _buildTimelineStep(
          1,
          'Concevez',
          'Utilisez notre éditeur drag-and-drop intuitif pour créer votre formulaire',
          Icons.brush_rounded,
          AppTheme.secondaryColor,
          true,
        ),
        const SizedBox(height: 40),
        _buildTimelineStep(
          2,
          'Partagez',
          'Distribuez instantanément via lien, QR code ou intégration web',
          Icons.share_rounded,
          AppTheme.accentColor,
          true,
        ),
        const SizedBox(height: 40),
        _buildTimelineStep(
          3,
          'Analysez',
          'Exploitez des analytics IA pour des insights approfondis',
          Icons.analytics_rounded,
          AppTheme.successColor,
          false,
        ),
      ],
    );
  }

  Widget _buildDesktopTimeline(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: _buildTimelineStep(
            1,
            'Concevez',
            'Utilisez notre éditeur drag-and-drop intuitif pour créer votre formulaire',
            Icons.brush_rounded,
            AppTheme.secondaryColor,
            true,
          ),
        ),
        Expanded(
          child: _buildTimelineConnector(),
        ),
        Expanded(
          child: _buildTimelineStep(
            2,
            'Partagez',
            'Distribuez instantanément via lien, QR code ou intégration web',
            Icons.share_rounded,
            AppTheme.accentColor,
            true,
          ),
        ),
        Expanded(
          child: _buildTimelineConnector(),
        ),
        Expanded(
          child: _buildTimelineStep(
            3,
            'Analysez',
            'Exploitez des analytics IA pour des insights approfondis',
            Icons.analytics_rounded,
            AppTheme.successColor,
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
    int number,
    String title,
    String description,
    IconData icon,
    Color color,
    bool hasConnector,
  ) {
    return Column(
      children: [
        // Step Circle
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  icon,
                  color: AppTheme.surfaceColor,
                  size: 32,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      number.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Step Content
        Container(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector() {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryColor.withOpacity(0.3),
            AppTheme.accentColor.withOpacity(0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsTestimonialsSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
                ? 40
                : 80,
        vertical: isMobile ? 80 : 120,
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          // Stats Section
          _buildStatsGrid(isMobile, isTablet),

          SizedBox(height: isMobile ? 80 : 120),

          // Testimonials Section
          _buildTestimonialsSection(isMobile, isTablet),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isMobile, bool isTablet) {
    return Column(
      children: [
        _buildSectionHeader(
          'Ils nous font confiance',
          'Des milliers d\'entreprises utilisent notre plateforme chaque jour',
          isMobile,
          isTablet,
          'STATISTIQUES',
          AppTheme.successColor,
        ),
        SizedBox(height: isMobile ? 40 : 60),
        if (isMobile)
          Column(
            children: [
              _buildStatCard('10,000+', 'Utilisateurs actifs',
                  Icons.people_rounded, AppTheme.secondaryColor),
              const SizedBox(height: 24),
              _buildStatCard('1M+', 'Formulaires créés',
                  Icons.description_rounded, AppTheme.accentColor),
              const SizedBox(height: 24),
              _buildStatCard('99.9%', 'Disponibilité', Icons.security_rounded,
                  AppTheme.successColor),
              const SizedBox(height: 24),
              _buildStatCard('24/7', 'Support', Icons.support_agent_rounded,
                  AppTheme.warningColor),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('10,000+', 'Utilisateurs actifs',
                      Icons.people_rounded, AppTheme.secondaryColor)),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildStatCard('1M+', 'Formulaires créés',
                      Icons.description_rounded, AppTheme.accentColor)),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildStatCard('99.9%', 'Disponibilité',
                      Icons.security_rounded, AppTheme.successColor)),
              const SizedBox(width: 24),
              Expanded(
                  child: _buildStatCard('24/7', 'Support',
                      Icons.support_agent_rounded, AppTheme.warningColor)),
            ],
          ),
      ],
    );
  }

  Widget _buildStatCard(
      String number, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection(bool isMobile, bool isTablet) {
    return Column(
      children: [
        _buildSectionHeader(
          'Ce que disent nos clients',
          'Découvrez pourquoi les entreprises choisissent notre solution',
          isMobile,
          isTablet,
          'TÉMOIGNAGES',
          Colors.purple.shade500,
        ),
        SizedBox(height: isMobile ? 40 : 60),
        if (isMobile)
          Column(
            children: [
              _buildTestimonialCard(
                'Une solution exceptionnelle qui a révolutionné notre collecte de données. Interface intuitive et analytics puissants.',
                'Marie Dubois',
                'Directrice Marketing • TechCorp',
                AppTheme.secondaryColor,
              ),
              const SizedBox(height: 24),
              _buildTestimonialCard(
                'Gain de temps considérable et amélioration de la qualité des réponses. Je recommande vivement cette plateforme.',
                'Pierre Martin',
                'Chef de Projet • InnovStart',
                AppTheme.accentColor,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildTestimonialCard(
                  'Une solution exceptionnelle qui a révolutionné notre collecte de données. Interface intuitive et analytics puissants.',
                  'Marie Dubois',
                  'Directrice Marketing • TechCorp',
                  AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildTestimonialCard(
                  'Gain de temps considérable et amélioration de la qualité des réponses. Je recommande vivement cette plateforme.',
                  'Pierre Martin',
                  'Chef de Projet • InnovStart',
                  AppTheme.accentColor,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildTestimonialCard(
                  'Support client exceptionnel et fonctionnalités qui répondent parfaitement à nos besoins métier.',
                  'Sophie Laurent',
                  'Responsable RH • GlobalTech',
                  AppTheme.successColor,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildTestimonialCard(
      String quote, String name, String position, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.format_quote_rounded,
              color: accentColor,
              size: 24,
            ),
          ),

          const SizedBox(height: 24),

          // Quote text
          Text(
            '"$quote"',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.textPrimary,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 24),

          // Author info
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [accentColor, accentColor.withOpacity(0.8)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: AppTheme.surfaceColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      position,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBenefitsSection(bool isMobile, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
                ? 40
                : 80,
        vertical: isMobile ? 80 : 120,
      ),
      child: Column(
        children: [
          _buildSectionHeader(
            'Pourquoi nous choisir ?',
            'Découvrez les avantages qui font la différence',
            isMobile,
            isTablet,
            'AVANTAGES',
            AppTheme.successColor,
          ),
          SizedBox(height: isMobile ? 60 : 80),
          if (isMobile)
            _buildMobileBenefits()
          else
            _buildDesktopBenefits(isTablet),
        ],
      ),
    );
  }

  Widget _buildMobileBenefits() {
    return Column(
      children: [
        _buildBenefitItem(
          Icons.speed_rounded,
          'Gain de temps considérable',
          'Créez des formulaires professionnels en minutes, pas en heures. Notre éditeur intuitif vous fait gagner un temps précieux.',
          AppTheme.secondaryColor,
        ),
        const SizedBox(height: 32),
        _buildBenefitItem(
          Icons.trending_up_rounded,
          'Taux de réponse élevé',
          'Interface moderne et engageante qui encourage la participation. Augmentez vos taux de conversion significativement.',
          AppTheme.accentColor,
        ),
        const SizedBox(height: 32),
        _buildBenefitItem(
          Icons.verified_rounded,
          'Données de qualité',
          'Validation automatique et logique conditionnelle pour des réponses précises et cohérentes.',
          AppTheme.successColor,
        ),
        const SizedBox(height: 32),
        _buildBenefitItem(
          Icons.auto_graph_rounded,
          'Évolutivité garantie',
          'De quelques réponses à des millions, notre infrastructure s\'adapte à vos besoins de croissance.',
          AppTheme.warningColor,
        ),
      ],
    );
  }

  Widget _buildDesktopBenefits(bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visual illustration
        Expanded(
          flex: 2,
          child: Container(
            height: 500,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  AppTheme.secondaryColor.withOpacity(0.1),
                  AppTheme.accentColor.withOpacity(0.05),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: DecorationImage(
                        image: NetworkImage(
                          'data:image/svg+xml,${Uri.encodeComponent('<svg width="60" height="60" viewBox="0 0 60 60" xmlns="http://www.w3.org/2000/svg"><g fill="none" fill-rule="evenodd"><g fill="${AppTheme.textSecondary.value.toRadixString(16).substring(2)}" fill-opacity="0.05"><circle cx="30" cy="30" r="1"/></g></svg>')}',
                        ),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ),
                // Central illustration
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.secondaryColor,
                              AppTheme.accentColor
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.secondaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          size: 64,
                          color: AppTheme.surfaceColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Performance\nExceptionnelle',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 60),

        // Benefits list
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildBenefitItem(
                Icons.speed_rounded,
                'Gain de temps considérable',
                'Créez des formulaires professionnels en minutes, pas en heures. Notre éditeur intuitif vous fait gagner un temps précieux.',
                AppTheme.secondaryColor,
              ),
              const SizedBox(height: 32),
              _buildBenefitItem(
                Icons.trending_up_rounded,
                'Taux de réponse élevé',
                'Interface moderne et engageante qui encourage la participation. Augmentez vos taux de conversion significativement.',
                AppTheme.accentColor,
              ),
              const SizedBox(height: 32),
              _buildBenefitItem(
                Icons.verified_rounded,
                'Données de qualité',
                'Validation automatique et logique conditionnelle pour des réponses précises et cohérentes.',
                AppTheme.successColor,
              ),
              const SizedBox(height: 32),
              _buildBenefitItem(
                Icons.auto_graph_rounded,
                'Évolutivité garantie',
                'De quelques réponses à des millions, notre infrastructure s\'adapte à vos besoins de croissance.',
                AppTheme.warningColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(
      IconData icon, String title, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppTheme.surfaceColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCTASection(bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 24
            : isTablet
                ? 40
                : 80,
        vertical: 50,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 32 : 60,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Prêt à transformer vos formulaires ?',
            style: GoogleFonts.inter(
              fontSize: isMobile
                  ? 28
                  : isTablet
                      ? 32
                      : 36,
              fontWeight: FontWeight.w800,
              color: AppTheme.surfaceColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Rejoignez des milliers d\'entreprises qui ont révolutionné leur collecte de données',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: AppTheme.surfaceColor.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => context.go('/sign-in'),
              icon: Icon(Icons.arrow_forward_rounded,
                  size: 20, color: AppTheme.primaryColor),
              label: Text(
                'Créer mon premier formulaire',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surfaceColor,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 60,
      ),
      color: AppTheme.primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [AppTheme.secondaryColor, AppTheme.accentColor]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome,
                        color: AppTheme.surfaceColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'FormBuilder',
                      style: GoogleFonts.inter(
                        color: AppTheme.surfaceColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            '© 2025 FormBuilder. Tous droits réservés. Conçu avec ❤️ pour simplifier vos formulaires.',
            style: GoogleFonts.inter(
              color: AppTheme.surfaceColor.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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

  // Méthodes pour le widget professionnel amélioré
  List<Widget> _buildFloatingElements(bool isMobile, bool isTablet) {
    return [
      // Floating element 1 - Top left
      Positioned(
        top: isMobile ? 30 : 40,
        left: isMobile ? 20 : 30,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 2000),
          width: isMobile ? 12 : 16,
          height: isMobile ? 12 : 16,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentColor.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ),
      // Floating element 2 - Top right
      Positioned(
        top: isMobile ? 60 : 80,
        right: isMobile ? 40 : 60,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 2500),
          width: isMobile ? 8 : 12,
          height: isMobile ? 8 : 12,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppTheme.secondaryColor.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
      // Floating element 3 - Bottom right
      Positioned(
        bottom: isMobile ? 40 : 60,
        right: isMobile ? 20 : 40,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 3000),
          width: isMobile ? 10 : 14,
          height: isMobile ? 10 : 14,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
        ),
      ),
      // Floating element 4 - Bottom left
      Positioned(
        bottom: isMobile ? 80 : 100,
        left: isMobile ? 50 : 80,
        child: Container(
          width: isMobile ? 6 : 8,
          height: isMobile ? 6 : 8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentColor.withOpacity(0.3),
                AppTheme.primaryColor.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    ];
  }

  Widget _buildFeatureHighlight(IconData icon, String label, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isMobile ? 18 : 22,
            color: AppTheme.primaryColor,
          ),
          SizedBox(height: isMobile ? 4 : 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isMobile ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveHeroContent(Size size, bool isMobile, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Badge de crédibilité
        _buildCredibilityBadge(isMobile),

        SizedBox(height: isMobile ? 16 : 24),

        // Titre principal responsive
        _buildResponsiveTitle(size, isMobile, isTablet),

        SizedBox(height: isMobile ? 12 : 16),

        // Sous-titre responsive
        _buildResponsiveSubtitle(size, isMobile, isTablet),

        SizedBox(height: isMobile ? 24 : 32),

        // Boutons CTA responsives
        _buildResponsiveCTAButtons(isMobile, isTablet),

        SizedBox(height: isMobile ? 24 : 40),

        // Visual hero responsive (réduit pour éviter overflow)
        _buildResponsiveHeroVisual(size, isMobile, isTablet),
      ],
    );
  }

  Widget _buildCredibilityBadge(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.successColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: isMobile ? 14 : 16,
            color: AppTheme.successColor,
          ),
          SizedBox(width: isMobile ? 4 : 6),
          Text(
            '✨ Approuvé par +10,000 utilisateurs',
            style: GoogleFonts.inter(
              fontSize: isMobile ? 11 : 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.successColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveTitle(Size size, bool isMobile, bool isTablet) {
    // Calculer la taille de police basée sur la largeur d'écran
    double fontSize;
    if (isMobile) {
      fontSize = size.width < 350 ? 28 : 32;
    } else if (isTablet) {
      fontSize = 42;
    } else {
      fontSize = size.width < 1200 ? 52 : 64;
    }

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isMobile
            ? size.width - 32
            : isTablet
                ? 600
                : 800,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            height: isMobile ? 1.2 : 1.1,
            letterSpacing: isMobile ? -0.5 : -1.5,
          ),
          children: [
            TextSpan(
              text: 'Créez des ',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            TextSpan(
              text: 'formulaires\n',
              style: TextStyle(
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  ).createShader(
                    Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                  ),
              ),
            ),
            TextSpan(
              text: 'exceptionnels ',
              style: TextStyle(color: AppTheme.textPrimary),
            ),
            TextSpan(
              text: 'en minutes',
              style: TextStyle(
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [AppTheme.accentColor, AppTheme.successColor],
                  ).createShader(
                    Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveSubtitle(Size size, bool isMobile, bool isTablet) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: isMobile
            ? size.width - 32
            : isTablet
                ? 500
                : 650,
      ),
      child: Text(
        'Plateforme tout-en-un pour créer, distribuer et analyser vos formulaires. '
        'Interface intuitive, analyses avancées et sécurité entreprise.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: isMobile
              ? 15
              : isTablet
                  ? 17
                  : 19,
          color: AppTheme.textSecondary,
          height: 1.6,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildResponsiveCTAButtons(bool isMobile, bool isTablet) {
    if (isMobile) {
      // Stack vertical sur mobile
      return Column(
        children: [
          _buildPrimaryCTAButton(isMobile),
          const SizedBox(height: 12),
          _buildSecondaryCTAButton(isMobile),
        ],
      );
    } else {
      // Côte à côte sur tablette et desktop
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          _buildPrimaryCTAButton(isMobile),
          _buildSecondaryCTAButton(isMobile),
        ],
      );
    }
  }

  Widget _buildPrimaryCTAButton(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.accentColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.go('/sign-in'),
        icon: Icon(
          Icons.rocket_launch_rounded,
          size: 20,
          color: AppTheme.surfaceColor,
        ),
        label: Text(
          'Commencer gratuitement',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.surfaceColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 32,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCTAButton(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.surfaceColor,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: () => _scrollToSection(1),
        icon: Icon(
          Icons.play_circle_outline_rounded,
          color: AppTheme.textPrimary,
          size: 20,
        ),
        label: Text(
          'Voir la démo',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 32,
            vertical: 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveHeroVisual(Size size, bool isMobile, bool isTablet) {
    // Calculer les dimensions de manière responsive - plus compactes
    double maxWidth = isMobile
        ? size.width - 32
        : isTablet
            ? 500
            : 700;

    double maxHeight = isMobile
        ? 180 // Réduit de 250 à 180
        : isTablet
            ? 280 // Réduit de 350 à 280
            : 320; // Réduit de 400 à 320

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: AspectRatio(
        aspectRatio: isMobile ? 1.4 : 2.4, // Ratio légèrement plus large
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(isMobile ? 20 : 24), // Radius réduit
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.surfaceColor,
                AppTheme.backgroundColor,
                AppTheme.primaryColor.withOpacity(0.02),
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.12),
                blurRadius: isMobile ? 30 : 60,
                offset: Offset(0, isMobile ? 15 : 25),
                spreadRadius: -5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: isMobile ? 15 : 30,
                offset: Offset(0, isMobile ? 8 : 15),
                spreadRadius: -8,
              ),
            ],
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.08),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 24 : 32),
            child: Stack(
              children: [
                // Background pattern
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.2,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.06),
                          AppTheme.accentColor.withOpacity(0.04),
                          AppTheme.secondaryColor.withOpacity(0.02),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                    child: CustomPaint(
                      painter: _ModernPatternPainter(),
                    ),
                  ),
                ),

                // Floating elements
                ..._buildResponsiveFloatingElements(isMobile, isTablet),

                // Main content
                Center(
                  child: Padding(
                    padding:
                        EdgeInsets.all(isMobile ? 12 : 16), // Padding réduit
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon principal - plus petit
                        Container(
                          padding: EdgeInsets.all(
                              isMobile ? 12 : 16), // Padding réduit
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor,
                                AppTheme.accentColor,
                                AppTheme.secondaryColor,
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                            borderRadius:
                                BorderRadius.circular(16), // Radius réduit
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: isMobile ? 10 : 15, // Blur réduit
                                offset: Offset(
                                    0, isMobile ? 4 : 6), // Offset réduit
                                spreadRadius: -2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            size: isMobile
                                ? 32 // Réduit de 48 à 32
                                : isTablet
                                    ? 40 // Réduit de 64 à 40
                                    : 48, // Réduit de 80 à 48
                            color: AppTheme.surfaceColor,
                          ),
                        ),

                        SizedBox(height: isMobile ? 12 : 16), // Réduit

                        // Tagline - plus compact
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 12, // Réduit
                            vertical: isMobile ? 6 : 8, // Réduit
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20), // Réduit
                            border: Border.all(
                              color: AppTheme.primaryColor.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '🚀 Interface Nouvelle Génération',
                            style: GoogleFonts.inter(
                              fontSize: isMobile ? 10 : 12, // Réduit
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                              letterSpacing: 0.3, // Réduit
                            ),
                          ),
                        ),

                        if (!isMobile) ...[
                          SizedBox(height: isMobile ? 8 : 12), // Réduit

                          // Feature highlights
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildFeatureHighlight(
                                Icons.speed_rounded,
                                'Rapide',
                                isMobile,
                              ),
                              _buildFeatureHighlight(
                                Icons.security_rounded,
                                'Sécurisé',
                                isMobile,
                              ),
                              _buildFeatureHighlight(
                                Icons.analytics_rounded,
                                'Intelligent',
                                isMobile,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildResponsiveFloatingElements(bool isMobile, bool isTablet) {
    final elementSize = isMobile ? 8.0 : 12.0;

    return [
      // Element 1
      Positioned(
        top: isMobile ? 20 : 30,
        left: isMobile ? 15 : 25,
        child: Container(
          width: elementSize,
          height: elementSize,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),

      // Element 2
      Positioned(
        top: isMobile ? 40 : 60,
        right: isMobile ? 25 : 40,
        child: Container(
          width: elementSize * 0.7,
          height: elementSize * 0.7,
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),

      // Element 3
      Positioned(
        bottom: isMobile ? 30 : 50,
        right: isMobile ? 15 : 30,
        child: Container(
          width: elementSize * 0.8,
          height: elementSize * 0.8,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.25),
            shape: BoxShape.circle,
          ),
        ),
      ),
    ];
  }
}

// Custom Painter pour le pattern moderne
class _ModernPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Dessiner un pattern de grille moderne
    const double spacing = 40.0;
    const double dotSize = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          dotSize,
          paint,
        );
      }
    }

    // Ajouter quelques lignes subtiles
    final linePaint = Paint()
      ..color = AppTheme.accentColor.withOpacity(0.02)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Ligne diagonale subtile
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width * 0.7, 0),
      linePaint,
    );

    // Ligne diagonale inverse
    canvas.drawLine(
      Offset(size.width * 0.3, size.height),
      Offset(size.width, size.height * 0.3),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
