import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/widgets/custom_button.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isTorchOn = false;
  String? _scannedTable;

  void _onScanned(String tableNumber) {
    setState(() => _scannedTable = tableNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Scan Table QR', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
              color: _isTorchOn ? AppColors.accentGold : Colors.white,
            ),
            onPressed: () => setState(() => _isTorchOn = !_isTorchOn),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Viewfinder Background Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Viewfinder
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primaryCoffee, width: 3),
                  ),
                  child: Stack(
                    children: [
                      // Scanner corners
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 3,
                          width: 240,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, AppColors.primaryCoffee, Colors.transparent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryCoffee.withOpacity(0.8),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 10, end: 240, duration: 1800.ms),
                      ),
                      Center(
                        child: Icon(
                          Icons.qr_code_2_rounded,
                          size: 140,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Point camera at the table QR code',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Digital dining menu will open automatically',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 32),

                // Quick Demo Scan Buttons for testing
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Simulate QR Detection (Test Environment)',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentGold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _onScanned('Table 04 (Indiranagar Roastery)'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: AppColors.primaryCoffee),
                              ),
                              child: const Text('Scan Table 04'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _onScanned('Table 12 (Window Bar)'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: AppColors.primaryCoffee),
                              ),
                              child: const Text('Scan Table 12'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scanned Success Dialog
          if (_scannedTable != null)
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primaryCoffee),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 48),
                      const SizedBox(height: 14),
                      Text(
                        'QR Code Verified!',
                        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Connected to $_scannedTable. Place your order now and food will be served directly to your seat.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(fontSize: 13, color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Open Table Menu',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
