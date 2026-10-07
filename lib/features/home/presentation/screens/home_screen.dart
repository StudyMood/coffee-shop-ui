import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/home/presentation/widgets/dribbble_3d_hero_section.dart';
import 'package:brew_haven/features/home/presentation/widgets/dribbble_newsletter_card.dart';
import 'package:brew_haven/features/home/presentation/widgets/category_selector.dart';
import 'package:brew_haven/features/home/presentation/widgets/product_card.dart';
import 'package:brew_haven/features/home/presentation/widgets/ai_recommendations_shelf.dart';
import 'package:brew_haven/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:brew_haven/features/scanner/presentation/screens/qr_scanner_screen.dart';
import 'package:brew_haven/features/stores_map/presentation/screens/stores_map_screen.dart';
import 'package:brew_haven/features/home/presentation/widgets/home_header.dart';
import 'package:brew_haven/features/home/presentation/widgets/home_footer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Elegant Clean Modular Header Sliver
          const SliverToBoxAdapter(
            child: HomeHeader(),
          ),

          // Quick Action Shortcuts (Table Booking, QR Scanner, Outlets)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  _buildQuickAction(
                    context: context,
                    title: 'Book Table',
                    icon: Icons.table_restaurant_rounded,
                    color: AppColors.primaryCoffee,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BookingsScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    context: context,
                    title: 'Scan QR Menu',
                    icon: Icons.qr_code_scanner_rounded,
                    color: AppColors.accentGold,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickAction(
                    context: context,
                    title: 'Our Outlets',
                    icon: Icons.map_rounded,
                    color: AppColors.accentGreen,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const StoresMapScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dribbble-inspired 3D Animated Hero Section (Art Of Perfect Coffee)
          SliverToBoxAdapter(
            child: Dribbble3DHeroSection(
              onOrderNow: () {
                ref.read(selectedCategoryProvider.notifier).state = 'All';
              },
              onExploreMenu: () {
                ref.read(selectedCategoryProvider.notifier).state = 'All';
              },
            ),
          ),

          // Categories Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 18),
              child: CategorySelector(
                selectedCategory: selectedCategory,
                onCategorySelected: (cat) {
                  ref.read(selectedCategoryProvider.notifier).state = cat;
                },
              ),
            ),
          ),

          // AI Recommendations Shelf
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: AiRecommendationsShelf(),
            ),
          ),

          // Header for Main Coffee Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedCategory == 'All' ? 'Signature Brews' : '$selectedCategory Selections',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${filteredProducts.length} items',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryCoffee,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            sliver: filteredProducts.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off_rounded, size: 54, color: AppColors.textMutedLight),
                            const SizedBox(height: 12),
                            Text(
                              'No products found in $selectedCategory',
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 210,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ProductCard(product: filteredProducts[index]);
                      },
                      childCount: filteredProducts.length,
                    ),
                  ),
          ),

          // Dribbble-style VIP Club & Newsletter Subscription Card
          const SliverToBoxAdapter(
            child: DribbbleNewsletterCard(),
          ),

          // Professional Brand & Cafe Footer
          const SliverToBoxAdapter(
            child: HomeFooter(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
