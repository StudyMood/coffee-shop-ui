import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

/// An elegant, animated 1-tap Theme Toggle Button (Light ☀️ / Dark 🌙).
/// Long-press allows selecting Light, Dark, or System Default.
class ThemeToggleButton extends ConsumerWidget {
  final double size;
  final EdgeInsetsGeometry padding;

  const ThemeToggleButton({
    super.key,
    this.size = 42,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tooltip = themeMode == ThemeMode.dark
        ? 'Switch to Light Mode'
        : (themeMode == ThemeMode.light
            ? 'Switch to Dark Mode'
            : (isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'));

    return Padding(
      padding: padding,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            ref.read(themeModeProvider.notifier).toggleTheme();
          },
          onLongPress: () => showThemePickerSheet(context, ref),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.cardDark
                  : AppColors.primaryCoffee.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? AppColors.borderDark
                    : AppColors.primaryCoffee.withOpacity(0.2),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : AppColors.primaryCoffee.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) {
                  return RotationTransition(
                    turns: anim,
                    child: ScaleTransition(scale: anim, child: child),
                  );
                },
                child: isDark
                    ? const Icon(
                        Icons.nightlight_round,
                        key: ValueKey('dark_icon'),
                        color: AppColors.accentGold,
                        size: 20,
                      )
                    : const Icon(
                        Icons.wb_sunny_rounded,
                        key: ValueKey('light_icon'),
                        color: AppColors.accentGold,
                        size: 21,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A clean, modern Segmented Selector for Light / Dark / System modes.
/// Ideal for the Profile Screen or Settings screen.
class ThemeModeSegmentedControl extends ConsumerWidget {
  const ThemeModeSegmentedControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          _buildSegment(
            context: context,
            ref: ref,
            title: 'Light',
            icon: Icons.light_mode_rounded,
            mode: ThemeMode.light,
            isSelected: currentMode == ThemeMode.light,
          ),
          _buildSegment(
            context: context,
            ref: ref,
            title: 'Dark',
            icon: Icons.dark_mode_rounded,
            mode: ThemeMode.dark,
            isSelected: currentMode == ThemeMode.dark,
          ),
          _buildSegment(
            context: context,
            ref: ref,
            title: 'System',
            icon: Icons.settings_brightness_rounded,
            mode: ThemeMode.system,
            isSelected: currentMode == ThemeMode.system,
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.cardDark : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.primaryCoffee
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColors.textDark)
                      : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a quick modal bottom sheet for theme selection
void showThemePickerSheet(BuildContext context, WidgetRef ref) {
  final currentMode = ref.read(themeModeProvider);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Choose Appearance',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select your preferred theme mode for a comfortable view',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                context: ctx,
                ref: ref,
                title: 'Light Theme',
                subtitle: 'Bright, clean, and warm coffee palette',
                icon: Icons.light_mode_rounded,
                iconColor: AppColors.accentGold,
                mode: ThemeMode.light,
                isSelected: currentMode == ThemeMode.light,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildThemeOption(
                context: ctx,
                ref: ref,
                title: 'Dark Theme',
                subtitle: 'Sleek, deep espresso and battery friendly',
                icon: Icons.dark_mode_rounded,
                iconColor: AppColors.primaryCoffee,
                mode: ThemeMode.dark,
                isSelected: currentMode == ThemeMode.dark,
                isDark: isDark,
              ),
              const SizedBox(height: 10),
              _buildThemeOption(
                context: ctx,
                ref: ref,
                title: 'System Default',
                subtitle: 'Follows your device operating system appearance',
                icon: Icons.settings_brightness_rounded,
                iconColor: isDark ? Colors.white70 : AppColors.textDark,
                mode: ThemeMode.system,
                isSelected: currentMode == ThemeMode.system,
                isDark: isDark,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildThemeOption({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required ThemeMode mode,
  required bool isSelected,
  required bool isDark,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      ref.read(themeModeProvider.notifier).setMode(mode);
      Navigator.of(context).pop();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryCoffee.withOpacity(0.12)
            : (isDark ? AppColors.cardDark : AppColors.backgroundLight),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryCoffee
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isSelected ? 1.8 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primaryCoffee,
              size: 22,
            ),
        ],
      ),
    ),
  );
}
