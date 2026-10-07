import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/orders/presentation/screens/order_tracking_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI (Google Pay / PhonePe)';
  late String _selectedAddress;
  bool _isPlacingOrder = false;

  final List<Map<String, dynamic>> _paymentOptions = [
    {'title': 'UPI (Google Pay / PhonePe)', 'icon': Icons.qr_code_rounded, 'desc': 'Instant & secure UPI payment'},
    {'title': 'Credit / Debit Card', 'icon': Icons.credit_card_rounded, 'desc': 'Visa, Mastercard, RuPay'},
    {'title': 'Cash on Delivery', 'icon': Icons.payments_rounded, 'desc': 'Pay with cash at doorstep'},
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _selectedAddress = user != null && user.addresses.isNotEmpty
        ? user.addresses.first
        : 'Flat 402, Oakwood Manor, 12th Cross, Indiranagar, Bangalore';
  }

  Future<void> _handlePlaceOrder() async {
    final cart = ref.read(cartProvider);
    if (cart.items.isEmpty) return;

    setState(() => _isPlacingOrder = true);

    try {
      final user = ref.read(currentUserProvider);
      final repo = ref.read(dataRepositoryProvider);

      final order = await repo.placeOrder(
        userId: user?.userId ?? 'guest',
        customerName: user?.name ?? 'Coffee Aficionado',
        customerPhone: user?.phone ?? '+91 98765 00000',
        items: cart.items,
        deliveryType: cart.deliveryType,
        deliveryAddress: cart.deliveryType == 'Store Pickup'
            ? 'Caffè Royale Flagship Roastery, Indiranagar'
            : _selectedAddress,
        paymentMethod: _selectedPaymentMethod,
        subtotal: cart.subtotal,
        tax: cart.tax,
        deliveryCharge: cart.deliveryCharge,
        discount: cart.discount,
        grandTotal: cart.grandTotal,
      );

      // Award loyalty points: Every ₹100 = 10 pts
      final earnedPoints = (cart.grandTotal / 100 * 10).toInt();
      if (earnedPoints > 0) {
        await ref.read(authServiceProvider).updateLoyaltyPoints(earnedPoints);
      }

      // Clear the cart
      ref.read(cartProvider.notifier).clearCart();

      if (!mounted) return;

      // Navigate to order tracking screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(orderId: order.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPlacingOrder = false);
    }
  }

  void _showAddAddressDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Delivery Address'),
        content: TextField(
          controller: textController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'House/Flat No, Apartment, Street, Landmark...',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newAddr = textController.text.trim();
              if (newAddr.isNotEmpty) {
                await ref.read(authServiceProvider).addAddress(newAddr);
                setState(() => _selectedAddress = newAddr);
              }
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = ref.watch(cartProvider);
    final user = ref.watch(currentUserProvider);
    final addresses = user?.addresses ?? [_selectedAddress];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Type Indicator
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryCoffee.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    cart.deliveryType == 'Store Pickup'
                        ? Icons.storefront_rounded
                        : Icons.delivery_dining_rounded,
                    color: AppColors.primaryCoffee,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cart.deliveryType,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryCoffee,
                          ),
                        ),
                        Text(
                          cart.deliveryType == 'Store Pickup'
                              ? 'Pickup from Caffè Royale Roastery in ~15 mins'
                              : 'Estimated doorstep delivery in ~25-30 mins',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delivery Address Section (if not pickup)
            if (cart.deliveryType != 'Store Pickup') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  TextButton.icon(
                    onPressed: _showAddAddressDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add New'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...addresses.map((addr) {
                final isSelected = _selectedAddress == addr;
                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  onTap: () => setState(() => _selectedAddress = addr),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: isSelected ? 2 : 1,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        color: isSelected ? AppColors.primaryCoffee : AppColors.textMutedLight,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          addr,
                          style: GoogleFonts.outfit(fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],

            // Payment Method Section
            Text(
              'Select Payment Method',
              style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ..._paymentOptions.map((opt) {
              final isSelected = _selectedPaymentMethod == opt['title'];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                onTap: () => setState(() => _selectedPaymentMethod = opt['title']),
                border: Border.all(
                  color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isSelected ? 2 : 1,
                ),
                child: Row(
                  children: [
                    Icon(opt['icon'] as IconData, color: isSelected ? AppColors.primaryCoffee : AppColors.textMutedLight, size: 24),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opt['title'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            opt['desc'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: isSelected ? AppColors.primaryCoffee : AppColors.textMutedLight,
                      size: 20,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Order Review Summary Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Total & Rewards',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Payable', style: GoogleFonts.outfit(fontSize: 14)),
                      Text(
                        '₹${cart.grandTotal.toInt()}',
                        style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primaryCoffee),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.accentGold),
                        const SizedBox(width: 6),
                        Text(
                          'You will earn +${(cart.grandTotal / 100 * 10).toInt()} Loyalty Points',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Place Order Button
            CustomButton(
              text: 'Confirm & Place Order',
              isLoading: _isPlacingOrder,
              icon: Icons.check_circle_rounded,
              onPressed: _handlePlaceOrder,
            ),
          ],
        ),
      ),
    );
  }
}
