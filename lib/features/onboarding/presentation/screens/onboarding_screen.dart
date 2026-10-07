import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/constants/app_assets.dart';
import 'package:brew_haven/core/storage/local_storage_service.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/features/auth/presentation/screens/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _finishOnboarding() async {
    await LocalStorageService.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: animation,
          child: const SignInScreen(),
        ),
        transitionDuration: const Duration(milliseconds: 400),
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
          // Background subtle ambient glow
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryCoffee.withOpacity(0.18),
                    Colors.transparent,
                  ],
                  radius: 0.8,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      // Top Brand Navigation Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.accentGold.withOpacity(0.35),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.coffee_rounded,
                                  size: 16,
                                  color: AppColors.accentGold,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'CAFFÈ ROYALE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.6,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: _finishOnboarding,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(flex: 1),

                      // Center Animated Multi-Image Collage Showcase
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= 600;
                          final containerHeight = isWide ? 330.0 : 260.0;
                          final cardWidth = isWide ? 200.0 : 145.0;
                          final cardHeight = isWide ? 280.0 : 210.0;
                          final centerCardWidth = isWide ? 230.0 : 170.0;
                          final centerCardHeight = isWide ? 315.0 : 240.0;
                          final offsetDistance = isWide ? 115.0 : 75.0;

                          return SizedBox(
                            height: containerHeight,
                            width: constraints.maxWidth,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                // 1. LEFT CARD (Espresso Art) - Tilted left & flying in
                                Transform.translate(
                                  offset: Offset(-offsetDistance, isWide ? 10 : 12),
                                  child: Transform.rotate(
                                    angle: -7 * (math.pi / 180),
                                    child: _buildImageCard(
                                      image: AppAssets.luxuryEspressoArt,
                                      title: 'Dark Roast',
                                      subtitle: 'Single Origin',
                                      width: cardWidth,
                                      height: cardHeight,
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
                                    .move(
                                      begin: const Offset(-100, 60),
                                      end: Offset.zero,
                                      duration: 850.ms,
                                      curve: Curves.easeOutBack,
                                    )
                                    .scale(
                                      begin: const Offset(0.65, 0.65),
                                      end: const Offset(1, 1),
                                      duration: 850.ms,
                                      curve: Curves.easeOutBack,
                                    ),

                                // 2. RIGHT CARD (Cold Brew) - Tilted right & flying in
                                Transform.translate(
                                  offset: Offset(offsetDistance, isWide ? 10 : 12),
                                  child: Transform.rotate(
                                    angle: 7 * (math.pi / 180),
                                    child: _buildImageCard(
                                      image: AppAssets.luxuryColdBrew,
                                      title: 'Cold Brew',
                                      subtitle: '20h Steeped',
                                      width: cardWidth,
                                      height: cardHeight,
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
                                    .move(
                                      begin: const Offset(100, 60),
                                      end: Offset.zero,
                                      duration: 850.ms,
                                      curve: Curves.easeOutBack,
                                    )
                                    .scale(
                                      begin: const Offset(0.65, 0.65),
                                      end: const Offset(1, 1),
                                      duration: 850.ms,
                                      curve: Curves.easeOutBack,
                                    ),

                                // 3. CENTER HERO CARD (Latte Art) - Prominent, highest elevation
                                _buildImageCard(
                                  image: AppAssets.luxuryLatteArt,
                                  title: 'Swan Latte Art',
                                  subtitle: 'Microfoam Velvet',
                                  width: centerCardWidth,
                                  height: centerCardHeight,
                                  isHero: true,
                                )
                                    .animate()
                                    .fadeIn(duration: 700.ms, curve: Curves.easeOutCubic)
                                    .move(
                                      begin: const Offset(0, 80),
                                      end: Offset.zero,
                                      duration: 800.ms,
                                      curve: Curves.easeOutBack,
                                    )
                                    .scale(
                                      begin: const Offset(0.7, 0.7),
                                      end: const Offset(1, 1),
                                      duration: 800.ms,
                                      curve: Curves.easeOutBack,
                                    )
                                    .animate(onPlay: (c) => c.repeat(reverse: true))
                                    .moveY(
                                      begin: 0,
                                      end: -7,
                                      duration: 2400.ms,
                                      curve: Curves.easeInOut,
                                    ),

                                // 4. Floating Rating Badge Pill
                                Positioned(
                                  bottom: -8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceDark.withOpacity(0.92),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.accentGold.withOpacity(0.6),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 14,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: AppColors.accentGold,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '4.9 ★ (12k+ Brew Lovers)',
                                          style: GoogleFonts.outfit(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                      .animate(delay: 500.ms)
                                      .fadeIn(duration: 600.ms)
                                      .scale(
                                        begin: const Offset(0.6, 0.6),
                                        end: const Offset(1, 1),
                                        curve: Curves.easeOutBack,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const Spacer(flex: 1),

                      // Text Content Section (Centered)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Luxury Tag Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.accentGold.withOpacity(0.25),
                                  AppColors.accentGold.withOpacity(0.08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.accentGold.withOpacity(0.65),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 13,
                                  color: AppColors.accentGold,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'ARTISANAL SPECIALTY CAFE',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.4,
                                    color: AppColors.accentGold,
                                  ),
                                ),
                              ],
                            ),
                          ).animate(delay: 350.ms).fadeIn().moveY(begin: 12, end: 0),

                          const SizedBox(height: 16),

                          // Main Headline
                          Text(
                            'Crafted With Passion,\nBrewed To Perfection',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              letterSpacing: -0.3,
                              color: Colors.white,
                            ),
                          ).animate(delay: 450.ms).fadeIn(duration: 450.ms).moveY(begin: 12, end: 0),

                          const SizedBox(height: 10),

                          // Subtitle Description
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Text(
                              'Single-origin Arabica beans roasted in micro-batches and hand-pulled by master baristas.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                height: 1.45,
                                color: Colors.white.withOpacity(0.72),
                              ),
                            ),
                          ).animate(delay: 550.ms).fadeIn(duration: 450.ms).moveY(begin: 10, end: 0),
                        ],
                      ),

                      const Spacer(flex: 1),

                      // Next Screen CTA Button
                      GestureDetector(
                        onTap: _finishOnboarding,
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 380),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFC67C4E),
                                Color(0xFFA05324),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.accentGold.withOpacity(0.55),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryCoffee.withOpacity(0.45),
                                blurRadius: 22,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Enter Cafe',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 19,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate(delay: 650.ms)
                          .fadeIn(duration: 500.ms)
                          .scale(
                            begin: const Offset(0.92, 0.92),
                            end: const Offset(1, 1),
                            curve: Curves.easeOutBack,
                          )
                          .shimmer(delay: 1500.ms, duration: 1500.ms, color: Colors.white24),

                      const SizedBox(height: 14),
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

  // Helper to build a luxury framed image card
  Widget _buildImageCard({
    required String image,
    required String title,
    required String subtitle,
    required double width,
    required double height,
    bool isHero = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isHero
              ? AppColors.accentGold.withOpacity(0.65)
              : AppColors.accentGold.withOpacity(0.28),
          width: isHero ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isHero ? 0.65 : 0.45),
            blurRadius: isHero ? 32 : 20,
            offset: const Offset(0, 10),
          ),
          if (isHero)
            BoxShadow(
              color: AppColors.primaryCoffee.withOpacity(0.35),
              blurRadius: 36,
              spreadRadius: 2,
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(
            imageUrl: image,
            fit: BoxFit.cover,
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0.45, 0.7, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Bottom Card Label
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: isHero ? 14 : 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: isHero ? 11 : 9.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
