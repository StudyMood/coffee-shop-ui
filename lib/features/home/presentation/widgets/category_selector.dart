import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.local_fire_department_rounded},
    {'name': 'Espresso', 'icon': Icons.coffee_rounded},
    {'name': 'Cappuccino', 'icon': Icons.local_cafe_rounded},
    {'name': 'Latte', 'icon': Icons.emoji_food_beverage_rounded},
    {'name': 'Cold Coffee', 'icon': Icons.ac_unit_rounded},
    {'name': 'Tea', 'icon': Icons.eco_rounded},
    {'name': 'Snacks', 'icon': Icons.bakery_dining_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory.toLowerCase() == cat['name'].toString().toLowerCase();

          return GestureDetector(
            onTap: () => onCategorySelected(cat['name'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryCoffee
                    : (isDark ? AppColors.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryCoffee
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryCoffee.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cat['name'] as String,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.textLight : AppColors.textDark),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
