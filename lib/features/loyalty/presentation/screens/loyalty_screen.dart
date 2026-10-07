import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final points = user?.loyaltyPoints ?? 340;

    final rewards = [
      {
        'title': 'Complimentary Specialty Coffee',
        'desc': 'Redeem any hot or iced handcrafted latte/cappuccino',
        'cost': 100,
        'icon': Icons.coffee_rounded,
      },
      {
        'title': 'Fresh Viennoiserie Pastry',
        'desc': 'Choice of butter croissant or fudge walnut brownie',
        'cost': 150,
        'icon': Icons.bakery_dining_rounded,
      },
      {
        'title': 'Artisan Coffee Bean Bag (250g)',
        'desc': 'Whole bean single origin Ethiopian Yirgacheffe',
        'cost': 500,
        'icon': Icons.inventory_2_rounded,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caffè Royale Loyalty'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gold Tier Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2C1810), Color(0xFF4A2810), Color(0xFFC67C4E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.stars_rounded, color: AppColors.accentGold, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'GOLD MEMBER',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Caffè Royale Club',
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$points',
                    style: GoogleFonts.outfit(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Available Loyalty Points',
                    style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  // Progress Bar to next reward (500 pts)
                  LinearProgressIndicator(
                    value: (points / 500).clamp(0.0, 1.0),
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${500 - (points % 500)} points needed for next Premium Merch reward',
                    style: GoogleFonts.outfit(fontSize: 11, color: Colors.white60),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rules Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryCoffee.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.primaryCoffee, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Earn 10 points for every ₹100 spent. Redeem anytime with no expiration.',
                      style: GoogleFonts.outfit(fontSize: 12, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Rewards List
            Text(
              'Redeem Rewards',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...rewards.map((reward) {
              final cost = reward['cost'] as int;
              final canRedeem = points >= cost;

              return GlassCard(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCoffee.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(reward['icon'] as IconData, color: AppColors.primaryCoffee, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward['title'] as String,
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            reward['desc'] as String,
                            style: GoogleFonts.outfit(fontSize: 11, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$cost Points',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: canRedeem
                          ? () async {
                              await ref.read(authServiceProvider).updateLoyaltyPoints(-cost);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.accentGreen,
                                    content: Text('Redeemed "${reward['title']}"! Voucher generated.'),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryCoffee,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Redeem', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
