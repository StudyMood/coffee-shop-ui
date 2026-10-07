import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/checkout/presentation/screens/checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final availableCoupons = ref.watch(couponsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.accentRed),
              tooltip: 'Clear Cart',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear Cart?'),
                    content: const Text('Are you sure you want to remove all items from your cart?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).clearCart();
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Clear', style: TextStyle(color: AppColors.accentRed)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCoffee.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: AppColors.primaryCoffee,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your Cart is Empty',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse our artisanal coffees, teas, and fresh bakes to start your order.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Explore Menu',
                      width: 180,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Delivery vs Pickup Switcher
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.oatMilk,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ref.read(cartProvider.notifier).setDeliveryType('Doorstep Delivery'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: cart.deliveryType == 'Doorstep Delivery'
                                    ? AppColors.primaryCoffee
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Doorstep Delivery',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: cart.deliveryType == 'Doorstep Delivery'
                                        ? Colors.white
                                        : (isDark ? Colors.white70 : AppColors.textDark),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => ref.read(cartProvider.notifier).setDeliveryType('Store Pickup'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: cart.deliveryType == 'Store Pickup'
                                    ? AppColors.primaryCoffee
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Store Pickup',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: cart.deliveryType == 'Store Pickup'
                                        ? Colors.white
                                        : (isDark ? Colors.white70 : AppColors.textDark),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Cart Items List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppImage(
                              imageUrl: item.product.imageUrl,
                              width: 72,
                              height: 72,
                              borderRadius: BorderRadius.circular(14),
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${item.selectedSize} • ${item.selectedSugar} • ${item.selectedMilk.split(' (').first}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ),
                                  if (item.selectedExtras.isNotEmpty)
                                    Text(
                                      '+ ${item.selectedExtras.join(', ')}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        color: AppColors.primaryCoffee,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '₹${item.unitPrice.toInt()} each',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryCoffee,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Quantity Controls
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.oatMilk,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_rounded, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity - 1);
                                    },
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_rounded, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).updateQuantity(item.id, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order Breakdown & Coupon Card
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Coupon Section
                        GestureDetector(
                          onTap: () {
                            _showCouponsSheet(context, ref, availableCoupons, cart.subtotal);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCoffee.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.confirmation_num_outlined, color: AppColors.primaryCoffee, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    cart.appliedCoupon != null
                                        ? '${cart.appliedCoupon!.code} Applied (-₹${cart.discount.toInt()})'
                                        : 'Apply Coupon or Promo Code',
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryCoffee,
                                    ),
                                  ),
                                ),
                                if (cart.appliedCoupon != null)
                                  GestureDetector(
                                    onTap: () => ref.read(cartProvider.notifier).removeCoupon(),
                                    child: const Icon(Icons.close_rounded, size: 18, color: AppColors.accentRed),
                                  )
                                else
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryCoffee),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Price summary
                        _buildPriceRow('Subtotal', '₹${cart.subtotal.toInt()}', isDark),
                        _buildPriceRow('Taxes & Packaging (5% GST)', '₹${cart.tax.toInt()}', isDark),
                        _buildPriceRow(
                          'Delivery Charges',
                          cart.deliveryCharge == 0 ? 'FREE' : '₹${cart.deliveryCharge.toInt()}',
                          isDark,
                          isHighlight: cart.deliveryCharge == 0,
                        ),
                        if (cart.discount > 0)
                          _buildPriceRow('Coupon Discount', '-₹${cart.discount.toInt()}', isDark, isHighlight: true),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '₹${cart.grandTotal.toInt()}',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryCoffee,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Checkout Button
                        CustomButton(
                          text: 'Proceed to Checkout (${cart.itemCount} items)',
                          icon: Icons.lock_outline_rounded,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPriceRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isHighlight ? AppColors.accentGreen : (isDark ? Colors.white : AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  void _showCouponsSheet(BuildContext context, WidgetRef ref, List coupons, double subtotal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Coupons & Offers',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            ...coupons.map((coupon) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCoffee,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        coupon.code,
                        style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        coupon.description,
                        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).applyCoupon(coupon);
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('Apply'),
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
