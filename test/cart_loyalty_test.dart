import 'package:flutter_test/flutter_test.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/models/cart_item_model.dart';
import 'package:brew_haven/shared/models/coupon_model.dart';

void main() {
  group('Caffè Royale Cart & Loyalty Logic Tests', () {
    const testProduct = ProductModel(
      id: 'test_p1',
      name: 'Caramel Macchiato',
      category: 'Espresso',
      description: 'Artisanal espresso with vanilla & caramel',
      basePrice: 200.0,
      rating: 4.9,
      reviewsCount: 100,
      imageUrl: 'https://example.com/image.jpg',
      sizePriceAdditions: {
        'Small': 0.0,
        'Medium': 40.0,
        'Large': 80.0,
      },
      extras: {
        'Extra Shot': 50.0,
        'Chocolate Syrup': 30.0,
      },
    );

    test('CartItem unit price calculation with size and milk additions', () {
      final item = CartItemModel(
        id: 'c1',
        product: testProduct,
        selectedSize: 'Medium', // +40
        selectedSugar: 'Regular',
        selectedMilk: 'Oat Milk (+₹30)', // +30
        selectedExtras: const ['Extra Shot'], // +50
        quantity: 2,
      );

      // Base 200 + 40 (Medium) + 30 (Oat Milk) + 50 (Extra Shot) = 320
      expect(item.unitPrice, 320.0);
      expect(item.totalPrice, 640.0);
    });

    test('Coupon percentage discount calculation', () {
      const coupon = CouponModel(
        code: 'BREW20',
        description: '20% off',
        discountPercent: 20.0,
        minOrderAmount: 200.0,
        maxDiscountAmount: 100.0,
      );

      // 20% of 400 = 80 (< 100 max)
      expect(coupon.calculateDiscount(400.0), 80.0);

      // 20% of 1000 = 200 (> 100 max cap) => 100.0
      expect(coupon.calculateDiscount(1000.0), 100.0);

      // Subtotal below minOrderAmount => 0
      expect(coupon.calculateDiscount(150.0), 0.0);
    });

    test('Coupon flat discount calculation', () {
      const flatCoupon = CouponModel(
        code: 'FIRSTBREW',
        description: 'Flat ₹50 off',
        flatDiscount: 50.0,
        minOrderAmount: 150.0,
      );

      expect(flatCoupon.calculateDiscount(300.0), 50.0);
      expect(flatCoupon.calculateDiscount(100.0), 0.0);
    });

    test('Loyalty Points rule: Every ₹100 spent = 10 points', () {
      double grandTotal = 650.0;
      int pointsEarned = (grandTotal / 100 * 10).toInt();
      expect(pointsEarned, 65);

      double smallTotal = 99.0;
      int smallPoints = (smallTotal / 100 * 10).toInt();
      expect(smallPoints, 9);
    });
  });
}
