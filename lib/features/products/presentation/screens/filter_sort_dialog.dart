import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class FilterSortDialog extends ConsumerStatefulWidget {
  const FilterSortDialog({super.key});

  @override
  ConsumerState<FilterSortDialog> createState() => _FilterSortDialogState();
}

class _FilterSortDialogState extends ConsumerState<FilterSortDialog> {
  late String _selectedCategory;
  late ProductSortOption _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedCategory = ref.read(selectedCategoryProvider);
    _selectedSort = ref.read(sortOptionProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sortOptions = [
      {'label': 'Most Popular', 'option': ProductSortOption.popular, 'icon': Icons.local_fire_department_rounded},
      {'label': 'Highest Rated', 'option': ProductSortOption.highestRated, 'icon': Icons.star_rounded},
      {'label': 'Price: Low to High', 'option': ProductSortOption.priceLowHigh, 'icon': Icons.arrow_upward_rounded},
      {'label': 'Price: High to Low', 'option': ProductSortOption.priceHighLow, 'icon': Icons.arrow_downward_rounded},
    ];

    final categories = ['All', 'Espresso', 'Cappuccino', 'Latte', 'Cold Coffee', 'Tea', 'Snacks'];

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter & Sort',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = 'All';
                    _selectedSort = ProductSortOption.popular;
                  });
                },
                child: Text(
                  'Reset',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryCoffee,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Categories
          Text(
            'Categories',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((cat) {
              final isSelected = _selectedCategory.toLowerCase() == cat.toLowerCase();
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                selectedColor: AppColors.primaryCoffee,
                backgroundColor: isDark ? AppColors.cardDark : AppColors.oatMilk,
                labelStyle: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.textDark),
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedCategory = cat);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Sort By
          Text(
            'Sort By',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: sortOptions.map((item) {
              final option = item['option'] as ProductSortOption;
              final isSelected = _selectedSort == option;

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  item['icon'] as IconData,
                  color: isSelected ? AppColors.primaryCoffee : AppColors.textMutedLight,
                ),
                title: Text(
                  item['label'] as String,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryCoffee : (isDark ? Colors.white : AppColors.textDark),
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryCoffee, size: 20)
                    : null,
                onTap: () => setState(() => _selectedSort = option),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Apply Button
          CustomButton(
            text: 'Apply Filters',
            onPressed: () {
              ref.read(selectedCategoryProvider.notifier).state = _selectedCategory;
              ref.read(sortOptionProvider.notifier).state = _selectedSort;
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
