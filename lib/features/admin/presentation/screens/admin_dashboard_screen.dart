import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/home/presentation/screens/main_navigation_shell.dart';
import 'package:brew_haven/features/auth/presentation/screens/sign_in_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_products_screen.dart';
import 'admin_bookings_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analytics = ref.watch(adminAnalyticsProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Operations Hub'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_rounded),
            tooltip: 'View Customer Store',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MainNavigationShell()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Role Verification Banner
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.accentRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentRed.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.security_rounded, color: AppColors.accentRed, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGGED IN AS ADMINISTRATOR',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentRed,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          user?.email ?? 'admin@brewhaven.com',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDark ? Colors.white70 : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCoffee,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'View Store',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Admin Greeting
            Text(
              'Store Manager Control ☕',
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Real-time overview of sales, active kitchen tickets, and reservations.',
              style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 20),

            // Analytics KPI Metric Cards Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Revenue',
                    value: '₹${analytics.totalRevenue.toInt()}',
                    subtitle: '+${analytics.growthRate}% today',
                    icon: Icons.currency_rupee_rounded,
                    color: AppColors.accentGreen,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Orders',
                    value: '${analytics.totalOrders}',
                    subtitle: '${analytics.activeOrders} active tickets',
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.primaryCoffee,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Reservations',
                    value: '${analytics.activeBookings}',
                    subtitle: 'Confirmed tables',
                    icon: Icons.table_restaurant_rounded,
                    color: AppColors.accentGold,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Top Beverage',
                    value: 'Macchiato',
                    subtitle: '420+ cups poured',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.accentRed,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Revenue Sales Trend Chart
            GlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weekly Revenue Trends',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Last 7 Days',
                        style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 160,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (val, meta) {
                                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                final idx = val.toInt();
                                if (idx >= 0 && idx < days.length) {
                                  return Text(days[idx], style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight));
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3200),
                              FlSpot(1, 4500),
                              FlSpot(2, 4100),
                              FlSpot(3, 5800),
                              FlSpot(4, 6200),
                              FlSpot(5, 7800),
                              FlSpot(6, 8400),
                            ],
                            isCurved: true,
                            color: AppColors.primaryCoffee,
                            barWidth: 3.5,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppColors.primaryCoffee.withOpacity(0.18),
                            ),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Management Action Buttons
            Text(
              'Management Portals',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            _buildManagementTile(
              context: context,
              icon: Icons.kitchen_rounded,
              color: AppColors.primaryCoffee,
              title: 'Live Orders Kanban',
              subtitle: 'Update status: Preparing, Ready, Out for delivery',
              badge: '${analytics.activeOrders} active',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminOrdersScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _buildManagementTile(
              context: context,
              icon: Icons.inventory_2_rounded,
              color: AppColors.accentGold,
              title: 'Beverage & Snack Catalog',
              subtitle: 'Add new brews, edit prices, manage inventory',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminProductsScreen()),
              ),
            ),
            const SizedBox(height: 10),
            _buildManagementTile(
              context: context,
              icon: Icons.table_restaurant_rounded,
              color: AppColors.accentGreen,
              title: 'Table Reservations Manager',
              subtitle: 'Confirm or reschedule incoming bookings',
              badge: '${analytics.activeBookings} pending',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminBookingsScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textMutedLight),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.outfit(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w800)),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w700, color: color),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(fontSize: 12, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMutedLight),
        ],
      ),
    );
  }
}
