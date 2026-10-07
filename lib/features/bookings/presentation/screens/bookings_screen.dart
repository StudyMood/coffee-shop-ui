import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/models/booking_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class BookingsScreen extends ConsumerStatefulWidget {
  const BookingsScreen({super.key});

  @override
  ConsumerState<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends ConsumerState<BookingsScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTimeSlot = '05:00 PM - 06:30 PM';
  int _guestCount = 2;
  String _selectedSeating = 'Cozy Indoor';
  final _notesController = TextEditingController();
  bool _isBooking = false;

  final List<String> _timeSlots = [
    '09:00 AM - 10:30 AM',
    '11:30 AM - 01:00 PM',
    '03:00 PM - 04:30 PM',
    '05:00 PM - 06:30 PM',
    '07:00 PM - 08:30 PM',
    '09:00 PM - 10:30 PM',
  ];

  final List<Map<String, dynamic>> _seatingAreas = [
    {'title': 'Cozy Indoor', 'icon': Icons.weekend_rounded, 'desc': 'Air-conditioned lounge with soft jazz'},
    {'title': 'Patio Garden', 'icon': Icons.park_rounded, 'desc': 'Outdoor greenery, pet friendly'},
    {'title': 'Window Bar', 'icon': Icons.table_bar_rounded, 'desc': 'City view, perfect for reading & working'},
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleBookTable() async {
    setState(() => _isBooking = true);
    try {
      final user = ref.read(currentUserProvider);
      final repo = ref.read(dataRepositoryProvider);

      await repo.createBooking(
        userId: user?.userId ?? 'u_demo',
        customerName: user?.name ?? 'Coffee Enthusiast',
        customerPhone: user?.phone ?? '+91 98765 00000',
        date: _selectedDate,
        timeSlot: _selectedTimeSlot,
        guestCount: _guestCount,
        seatingArea: _selectedSeating,
        notes: _notesController.text.trim(),
      );

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'Table Reserved!',
                style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Your table for $_guestCount guests on ${DateFormat('EEE, d MMM').format(_selectedDate)} at $_selectedTimeSlot has been confirmed.',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoffee),
                child: const Text('View Reservations'),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book table: $e')),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bookings = ref.watch(bookingsStreamProvider).value ?? ref.read(dataRepositoryProvider).currentBookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Table'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.coffeeGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.coffee_rounded, color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Caffè Royale Lounge',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        Text(
                          'Complimentary welcome espresso shots included with every reservation.',
                          style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. Date Selection (Next 7 Days)
            Text('1. Select Date', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index + 1));
                  final isSelected = DateUtils.isSameDay(_selectedDate, date);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.cardDark : AppColors.oatMilk),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date).toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white70 : AppColors.textMutedLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d').format(date),
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: isSelected ? Colors.white : (isDark ? Colors.white : AppColors.textDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 2. Time Slot Chips
            Text('2. Select Time Slot', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((slot) {
                final isSelected = _selectedTimeSlot == slot;
                return ChoiceChip(
                  label: Text(slot),
                  selected: isSelected,
                  selectedColor: AppColors.primaryCoffee,
                  backgroundColor: isDark ? AppColors.cardDark : AppColors.oatMilk,
                  labelStyle: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.textDark),
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedTimeSlot = slot);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // 3. Guest Count Stepper
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('3. Number of Guests', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700)),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.oatMilk,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: _guestCount > 1 ? () => setState(() => _guestCount--) : null,
                      ),
                      Text('$_guestCount Guests', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w800)),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: _guestCount < 12 ? () => setState(() => _guestCount++) : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Seating Area
            Text('4. Preferred Seating Area', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ..._seatingAreas.map((area) {
              final isSelected = _selectedSeating == area['title'];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                onTap: () => setState(() => _selectedSeating = area['title'] as String),
                border: Border.all(
                  color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isSelected ? 2 : 1,
                ),
                child: Row(
                  children: [
                    Icon(area['icon'] as IconData, color: isSelected ? AppColors.primaryCoffee : AppColors.textMutedLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(area['title'] as String, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14)),
                          Text(area['desc'] as String, style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
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
            const SizedBox(height: 28),

            // Book Button
            CustomButton(
              text: 'Confirm Reservation',
              isLoading: _isBooking,
              icon: Icons.calendar_month_rounded,
              onPressed: _handleBookTable,
            ),
            const SizedBox(height: 36),

            // Existing Reservations History
            if (bookings.isNotEmpty) ...[
              Text('My Reservations', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              ...bookings.map((b) {
                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${DateFormat('d MMM, yyyy').format(b.date)} • ${b.timeSlot.split(' - ').first}',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 15),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: b.status == BookingStatus.confirmed
                                  ? AppColors.accentGreen.withOpacity(0.15)
                                  : AppColors.accentGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              b.status.name.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: b.status == BookingStatus.confirmed ? AppColors.accentGreen : AppColors.accentGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Party of ${b.guestCount} • ${b.seatingArea}',
                        style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight),
                      ),
                      if (b.notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text('Note: ${b.notes}', style: GoogleFonts.outfit(fontSize: 12, fontStyle: FontStyle.italic)),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
