import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/models/order_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  OrderStatus? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orders = ref.watch(ordersStreamProvider).value ?? ref.read(dataRepositoryProvider).currentOrders;

    final filtered = _selectedFilter == null
        ? orders
        : orders.where((o) => o.status == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Orders Manager'),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All Orders'),
                  selected: _selectedFilter == null,
                  selectedColor: AppColors.primaryCoffee,
                  labelStyle: TextStyle(color: _selectedFilter == null ? Colors.white : null),
                  onSelected: (val) => setState(() => _selectedFilter = null),
                ),
                const SizedBox(width: 8),
                ...OrderStatus.values.where((s) => s != OrderStatus.cancelled).map((status) {
                  final isSelected = _selectedFilter == status;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(status.label),
                      selected: isSelected,
                      selectedColor: AppColors.primaryCoffee,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                      onSelected: (val) => setState(() => _selectedFilter = val ? status : null),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text('No orders matching status', style: GoogleFonts.outfit(fontSize: 16)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = filtered[index];
                      return GlassCard(
                        padding: const EdgeInsets.all(16),
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
                                    color: AppColors.primaryCoffee.withOpacity(0.15),
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
                            const SizedBox(height: 6),
                            Text(
                              'Customer: ${order.customerName} (${order.customerPhone})',
                              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Address: ${order.deliveryAddress}',
                              style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                            ),
                            const SizedBox(height: 10),
                            ...order.items.map((i) => Text(
                                  '• ${i.quantity}x ${i.product.name} (${i.selectedSize}, ${i.selectedSugar})',
                                  style: GoogleFonts.outfit(fontSize: 12),
                                )),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total: ₹${order.grandTotal.toInt()} • ${order.paymentMethod}',
                                  style: GoogleFonts.outfit(fontWeight: FontWeight.w800, color: AppColors.primaryCoffee),
                                ),
                                DropdownButton<OrderStatus>(
                                  value: order.status,
                                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                                  underline: const SizedBox.shrink(),
                                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryCoffee),
                                  items: OrderStatus.values.map((status) {
                                    return DropdownMenuItem(
                                      value: status,
                                      child: Text(
                                        status.label,
                                        style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newStatus) {
                                    if (newStatus != null) {
                                      ref.read(dataRepositoryProvider).updateOrderStatus(order.id, newStatus);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 1),
                                          content: Text('Updated ${order.orderNumber} to "${newStatus.label}"'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
