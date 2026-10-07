import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/models/store_location_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class StoresMapScreen extends ConsumerStatefulWidget {
  const StoresMapScreen({super.key});

  @override
  ConsumerState<StoresMapScreen> createState() => _StoresMapScreenState();
}

class _StoresMapScreenState extends ConsumerState<StoresMapScreen> {
  StoreLocationModel? _selectedStore;

  @override
  void initState() {
    super.initState();
    final stores = ref.read(storesProvider);
    if (stores.isNotEmpty) {
      _selectedStore = stores.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stores = ref.watch(storesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caffè Royale Outlets'),
      ),
      body: Stack(
        children: [
          // Stylized Interactive Coffee Map Canvas
          Container(
            color: isDark ? const Color(0xFF141211) : const Color(0xFFEBE6E1),
            child: Stack(
              children: [
                // Stylized map road grid
                CustomPaint(
                  size: Size.infinite,
                  painter: _CityMapPainter(isDark: isDark),
                ),

                // Outlets Pins
                Positioned(
                  top: 140,
                  left: 80,
                  child: _buildStoreMarker(stores[0]),
                ),
                if (stores.length > 1)
                  Positioned(
                    top: 230,
                    right: 90,
                    child: _buildStoreMarker(stores[1]),
                  ),
                if (stores.length > 2)
                  Positioned(
                    top: 320,
                    left: 140,
                    child: _buildStoreMarker(stores[2]),
                  ),

                // User Location Pin
                Positioned(
                  top: 200,
                  left: 180,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentBlue.withOpacity(0.5),
                          blurRadius: 14,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),

          // Top Info Banner: Distance & Current Area
          Positioned(
            top: 16,
            left: 20,
            right: 20,
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.my_location_rounded, color: AppColors.accentBlue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Showing 3 Caffè Royale outlets near Bangalore Central',
                      style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Store Details Carousel
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 185,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: stores.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final store = stores[index];
                  final isSelected = _selectedStore?.id == store.id;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedStore = store),
                    child: Container(
                      width: 290,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  store.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryCoffee.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${store.distanceKm} km',
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
                            store.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 14, color: AppColors.accentGreen),
                                  const SizedBox(width: 4),
                                  Text(
                                    store.workingHours,
                                    style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Opening Navigation to ${store.name}...')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryCoffee,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Directions', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreMarker(StoreLocationModel store) {
    final isSelected = _selectedStore?.id == store.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedStore = store),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accentGold : AppColors.primaryCoffee,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isSelected ? AppColors.accentGold : AppColors.primaryCoffee).withOpacity(0.5),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.coffee_rounded, color: Colors.white, size: 22),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              store.name.split(' ').first,
              style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _CityMapPainter extends CustomPainter {
  final bool isDark;
  _CityMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.07)
      ..strokeWidth = 14;

    // Simulated major avenues
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.25), roadPaint);
    canvas.drawLine(Offset(size.width * 0.45, 0), Offset(size.width * 0.55, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.65), Offset(size.width, size.height * 0.8), roadPaint);
    canvas.drawLine(Offset(size.width * 0.15, 0), Offset(size.width * 0.25, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
