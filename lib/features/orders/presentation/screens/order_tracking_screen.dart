import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/models/order_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = ref.watch(ordersStreamProvider).value ?? ref.read(dataRepositoryProvider).currentOrders;

    final orderMatch = orders.where((o) => o.id == orderId);
    final OrderModel? order = orderMatch.isNotEmpty ? orderMatch.first : (orders.isNotEmpty ? orders.first : null);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Track Order')),
        body: const Center(child: Text('Order not found')),
      );
    }

    final currentStep = order.status.stepIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.orderNumber,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded),
            tooltip: 'Invoice',
            onPressed: () => _showInvoiceDialog(context, order),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.coffeeGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryCoffee.withOpacity(0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Arrival',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.estimatedMinutes} Minutes',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.status.label,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delivery_dining_rounded,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Live Driver / Delivery Map Simulation
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primaryCoffee,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vikram Singh',
                                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Caffè Royale Express Rider ★ 4.9',
                                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phone_rounded, color: AppColors.accentGreen, size: 18),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling delivery partner...')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.oatMilk,
                      ),
                      child: Stack(
                        children: [
                          // Stylized map grid lines
                          CustomPaint(
                            size: const Size(double.infinity, 100),
                            painter: _SimpleMapGridPainter(isDark: isDark),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.storefront_rounded, color: AppColors.primaryCoffee, size: 24),
                                const SizedBox(width: 8),
                                Container(
                                  width: 80,
                                  height: 2,
                                  color: AppColors.primaryCoffee,
                                ),
                                const Icon(Icons.delivery_dining_rounded, color: AppColors.accentGold, size: 28),
                                Container(
                                  width: 80,
                                  height: 2,
                                  color: AppColors.borderLight,
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.home_rounded, color: AppColors.accentGreen, size: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Visual Progress Timeline for 6 States
            Text(
              'Order Timeline',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            ...List.generate(order.timeline.length, (index) {
              final event = order.timeline[index];
              final isCompleted = index <= currentStep;
              final isCurrent = index == currentStep;
              final isLast = index == order.timeline.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Node with connecting line
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isCompleted ? AppColors.primaryCoffee : (isDark ? AppColors.cardDark : AppColors.oatMilk),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCurrent
                                  ? AppColors.primaryCoffee
                                  : (isCompleted ? AppColors.primaryCoffee : AppColors.borderLight),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : Text(
                                    '${index + 1}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textMutedLight,
                                    ),
                                  ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: isCompleted ? AppColors.primaryCoffee : AppColors.borderLight,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Event Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                color: isCompleted
                                    ? (isDark ? Colors.white : AppColors.textDark)
                                    : AppColors.textMutedLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              event.description,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),

            // Order Items Recap
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.quantity}× ${item.product.name} (${item.selectedSize})',
                              style: GoogleFonts.outfit(fontSize: 13),
                            ),
                            Text(
                              '₹${item.totalPrice.toInt()}',
                              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grand Total Paid', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
                      Text(
                        '₹${order.grandTotal.toInt()}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: AppColors.primaryCoffee),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_rounded, color: AppColors.primaryCoffee),
            const SizedBox(width: 8),
            Text('Invoice #${order.orderNumber}', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}'),
            Text('Delivery: ${order.deliveryType}'),
            Text('Address: ${order.deliveryAddress}'),
            Text('Payment: ${order.paymentMethod}'),
            const Divider(height: 16),
            ...order.items.map((i) => Text('${i.quantity}x ${i.product.name} - ₹${i.totalPrice.toInt()}')),
            const Divider(height: 16),
            Text('Total: ₹${order.grandTotal.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invoice downloaded to device storage')),
              );
            },
            child: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }
}

class _SimpleMapGridPainter extends CustomPainter {
  final bool isDark;
  _SimpleMapGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)
      ..strokeWidth = 1.0;

    for (double x = 0; x < size.width; x += 25) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 25) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
