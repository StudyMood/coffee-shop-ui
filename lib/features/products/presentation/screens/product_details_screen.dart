import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/core/widgets/rating_stars.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/cart/presentation/screens/cart_screen.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  late String _selectedSize;
  late String _selectedSugar;
  late String _selectedMilk;
  final Set<String> _selectedExtras = {};
  int _quantity = 1;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.product.availableSizes.isNotEmpty ? widget.product.availableSizes.first : 'Medium';
    _selectedSugar = widget.product.sugarLevels.isNotEmpty ? widget.product.sugarLevels.last : 'Regular';
    _selectedMilk = widget.product.milkOptions.isNotEmpty ? widget.product.milkOptions.first : 'Whole Milk';
  }

  double _calculateCurrentUnitPrice() {
    double price = widget.product.basePrice;
    price += widget.product.sizePriceAdditions[_selectedSize] ?? 0.0;
    if (_selectedMilk.contains('+₹30')) price += 30.0;
    if (_selectedMilk.contains('+₹40')) price += 40.0;
    for (final extra in _selectedExtras) {
      price += widget.product.extras[extra] ?? 0.0;
    }
    return price;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFav = ref.watch(favoritesProvider.notifier).isFavorite(widget.product.id);
    final unitPrice = _calculateCurrentUnitPrice();
    final totalPrice = unitPrice * _quantity;
    final reviews = ref.read(dataRepositoryProvider).getReviewsForProduct(widget.product.id);
    final cartItemCount = ref.watch(cartProvider).itemCount;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 680;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.oatMilk,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: isDark ? Colors.white : AppColors.textDark,
                    size: 20,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
              ),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryCoffee.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.product.category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryCoffee,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.product.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              // Favorite Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.oatMilk,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? AppColors.accentRed : (isDark ? Colors.white70 : AppColors.textDark),
                      size: 20,
                    ),
                    onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(widget.product.id),
                    tooltip: 'Favorite',
                  ),
                ),
              ),
              // Cart Button with badge
              Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 4.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.oatMilk,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.shopping_bag_outlined,
                          color: isDark ? Colors.white70 : AppColors.textDark,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        ),
                        tooltip: 'Cart',
                      ),
                    ),
                    if (cartItemCount > 0)
                      Positioned(
                        top: 4,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryCoffee,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '$cartItemCount',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          body: isWide
              ? _buildWideRowLayout(context, isDark, unitPrice, totalPrice, reviews)
              : _buildMobileRowLayout(context, isDark, unitPrice, totalPrice, reviews),
          bottomSheet: isWide ? null : _buildMobileBottomSheet(context, isDark, totalPrice),
        );
      },
    );
  }

  /// WIDE SCREEN ROW LAYOUT: Image on the Left, Details & Purchase on the Right
  Widget _buildWideRowLayout(
    BuildContext context,
    bool isDark,
    double unitPrice,
    double totalPrice,
    List<dynamic> reviews,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT COLUMN: Product Image Showcase Card
          Expanded(
            flex: 5,
            child: _buildShowcaseImageCard(context, isDark),
          ),
          const SizedBox(width: 28),

          // RIGHT COLUMN: Customization Options & Purchase Action
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Scrollable Details & Options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Unit Price Header
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product.name,
                                      style: GoogleFonts.outfit(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? Colors.white : AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        RatingStars(
                                          rating: widget.product.rating,
                                          reviewsCount: widget.product.reviewsCount,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 14),
                                        Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.primaryCoffee),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.product.calories} kcal',
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            color: isDark ? Colors.white70 : AppColors.textMutedLight,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.grain_rounded, size: 16, color: AppColors.primaryCoffee),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.product.roastLevel,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            color: isDark ? Colors.white70 : AppColors.textMutedLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryCoffee.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.3)),
                                ),
                                child: Text(
                                  '₹${unitPrice.toInt()}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryCoffee,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),

                          // Description
                          _buildDescriptionSection(isDark),
                          const SizedBox(height: 20),

                          // Customizations
                          _buildSizeSelector(isDark),
                          const SizedBox(height: 18),

                          _buildSugarSelector(isDark),
                          const SizedBox(height: 18),

                          _buildMilkSelector(isDark),
                          const SizedBox(height: 18),

                          _buildExtrasSelector(isDark),
                          const SizedBox(height: 20),

                          if (reviews.isNotEmpty) _buildReviewsSection(reviews, isDark),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Bottom Action Bar inside Right Panel (No Overlap!)
                  _buildPurchaseActionBar(context, isDark, totalPrice),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// MOBILE ROW LAYOUT: Product Image & Summary in a Row at the Top, Options Below
  Widget _buildMobileRowLayout(
    BuildContext context,
    bool isDark,
    double unitPrice,
    double totalPrice,
    List<dynamic> reviews,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Image on Left + Title, Specs & Price on Right
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Hero(
                      tag: 'product_image_${widget.product.id}',
                      child: AppImage(
                        imageUrl: widget.product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title, Rating, Price, Specs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RatingStars(
                        rating: widget.product.rating,
                        reviewsCount: widget.product.reviewsCount,
                        size: 13,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded, size: 14, color: AppColors.primaryCoffee),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.product.calories} kcal',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : AppColors.textMutedLight,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.grain_rounded, size: 14, color: AppColors.primaryCoffee),
                          const SizedBox(width: 3),
                          Text(
                            widget.product.roastLevel,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? Colors.white70 : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${unitPrice.toInt()}',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryCoffee,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Description
          _buildDescriptionSection(isDark),
          const SizedBox(height: 22),

          // Size Selector
          _buildSizeSelector(isDark),
          const SizedBox(height: 20),

          // Sugar Level
          _buildSugarSelector(isDark),
          const SizedBox(height: 20),

          // Milk Alternatives
          _buildMilkSelector(isDark),
          const SizedBox(height: 20),

          // Extras
          _buildExtrasSelector(isDark),
          const SizedBox(height: 20),

          // Reviews
          if (reviews.isNotEmpty) _buildReviewsSection(reviews, isDark),
        ],
      ),
    );
  }

  /// Large Showcase Image Card for Wide Layout
  Widget _buildShowcaseImageCard(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'product_image_${widget.product.id}',
            child: AppImage(
              imageUrl: widget.product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Subtle Dark Vignette gradient at bottom
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // Floating Category Badge
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                widget.product.category.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.accentGold,
                ),
              ),
            ),
          ),
          // Bottom Badges Overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildImageSpecItem(
                    Icons.local_fire_department_rounded,
                    '${widget.product.calories} kcal',
                    'Energy',
                  ),
                  Container(height: 24, width: 1, color: Colors.white24),
                  _buildImageSpecItem(
                    Icons.grain_rounded,
                    widget.product.roastLevel,
                    'Roast',
                  ),
                  Container(height: 24, width: 1, color: Colors.white24),
                  _buildImageSpecItem(
                    Icons.star_rounded,
                    '${widget.product.rating}',
                    'Rating',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSpecItem(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.accentGold, size: 15),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  /// Description with read more
  Widget _buildDescriptionSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
          child: RichText(
            text: TextSpan(
              text: _isDescriptionExpanded || widget.product.description.length < 90
                  ? widget.product.description
                  : '${widget.product.description.substring(0, 90)}... ',
              style: GoogleFonts.outfit(
                fontSize: 14,
                height: 1.5,
                color: isDark ? Colors.white70 : AppColors.textMutedLight,
              ),
              children: [
                if (widget.product.description.length >= 90)
                  TextSpan(
                    text: _isDescriptionExpanded ? ' Read Less' : ' Read More',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryCoffee,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Size Selector
  Widget _buildSizeSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Size',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: widget.product.availableSizes.map((size) {
            final isSelected = _selectedSize == size;
            final extra = widget.product.sizePriceAdditions[size] ?? 0.0;
            final extraText = extra > 0 ? ' (+₹${extra.toInt()})' : '';

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryCoffee.withOpacity(0.12)
                        : (isDark ? AppColors.cardDark : AppColors.oatMilk),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryCoffee : Colors.transparent,
                      width: 1.8,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        size,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? AppColors.primaryCoffee : (isDark ? Colors.white : AppColors.textDark),
                        ),
                      ),
                      if (extraText.isNotEmpty)
                        Text(
                          extraText,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isSelected ? AppColors.primaryCoffee : AppColors.textMutedLight,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Sugar Level
  Widget _buildSugarSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sugar Level',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: widget.product.sugarLevels.map((sugar) {
            final isSelected = _selectedSugar == sugar;
            return ChoiceChip(
              label: Text(sugar),
              selected: isSelected,
              selectedColor: AppColors.primaryCoffee,
              backgroundColor: isDark ? AppColors.cardDark : AppColors.oatMilk,
              labelStyle: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.textDark),
              ),
              onSelected: (val) {
                if (val) setState(() => _selectedSugar = sugar);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Milk Alternatives
  Widget _buildMilkSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milk Alternatives',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.product.milkOptions.map((milk) {
            final isSelected = _selectedMilk == milk;
            return ChoiceChip(
              label: Text(milk),
              selected: isSelected,
              selectedColor: AppColors.primaryCoffee,
              backgroundColor: isDark ? AppColors.cardDark : AppColors.oatMilk,
              labelStyle: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.textDark),
              ),
              onSelected: (val) {
                if (val) setState(() => _selectedMilk = milk);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Add-ons & Extras
  Widget _buildExtrasSelector(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add-ons & Extras',
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        Column(
          children: widget.product.extras.entries.map((entry) {
            final isChecked = _selectedExtras.contains(entry.key);
            return CheckboxListTile(
              value: isChecked,
              dense: true,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primaryCoffee,
              title: Text(
                entry.key,
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '+₹${entry.value.toInt()}',
                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.primaryCoffee),
              ),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    _selectedExtras.add(entry.key);
                  } else {
                    _selectedExtras.remove(entry.key);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Customer Reviews
  Widget _buildReviewsSection(List<dynamic> reviews, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer Reviews',
              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              '${reviews.length} reviews',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: AppColors.primaryCoffee,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...reviews.map(
          (r) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.oatMilk.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.userName, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13)),
                    RatingStars(rating: r.rating, size: 12, showNumber: false),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  r.comment,
                  style: GoogleFonts.outfit(fontSize: 13, color: isDark ? Colors.white70 : AppColors.textDark),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Integrated Purchase Action Bar (Stepper + Add to Cart)
  Widget _buildPurchaseActionBar(BuildContext context, bool isDark, double totalPrice) {
    return Row(
      children: [
        // Quantity Stepper
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.oatMilk,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_rounded, size: 18),
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  '$_quantity',
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_rounded, size: 18),
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),

        // Add to Cart Button
        Expanded(
          child: CustomButton(
            text: 'Add to Cart • ₹${totalPrice.toInt()}',
            icon: Icons.shopping_bag_outlined,
            onPressed: () => _handleAddToCart(context, totalPrice),
          ),
        ),
      ],
    );
  }

  /// Mobile Bottom Sheet
  Widget _buildMobileBottomSheet(BuildContext context, bool isDark, double totalPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildPurchaseActionBar(context, isDark, totalPrice),
      ),
    );
  }

  void _handleAddToCart(BuildContext context, double totalPrice) {
    ref.read(cartProvider.notifier).addItem(
          product: widget.product,
          selectedSize: _selectedSize,
          selectedSugar: _selectedSugar,
          selectedMilk: _selectedMilk,
          selectedExtras: _selectedExtras.toList(),
          quantity: _quantity,
        );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildAddedBottomSheet(context, totalPrice),
    );
  }

  Widget _buildAddedBottomSheet(BuildContext context, double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.accentGreen, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'Customized & Added to Cart!',
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '$_quantity × ${widget.product.name} ($_selectedSize) • ₹${total.toInt()}',
            style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Keep Browsing'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryCoffee,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('View Cart'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
