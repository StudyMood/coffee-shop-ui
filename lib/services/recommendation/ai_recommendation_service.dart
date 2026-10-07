import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/models/order_model.dart';

class AiRecommendationService {
  /// AI smart recommendation algorithm
  /// Evaluates previous customer orders, category affinities, and time-of-day contextual pairings
  static List<ProductModel> getRecommendations({
    required List<ProductModel> allProducts,
    required List<OrderModel> userOrders,
    required List<String> favoriteProductIds,
  }) {
    if (allProducts.isEmpty) return [];

    // Collect purchased categories
    final categoryFrequencies = <String, int>{};
    for (final order in userOrders) {
      for (final item in order.items) {
        final cat = item.product.category;
        categoryFrequencies[cat] = (categoryFrequencies[cat] ?? 0) + item.quantity;
      }
    }

    // Determine primary preferred category
    String? preferredCategory;
    int maxFreq = 0;
    categoryFrequencies.forEach((cat, freq) {
      if (freq > maxFreq) {
        maxFreq = freq;
        preferredCategory = cat;
      }
    });

    final recommendations = <ProductModel>[];

    // Rule 1: Companion snack pairings (If customer orders Espresso/Latte, suggest Croissant or Brownie)
    final hasHotCoffee = userOrders.any((o) => o.items.any((i) =>
        i.product.category == 'Espresso' ||
        i.product.category == 'Latte' ||
        i.product.category == 'Cappuccino'));

    if (hasHotCoffee) {
      final pastry = allProducts.firstWhere(
        (p) => p.name.contains('Croissant') || p.name.contains('Brownie'),
        orElse: () => allProducts.first,
      );
      if (!recommendations.contains(pastry)) {
        recommendations.add(pastry);
      }
    }

    // Rule 2: High rated in preferred category
    if (preferredCategory != null) {
      final inCat = allProducts
          .where((p) => p.category == preferredCategory && !recommendations.contains(p))
          .toList();
      inCat.sort((a, b) => b.rating.compareTo(a.rating));
      recommendations.addAll(inCat.take(2));
    }

    // Rule 3: Time-of-day heuristic:
    // Morning (6 AM - 12 PM): Nitro Cold Brew / Double Espresso
    // Afternoon / Evening (12 PM - 10 PM): Caramel Macchiato / Affogato / Matcha
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      final morningPicks = allProducts
          .where((p) => (p.category == 'Cold Coffee' || p.category == 'Espresso') && !recommendations.contains(p))
          .toList();
      recommendations.addAll(morningPicks.take(2));
    } else {
      final eveningPicks = allProducts
          .where((p) => (p.name.contains('Caramel') || p.name.contains('Affogato')) && !recommendations.contains(p))
          .toList();
      recommendations.addAll(eveningPicks.take(2));
    }

    // Fallback: fill up to 4 items with top rated featured items
    for (final p in allProducts) {
      if (recommendations.length >= 4) break;
      if (!recommendations.contains(p)) {
        recommendations.add(p);
      }
    }

    return recommendations.take(4).toList();
  }
}
