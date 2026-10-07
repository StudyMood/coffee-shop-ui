import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:brew_haven/features/stores_map/presentation/screens/stores_map_screen.dart';
import 'package:brew_haven/features/loyalty/presentation/screens/loyalty_screen.dart';

/// Professional, rich app footer component for the bottom of screens.
/// Features artisanal brand badge, quality assurance pillars, quick links,
/// cafe opening hours, customer care support, social links, and copyright info.
class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141210) : const Color(0xFFF9F6F0),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Brand Logo Mark & Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.coffeeGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryCoffee.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.coffee_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'CAFFÈ ROYALE',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: isDark ? Colors.white : AppColors.primaryEspresso,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Artisanal Coffee Roasters & Specialty Café',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // 3 Quality Guarantee Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTrustPillar(
                icon: Icons.verified_rounded,
                label: '100% Arabica',
                sub: 'Single Origin',
                isDark: isDark,
              ),
              Container(
                height: 30,
                width: 1,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              _buildTrustPillar(
                icon: Icons.local_fire_department_rounded,
                label: 'Freshly Roasted',
                sub: 'Small Batches',
                isDark: isDark,
              ),
              Container(
                height: 30,
                width: 1,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              _buildTrustPillar(
                icon: Icons.eco_rounded,
                label: 'Eco Friendly',
                sub: 'Zero Plastic',
                isDark: isDark,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Quick Action Links Pills
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildFooterLink(
                context,
                title: 'Our Outlets',
                icon: Icons.location_on_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StoresMapScreen()),
                ),
              ),
              _buildFooterLink(
                context,
                title: 'Book a Table',
                icon: Icons.table_bar_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BookingsScreen()),
                ),
              ),
              _buildFooterLink(
                context,
                title: 'Rewards & Perks',
                icon: Icons.card_giftcard_outlined,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LoyaltyScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Cafe Timings & Support Info Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_filled_rounded,
                  color: AppColors.accentGold,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Daily 7:00 AM – 11:00 PM  •  Support: +91 98765 43210',
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Social Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.camera_alt_outlined, isDark),
              const SizedBox(width: 12),
              _buildSocialIcon(Icons.tag_rounded, isDark),
              const SizedBox(width: 12),
              _buildSocialIcon(Icons.share_outlined, isDark),
              const SizedBox(width: 12),
              _buildSocialIcon(Icons.mail_outline_rounded, isDark),
            ],
          ),
          const SizedBox(height: 20),

          // Divider
          Divider(
            color: isDark ? AppColors.borderDark.withOpacity(0.5) : AppColors.borderLight,
            height: 1,
          ),
          const SizedBox(height: 16),

          // Copyright & Version
          Text(
            '© 2026 Caffè Royale Coffee Co. • Crafted with passion for coffee lovers',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'v2.4.0 • Artisanal Specialty Blend',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryCoffee.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustPillar({
    required IconData icon,
    required String label,
    required String sub,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryCoffee, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        Text(
          sub,
          style: GoogleFonts.outfit(
            fontSize: 10,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLink(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primaryCoffee),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Icon(
        icon,
        size: 16,
        color: isDark ? Colors.white70 : AppColors.textDark,
      ),
    );
  }
}

/// Standalone, reusable bottom navigation bar footer component.
class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _buildNavItem(context, 1, Icons.search_rounded, Icons.search_outlined, 'Explore'),
              _buildNavItem(context, 2, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Orders'),
              _buildNavItem(context, 3, Icons.table_restaurant_rounded, Icons.table_restaurant_outlined, 'Booking'),
              _buildNavItem(context, 4, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTabSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryCoffee.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 24,
              color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
