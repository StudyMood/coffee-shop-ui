import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/constants/app_assets.dart';
import 'package:brew_haven/core/storage/local_storage_service.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:brew_haven/features/home/presentation/screens/main_navigation_shell.dart';
import 'package:brew_haven/features/auth/presentation/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleRouting();
  }

  Future<void> _handleRouting() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    final isOnboardingDone = LocalStorageService.isOnboardingCompleted();
    final userSession = LocalStorageService.getUserSession();

    Widget destination;
    if (!isOnboardingDone) {
      destination = const OnboardingScreen();
    } else if (userSession != null) {
      destination = const MainNavigationShell();
    } else {
      destination = const SignInScreen();
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: destination,
        ),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryEspresso,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background coffee image with luxury dark vignette overlay
          Opacity(
            opacity: 0.28,
            child: AppImage(
              imageUrl: AppAssets.heroSplash,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryEspresso.withOpacity(0.85),
                  AppColors.primaryEspresso.withOpacity(0.98),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Glowing Emblem
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryCoffee.withOpacity(0.4),
                        blurRadius: 36,
                        spreadRadius: 6,
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primaryCoffee.withOpacity(0.6),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.coffee_rounded,
                      size: 56,
                      color: AppColors.primaryCoffee,
                    ),
                  ),
                )
                    .animate()
                    .scale(duration: 800.ms, curve: Curves.easeOutBack)
                    .shimmer(duration: 1200.ms, color: Colors.white24),
                const SizedBox(height: 28),
                // Brand Name
                Text(
                  'Caffè Royale',
                  style: GoogleFonts.outfit(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                const SizedBox(height: 8),
                // Tagline
                Text(
                  'Crafted with Passion • Brewed to Perfection',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    letterSpacing: 1.1,
                    color: AppColors.primaryCoffeeLight.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ).animate().fadeIn(delay: 600.ms).moveY(begin: 15, end: 0),
                const SizedBox(height: 50),
                // Subtle loader
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryCoffee.withOpacity(0.8),
                    ),
                  ),
                ).animate().fadeIn(delay: 900.ms),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v1.0.0 • Speciality Coffee Co.',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
