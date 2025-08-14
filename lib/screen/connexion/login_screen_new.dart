import 'package:flutter/material.dart';
import 'package:form/blocs/auth-bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:js' as js;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  // Theme colors
  final Color _primaryColor = const Color(0xFF6366F1); // Modern Indigo
  final Color _secondaryColor = const Color(0xFF8B5CF6); // Modern Purple
  final Color _accentColor = const Color(0xFF06B6D4); // Cyan
  final Color _gradientStart = const Color(0xFF667EEA);
  final Color _gradientEnd = const Color(0xFF764BA2);

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Animation principale
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animation flottante pour les particules
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Animation de pulsation pour les éléments interactifs
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Animation shimmer pour les effets de lumière
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // Lancer les animations
    _animationController.forward();
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Stack(
        children: [
          // Background animé avec gradient
          _buildAnimatedBackground(),

          // Particules flottantes
          _buildFloatingParticles(),

          // Contenu principal
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      // Header avec navigation
                      _buildHeader(),

                      SizedBox(height: isMobile ? 40 : 60),

                      // Contenu principal
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: _buildMainContent(
                                    authBloc, isMobile, isTablet),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _gradientStart.withOpacity(0.1),
                _primaryColor.withOpacity(0.05),
                _secondaryColor.withOpacity(0.08),
                _gradientEnd.withOpacity(0.1),
              ],
              stops: [
                0.0,
                0.3 + _shimmerAnimation.value * 0.2,
                0.7 + _shimmerAnimation.value * 0.1,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Stack(
          children: [
            // Particule 1
            Positioned(
              top: 100 + _floatingAnimation.value * 50,
              left: 50 + _floatingAnimation.value * 30,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _accentColor.withOpacity(0.3),
                      _accentColor.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),

            // Particule 2
            Positioned(
              top: 200 + _floatingAnimation.value * -40,
              right: 80 + _floatingAnimation.value * 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _secondaryColor.withOpacity(0.4),
                      _secondaryColor.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),

            // Particule 3
            Positioned(
              bottom: 150 + _floatingAnimation.value * 60,
              left: 100 + _floatingAnimation.value * -25,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _primaryColor.withOpacity(0.2),
                      _primaryColor.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Row(
          children: [
            // Logo avec animation de pulsation
            GestureDetector(
              onTap: () => context.go("/"),
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _secondaryColor, _accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.dynamic_form,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'FormBuilder',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Bouton retour avec animation
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => context.go("/"),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: _primaryColor,
                  size: 20,
                ),
                tooltip: 'Retour à l\'accueil',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent(AuthBloc authBloc, bool isMobile, bool isTablet) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 600,
        ),
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 28 : 45),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ],
                      stops: [
                        0.0,
                        0.5 + _shimmerAnimation.value * 0.3,
                      ],
                    ),
                  ),
                  child: authBloc.inscription == 0
                      ? _buildLoginForm(authBloc, isMobile)
                      : _buildSignupForm(authBloc, isMobile),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginForm(AuthBloc authBloc, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre et description
        Center(
          child: Column(
            children: [
              Text(
                'Bon retour !',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connectez-vous à votre compte',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Champ email
        _buildTextField(
          controller: authBloc.email,
          label: 'Adresse email',
          hintText: 'votre@email.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        // Champ mot de passe
        _buildTextField(
          controller: authBloc.password,
          label: 'Mot de passe',
          hintText: 'Votre mot de passe',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: !authBloc.viewPassword,
          onTogglePassword: () => authBloc.setViewPassword(),
        ),

        const SizedBox(height: 30),

        // Bouton de connexion
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: authBloc.chargement
                      ? null
                      : () async {
                          await authBloc.login();
                          if (authBloc.userModel != null) {
                            js.context.callMethod('open', [
                              'https://test-diag.saharux.com/',
                              '_self'
                            ]);
                          }
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: authBloc.chargement
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.login,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Se connecter',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        // Divider avec "ou"
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ou',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),

        const SizedBox(height: 30),

        // Lien vers l'inscription
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pas encore de compte ? ',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () => authBloc.setInscriretion(1),
                child: Text(
                  'S\'inscrire',
                  style: GoogleFonts.inter(
                    color: _primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm(AuthBloc authBloc, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre et description
        Center(
          child: Column(
            children: [
              Text(
                'Créer un compte',
                style: GoogleFonts.inter(
                  fontSize: isMobile ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rejoignez-nous dès aujourd\'hui',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Champs du formulaire d'inscription
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: authBloc.prenom,
                label: 'Prénom',
                hintText: 'Votre prénom',
                prefixIcon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: authBloc.nom,
                label: 'Nom',
                hintText: 'Votre nom',
                prefixIcon: Icons.person_outline,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: authBloc.emailInsc,
          label: 'Adresse email',
          hintText: 'votre@email.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: authBloc.telephone,
          label: 'Téléphone',
          hintText: '+33 6 12 34 56 78',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: authBloc.adresse,
          label: 'Adresse',
          hintText: 'Votre adresse',
          prefixIcon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: authBloc.fonction,
          label: 'Fonction',
          hintText: 'Votre fonction dans l\'entreprise',
          prefixIcon: Icons.work_outline,
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: authBloc.passwordInsc,
          label: 'Mot de passe',
          hintText: 'Votre mot de passe',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: !authBloc.viewPassword,
          onTogglePassword: () => authBloc.setViewPassword(),
        ),

        const SizedBox(height: 20),

        _buildTextField(
          controller: authBloc.confPasswordInsc,
          label: 'Confirmer le mot de passe',
          hintText: 'Confirmez votre mot de passe',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: !authBloc.viewPassword,
          onTogglePassword: () => authBloc.setViewPassword(),
        ),

        const SizedBox(height: 30),

        // Bouton d'inscription
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: authBloc.chargement
                      ? null
                      : () => authBloc.inscriptionfunc(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: authBloc.chargement
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'S\'inscrire',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        // Divider avec "ou"
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ou',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),

        const SizedBox(height: 30),

        // Lien vers la connexion
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Déjà un compte ? ',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () => authBloc.setInscriretion(0),
                child: Text(
                  'Se connecter',
                  style: GoogleFonts.inter(
                    color: _primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  // Animation lors du focus
                },
                child: TextField(
                  controller: controller,
                  obscureText: isPassword && !isPasswordVisible,
                  keyboardType: keyboardType,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey.shade900,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: GoogleFonts.inter(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        prefixIcon,
                        color: _primaryColor,
                        size: 20,
                      ),
                    ),
                    suffixIcon: isPassword
                        ? Container(
                            padding: const EdgeInsets.all(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: onTogglePassword,
                              child: Icon(
                                isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _primaryColor,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
