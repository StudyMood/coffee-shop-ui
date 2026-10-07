import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _orderUpdates = true;
  bool _promoAlerts = false;

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance & Theme Mode Section
            Text(
              'Appearance',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: currentThemeMode,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('Light Theme', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    secondary: const Icon(Icons.light_mode_rounded, color: AppColors.accentGold),
                    onChanged: (mode) {
                      if (mode != null) ref.read(themeModeProvider.notifier).setMode(mode);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: currentThemeMode,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('Dark Theme', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    secondary: const Icon(Icons.dark_mode_rounded, color: AppColors.primaryCoffee),
                    onChanged: (mode) {
                      if (mode != null) ref.read(themeModeProvider.notifier).setMode(mode);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: currentThemeMode,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('System Default', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    secondary: const Icon(Icons.settings_suggest_rounded, color: AppColors.textMutedLight),
                    onChanged: (mode) {
                      if (mode != null) ref.read(themeModeProvider.notifier).setMode(mode);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Multi-Language Support (English, Hindi, Arabic RTL)
            Text(
              'Language / भाषा / اللغة',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'en',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('English (US/UK)', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    secondary: const Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    onChanged: (code) {
                      if (code != null) ref.read(localeProvider.notifier).setLocale(code);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'hi',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('हिन्दी (Hindi)', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    secondary: const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                    onChanged: (code) {
                      if (code != null) ref.read(localeProvider.notifier).setLocale(code);
                    },
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    value: 'ar',
                    groupValue: currentLocale.languageCode,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('العربية (Arabic - RTL)', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    secondary: const Text('🇦🇪', style: TextStyle(fontSize: 20)),
                    onChanged: (code) {
                      if (code != null) ref.read(localeProvider.notifier).setLocale(code);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Notification Settings
            Text(
              'Notifications',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _notificationsEnabled,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('Push Notifications', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Receive notifications for brew & perks', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _orderUpdates,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('Order Status Updates', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Real-time timeline changes and arrival notifications', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
                    onChanged: (val) => setState(() => _orderUpdates = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _promoAlerts,
                    activeColor: AppColors.primaryCoffee,
                    title: Text('Special Offers & Coupons', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Seasonal discounts and holiday offers', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
                    onChanged: (val) => setState(() => _promoAlerts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About & Legal
            Text(
              'About Caffè Royale',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Privacy Policy', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text('Terms of Service', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Text('App Version', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
                    trailing: Text('1.0.0 (Production Build)', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
