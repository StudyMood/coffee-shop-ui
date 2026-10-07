import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/models/order_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'order_tracking_screen.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = ref.watch(ordersStreamProvider).value ?? ref.read(dataRepositoryProvider).currentOrders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          bottom: TabBar(
            indicatorColor: AppColors.primaryCoffee,
            labelColor: AppColors.primaryCoffee,
            unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            tabs: const [
              Tab(text: 'Active Orders'),
              Tab(text: 'Order History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Active orders
            _buildOrderList(
              context,
              orders.where((o) => o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled).toList(),
              isActiveTab: true,
            ),
            // Past orders
            _buildOrderList(
              context,
              orders.where((o) => o.status == OrderStatus.delivered || o.status == OrderStatus.cancelled).toList(),
              isActiveTab: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, List<OrderModel> list, {required bool isActiveTab}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 54, color: AppColors.textMutedLight),
            const SizedBox(height: 12),
            Text(
              isActiveTab ? 'No Active Orders' : 'No Past Orders',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              isActiveTab ? 'When you place an order, track it live here.' : 'Your delivered brews will appear here.',
              style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final order = list[index];
        return GlassCard(
          padding: const EdgeInsets.all(16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OrderTrackingScreen(orderId: order.id),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderNumber,
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCoffee.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.status.label,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryCoffee,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${order.items.length} items: ${order.items.map((i) => i.product.name).join(', ')}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${order.grandTotal.toInt()} • ${order.paymentMethod.split(' ').first}',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.primaryCoffee),
                  ),
                  Row(
                    children: [
                      Text(
                        'Track Order',
                        style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primaryCoffee),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primaryCoffee),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
