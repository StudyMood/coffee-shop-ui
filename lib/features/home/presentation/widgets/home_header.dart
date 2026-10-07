import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/constants/app_assets.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/core/widgets/theme_toggle_button.dart';
import 'package:brew_haven/features/search/presentation/screens/search_screen.dart';
import 'package:brew_haven/features/products/presentation/screens/filter_sort_dialog.dart';
import 'package:brew_haven/features/profile/presentation/screens/profile_screen.dart';
import 'package:brew_haven/features/admin/presentation/screens/admin_dashboard_screen.dart';

/// Professional, modular header widget for the home screen and app pages.
/// Contains location indicator, greeting, theme toggle, avatar, search bar, and filter trigger.
class HomeHeader extends ConsumerWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    this.onSearchTap,
    this.onFilterTap,
    this.onLocationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Location Indicator, Quick Theme Switcher & Profile Avatar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location & Outlet Status
                    GestureDetector(
                      onTap: onLocationTap,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCoffee.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primaryCoffee,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Caffè Royale Indiranagar',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : AppColors.textMutedLight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: isDark ? Colors.white54 : AppColors.textMutedLight,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          // Live status indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'OPEN',
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accentGreen,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Greeting text
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          user != null
                              ? (user.isAdmin ? 'Hello, Admin ☕' : 'Hello, ${user.name.split(' ').first} ☕')
                              : 'Welcome to Caffè Royale ☕',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.textDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (user?.isAdmin == true)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.accentRed.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.accentRed.withOpacity(0.6),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.admin_panel_settings_rounded, size: 12, color: AppColors.accentRed),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ADMIN HUB',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.accentRed,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Quick Theme Mode Toggle Button
              const ThemeToggleButton(),
              const SizedBox(width: 10),
              // Profile Avatar
              GestureDetector(
                onTap: onProfileTap ??
                    () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ProfileScreen()),
                      );
                    },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryCoffee.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: AppImage(
                      imageUrl: (user?.profileImage != null && user!.profileImage.isNotEmpty)
                          ? user.profileImage
                          : AppAssets.defaultAvatar,
                      width: 38,
                      height: 38,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Search Bar & Filter Action
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onSearchTap ??
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          color: AppColors.primaryCoffee,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Search your favorite brew or snack...',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onFilterTap ??
                    () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const FilterSortDialog(),
                      );
                    },
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.coffeeGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryCoffee.withOpacity(0.32),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
