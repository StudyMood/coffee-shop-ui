import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_assets.dart';

/// Coffee item data model for the interactive hero slider
class HeroCoffeeSlide {
  final String title;
  final String subtitle;
  final String badgeText;
  final String imagePath;
  final String price;
  final double rating;
  final Color accentColor;

  const HeroCoffeeSlide({
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.accentColor,
  });
}

/// Dribbble-inspired 3D Animated Hero Section
/// Features:
/// - Side-by-side Row layout on wide/desktop screens (Text on Left, Image Slider on Right)
/// - Multi-image interactive coffee slider with auto-play & smooth transitions
/// - Floating 3D zero-gravity harmonic animation
/// - Navigation arrows, indicator dots & quick thumbnail row
/// - Luxury typography, live feature chip, stats & customer testimonial
class Dribbble3DHeroSection extends StatefulWidget {
  final VoidCallback onOrderNow;
  final VoidCallback onExploreMenu;

  const Dribbble3DHeroSection({
    super.key,
    required this.onOrderNow,
    required this.onExploreMenu,
  });

  @override
  State<Dribbble3DHeroSection> createState() => _Dribbble3DHeroSectionState();
}

class _Dribbble3DHeroSectionState extends State<Dribbble3DHeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;

  final List<HeroCoffeeSlide> _slides = const [
    HeroCoffeeSlide(
      title: 'Velvet Roast Splash',
      subtitle: 'Single-origin micro-roasted arabica with creamy crema',
      badgeText: '3D Velvet Roast',
      imagePath: AppAssets.hero3dSplash,
      price: '\$4.50',
      rating: 4.9,
      accentColor: Color(0xFFE5A96A),
    ),
    HeroCoffeeSlide(
      title: 'Artisanal Cappuccino',
      subtitle: 'Silky micro-foam dusted with cocoa & roasted espresso',
      badgeText: '3D Royal Froth',
      imagePath: AppAssets.cappuccino3d,
      price: '\$5.20',
      rating: 5.0,
      accentColor: Color(0xFFD4AC83),
    ),
    HeroCoffeeSlide(
      title: 'Americano Classico',
      subtitle: 'Double espresso extraction over pure glacier water',
      badgeText: '3D Pure Essence',
      imagePath: AppAssets.americano3d,
      price: '\$4.00',
      rating: 4.8,
      accentColor: Color(0xFFC67C4E),
    ),
    HeroCoffeeSlide(
      title: 'Golden Leaf Latte Art',
      subtitle: 'Intricate barista rosetta with steamed whole milk',
      badgeText: 'Signature Blend',
      imagePath: AppAssets.luxuryLatteArt,
      price: '\$5.50',
      rating: 4.9,
      accentColor: Color(0xFFF39C12),
    ),
    HeroCoffeeSlide(
      title: 'Glacial Cold Brew',
      subtitle: '24h cold-steeped reserve with rich velvet head',
      badgeText: 'Cold Drip Reserve',
      imagePath: AppAssets.luxuryColdBrew,
      price: '\$5.80',
      rating: 5.0,
      accentColor: Color(0xFF3498DB),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _goToPage(int page) {
    if (page < 0) page = _slides.length - 1;
    if (page >= _slides.length) page = 0;
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _slides[_currentPage].accentColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF22150E),
            Color(0xFF160D08),
            Color(0xFF0F0805),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: activeColor.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AC83).withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Dynamic ambient warm radial backlight
            Positioned(
              top: 40,
              right: -30,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      activeColor.withOpacity(0.28),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 720;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Column: Text, CTAs, Stats & Testimonial
                        Expanded(
                          flex: 11,
                          child: _buildTextContent(),
                        ),
                        const SizedBox(width: 24),
                        // Right Column: Slider & Navigation
                        Expanded(
                          flex: 9,
                          child: _buildSliderSection(isWide: true),
                        ),
                      ],
                    );
                  } else {
                    // Mobile Portrait / Narrow layout
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopLuxuryTag(),
                        const SizedBox(height: 12),
                        _buildHeadline(),
                        const SizedBox(height: 10),
                        _buildSubtitle(),
                        const SizedBox(height: 18),
                        _buildSliderSection(isWide: false),
                        const SizedBox(height: 18),
                        _buildActiveSlideChip(),
                        const SizedBox(height: 16),
                        _buildButtons(),
                        const SizedBox(height: 18),
                        _buildStatsBar(),
                        const SizedBox(height: 14),
                        _buildTestimonialSnippet(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Left Column / Text Content ---
  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTopLuxuryTag(),
        const SizedBox(height: 12),
        _buildHeadline(),
        const SizedBox(height: 10),
        _buildSubtitle(),
        const SizedBox(height: 14),
        _buildActiveSlideChip(),
        const SizedBox(height: 18),
        _buildButtons(),
        const SizedBox(height: 20),
        _buildStatsBar(),
        const SizedBox(height: 16),
        _buildTestimonialSnippet(),
      ],
    );
  }

  Widget _buildTopLuxuryTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AC83).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AC83).withOpacity(0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFE5A96A),
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            'CRAFTED FOR TRUE COFFEE LOVERS',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: const Color(0xFFE5A96A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      'Art Of\nPerfect Coffee',
      style: GoogleFonts.playfairDisplay(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        height: 1.12,
        color: const Color(0xFFF9F5F0),
        letterSpacing: -0.5,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Experience the rich, bold flavors of our artisanal coffee blends. Every bean micro-roasted to awaken your senses and spark your day.',
      style: GoogleFonts.outfit(
        fontSize: 13,
        height: 1.45,
        color: const Color(0xFFD5C7B8),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildActiveSlideChip() {
    final activeSlide = _slides[_currentPage];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: activeSlide.accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: activeSlide.accentColor.withOpacity(0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.coffee_rounded, size: 14, color: activeSlide.accentColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              'Featured: ${activeSlide.title}',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: activeSlide.accentColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: activeSlide.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              activeSlide.price,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onOrderNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC67C4E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 4,
              shadowColor: const Color(0xFFC67C4E).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.coffee_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Order Now',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onExploreMenu,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF9F5F0),
              side: BorderSide(
                color: const Color(0xFFD4AC83).withOpacity(0.5),
                width: 1.4,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Explore Menu',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('50+', 'Item of Coffee'),
          Container(
            width: 1,
            height: 28,
            color: Colors.white.withOpacity(0.12),
          ),
          _buildStatItem('20+', 'Order Running'),
          Container(
            width: 1,
            height: 28,
            color: Colors.white.withOpacity(0.12),
          ),
          _buildStatItem('2k+', 'Happy Customer'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.playfairDisplay(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFE5A96A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFB3A598),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialSnippet() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E140E).withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC67C4E).withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 17,
            backgroundColor: Color(0xFFC67C4E),
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star_rounded,
                          size: 13,
                          color: Color(0xFFFFB300),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '5.0 Rated',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFFFD54F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '"The best artisanal espresso and cappuccino in the city. The aroma and microfoam are pure art!"',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: const Color(0xFFECE3DA),
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '— Sophia M., Coffee Connoisseur',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFC67C4E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Right Column / Interactive 3D Coffee Slider ---
  Widget _buildSliderSection({required bool isWide}) {
    final activeSlide = _slides[_currentPage];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating 3D Animated Slider Container
        AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            final val = _animController.value;
            final dy = math.sin(val * math.pi * 2) * 8.0;
            final rot = math.sin(val * math.pi * 2) * 0.015;

            return Transform.translate(
              offset: Offset(0, dy),
              child: Transform.rotate(
                angle: rot,
                child: child,
              ),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glowing Ground shadow
              Positioned(
                bottom: 2,
                child: Container(
                  width: 220,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 22,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

              // The Slider Card
              Container(
                height: isWide ? 340 : 270,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: activeSlide.accentColor.withOpacity(0.25),
                      blurRadius: 28,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: activeSlide.accentColor.withOpacity(0.4),
                    width: 1.4,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),
                  child: Stack(
                    children: [
                      // PageView with Coffee Images
                      PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          final slide = _slides[index];
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                slide.imagePath,
                                fit: BoxFit.cover,
                              ),
                              // Top gradient for badge contrast
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.center,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Bottom dark gradient for text readability
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.85),
                                      Colors.black.withOpacity(0.95),
                                    ],
                                  ),
                                ),
                              ),
                              // Floating 3D Badge (Top Right)
                              Positioned(
                                top: 14,
                                right: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: slide.accentColor.withOpacity(0.6),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.auto_awesome_rounded,
                                        color: Color(0xFFFFD54F),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        slide.badgeText,
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Slide Title, Subtitle, Price & Rating in a clean Row at the bottom
                              Positioned(
                                left: 14,
                                right: 14,
                                bottom: 12,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            slide.title,
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            slide.subtitle,
                                            style: GoogleFonts.outfit(
                                              fontSize: 11,
                                              color: const Color(0xFFD5C7B8),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFB300).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFFFFB300).withOpacity(0.5),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB300)),
                                              const SizedBox(width: 3),
                                              Text(
                                                slide.rating.toString(),
                                                style: GoogleFonts.outfit(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFFFFD54F),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          slide.price,
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: slide.accentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // Prev Navigation Chevron
                      Positioned(
                        left: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _buildNavArrow(
                            icon: Icons.chevron_left_rounded,
                            onTap: () => _goToPage(_currentPage - 1),
                          ),
                        ),
                      ),

                      // Next Navigation Chevron
                      Positioned(
                        right: 8,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: _buildNavArrow(
                            icon: Icons.chevron_right_rounded,
                            onTap: () => _goToPage(_currentPage + 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Indicator Dots in a Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isActive = _currentPage == index;
            return GestureDetector(
              onTap: () => _goToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 7,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isActive ? _slides[index].accentColor : Colors.white.withOpacity(0.25),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: _slides[index].accentColor.withOpacity(0.6),
                            blurRadius: 6,
                          )
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 10),

        // Quick Coffee Thumbnails Selector in a Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_slides.length, (index) {
            final isSelected = _currentPage == index;
            final slide = _slides[index];
            return GestureDetector(
              onTap: () => _goToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isSelected ? 42 : 36,
                height: isSelected ? 42 : 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? slide.accentColor : Colors.white.withOpacity(0.2),
                    width: isSelected ? 2.2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: slide.accentColor.withOpacity(0.55),
                            blurRadius: 8,
                          )
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    slide.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNavArrow({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.65),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
