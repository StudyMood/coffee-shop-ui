import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';

class DribbbleNewsletterCard extends StatefulWidget {
  const DribbbleNewsletterCard({super.key});

  @override
  State<DribbbleNewsletterCard> createState() => _DribbbleNewsletterCardState();
}

class _DribbbleNewsletterCardState extends State<DribbbleNewsletterCard> {
  final _emailController = TextEditingController();
  bool _isSubscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubscribe() {
    final text = _emailController.text.trim();
    if (text.isNotEmpty && text.contains('@')) {
      setState(() {
        _isSubscribed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '☕ Welcome to the VIP Brew Club! 15% discount code sent.',
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColors.primaryCoffee,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF261710),
            Color(0xFF1B1009),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFD4AC83).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC67C4E).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_rounded,
                  color: Color(0xFFE5A96A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'EXCLUSIVE VIP PRIVILEGES',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: const Color(0xFFE5A96A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Stay Up To Date On\nAll News And Offers.',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: const Color(0xFFF9F5F0),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Receive secret roast launches, invitations to barista tasting sessions, and 15% off your first online order.',
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: const Color(0xFFC7B9AD),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          if (_isSubscribed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF81C784), size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'You are in the VIP Circle! Use code VIP15',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFA5D6A7),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        hintStyle: GoogleFonts.outfit(
                          color: const Color(0xFF8C7E74),
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: Color(0xFFB3A598),
                          size: 18,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleSubscribe,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC67C4E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Join',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
