import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/storage/local_storage_service.dart';
import 'package:brew_haven/core/widgets/custom_text_field.dart';
import 'package:brew_haven/core/widgets/rating_stars.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/products/presentation/screens/product_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  List<String> _history = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _history = LocalStorageService.getSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _currentQuery = query.trim());
    if (query.trim().isNotEmpty) {
      LocalStorageService.addSearchQuery(query.trim());
      setState(() => _history = LocalStorageService.getSearchHistory());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allProducts = ref.watch(productsStreamProvider).value ?? ref.read(dataRepositoryProvider).currentProducts;

    final results = _currentQuery.isEmpty
        ? <ProductModel>[]
        : allProducts.where((p) {
            final q = _currentQuery.toLowerCase();
            return p.name.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Coffee'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Search Input
            CustomTextField(
              controller: _searchController,
              hintText: 'Search latte, cold brew, croissant...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryCoffee),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _currentQuery = '');
                      },
                    )
                  : null,
              onChanged: (val) => setState(() => _currentQuery = val.trim()),
              onSubmitted: _onSearch,
            ),
            const SizedBox(height: 18),

            // Content Area: Search History & Suggestions or Search Results
            Expanded(
              child: _currentQuery.isEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search History
                          if (_history.isNotEmpty) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Searches',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await LocalStorageService.clearSearchHistory();
                                    setState(() => _history = []);
                                  },
                                  child: Text(
                                    'Clear',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      color: AppColors.accentRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _history.map((term) {
                                return ActionChip(
                                  avatar: const Icon(Icons.history_rounded, size: 16, color: AppColors.primaryCoffee),
                                  label: Text(term),
                                  backgroundColor: isDark ? AppColors.cardDark : AppColors.oatMilk,
                                  labelStyle: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w500),
                                  onPressed: () {
                                    _searchController.text = term;
                                    _onSearch(term);
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Trending suggestions
                          Text(
                            'Trending Handcrafted Drinks',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...allProducts.take(4).map(
                                (p) => ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: AppImage(
                                    imageUrl: p.imageUrl,
                                    width: 48,
                                    height: 48,
                                    borderRadius: BorderRadius.circular(10),
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(p.name, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14)),
                                  subtitle: Text('${p.category} • ₹${p.basePrice.toInt()}', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.primaryCoffee)),
                                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMutedLight),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p)),
                                    );
                                  },
                                ),
                              ),
                        ],
                      ),
                    )
                  : results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textMutedLight),
                              const SizedBox(height: 12),
                              Text(
                                'No matching brews found',
                                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Try checking for spelling or searching another drink',
                                style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: results.length,
                          separatorBuilder: (_, __) => const Divider(height: 20),
                          itemBuilder: (context, index) {
                            final product = results[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: AppImage(
                                imageUrl: product.imageUrl,
                                width: 58,
                                height: 58,
                                borderRadius: BorderRadius.circular(12),
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                product.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  RatingStars(rating: product.rating, size: 11),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${product.category} • ${product.calories} kcal',
                                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                '₹${product.basePrice.toInt()}',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryCoffee,
                                ),
                              ),
                              onTap: () {
                                _onSearch(product.name);
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
