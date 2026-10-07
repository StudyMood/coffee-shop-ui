import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/shared/models/booking_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class AdminBookingsScreen extends ConsumerWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsStreamProvider).value ?? ref.read(dataRepositoryProvider).currentBookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Reservations'),
      ),
      body: bookings.isEmpty
          ? Center(
              child: Text('No reservations yet', style: GoogleFonts.outfit(fontSize: 16)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final isConfirmed = booking.status == BookingStatus.confirmed;

                return GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            booking.customerName,
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isConfirmed
                                  ? AppColors.accentGreen.withOpacity(0.15)
                                  : AppColors.accentRed.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.status.name.toUpperCase(),
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isConfirmed ? AppColors.accentGreen : AppColors.accentRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Contact: ${booking.customerPhone}'),
                      Text('Date: ${DateFormat('EEE, d MMM yyyy').format(booking.date)} (${booking.timeSlot})'),
                      Text('Party: ${booking.guestCount} Guests • ${booking.seatingArea}'),
                      if (booking.notes.isNotEmpty) Text('Notes: ${booking.notes}'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isConfirmed)
                            ElevatedButton(
                              onPressed: () {
                                ref.read(dataRepositoryProvider).updateBookingStatus(booking.id, BookingStatus.confirmed);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen),
                              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                            )
                          else
                            OutlinedButton(
                              onPressed: () {
                                ref.read(dataRepositoryProvider).updateBookingStatus(booking.id, BookingStatus.cancelled);
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.accentRed),
                              ),
                              child: const Text('Cancel Booking', style: TextStyle(color: AppColors.accentRed)),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
