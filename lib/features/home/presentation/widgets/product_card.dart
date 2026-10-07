import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/core/widgets/rating_stars.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/products/presentation/screens/product_details_screen.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider.notifier).isFavorite(product.id);

    return GlassCard(
      padding: const EdgeInsets.all(10),
      borderRadius: 18,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Proportional Image Container with badges
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.12,
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: AppImage(
                    imageUrl: product.imageUrl,
                    borderRadius: BorderRadius.circular(14),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Rating Tag
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.68),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RatingStars(
                    rating: product.rating,
                    size: 10,
                    showNumber: true,
                  ),
                ),
              ),

              // Favorite Button
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.52),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? AppColors.accentRed : Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Name
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),

          // Subtitle / Roast
          Text(
            '${product.category} • ${product.calories} kcal',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const Spacer(),

          // Price and Quick Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${product.basePrice.toInt()}',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryCoffee,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).addItem(
                        product: product,
                        selectedSize: product.availableSizes.first,
                        selectedSugar: product.sugarLevels.first,
                        selectedMilk: product.milkOptions.first,
                        selectedExtras: const [],
                        quantity: 1,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 1200),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: isDark ? AppColors.cardDark : AppColors.primaryEspresso,
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Added ${product.name} to cart',
                              style: GoogleFonts.outfit(fontSize: 13, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryCoffee,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryCoffee.withOpacity(0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 18,
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
