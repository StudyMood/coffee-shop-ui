import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final code = user?.referralCode ?? 'BREWCOFFEE';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer & Earn'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero Referral Illustration Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.coffeeGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCoffee.withOpacity(0.35),
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
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Give ₹100, Get ₹100',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Invite fellow coffee lovers. When they place their first order, you both get 100 Bonus Loyalty Points!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Referral Code Box
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'YOUR UNIQUE REFERRAL CODE',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCoffee.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primaryCoffee,
                        style: BorderStyle.solid,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          code,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: AppColors.primaryCoffee,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: AppColors.primaryCoffee),
                          tooltip: 'Copy Code',
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Referral code copied to clipboard!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Share via WhatsApp / Messages',
                    icon: Icons.share_rounded,
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: 'Join me on Caffè Royale! Use my code $code to get 100 bonus coffee points: https://cafferoyale.app/join?code=$code'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invite link copied! Paste into your chat app.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // How It Works Step Timeline
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'How Referral Works',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 16),
            _buildStepRow(
              step: '1',
              title: 'Send an Invitation',
              desc: 'Share your personal referral link or code with friends and colleagues.',
              isDark: isDark,
            ),
            _buildStepRow(
              step: '2',
              title: 'Friend Creates Account',
              desc: 'They sign up on Caffè Royale app and apply your code during registration.',
              isDark: isDark,
            ),
            _buildStepRow(
              step: '3',
              title: 'First Handcrafted Order',
              desc: 'Once their first latte or cold brew is placed, both wallets instantly receive +100 Points.',
              isDark: isDark,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String step,
    required String title,
    required String desc,
    required bool isDark,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.primaryCoffee,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    step,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primaryCoffeeLight,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(desc, style: GoogleFonts.outfit(fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
