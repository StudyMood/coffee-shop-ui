import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brew_haven/core/constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewsCount;
  final double size;
  final bool showNumber;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewsCount,
    this.size = 14,
    this.showNumber = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.accentGold,
          size: size,
        ),
        const SizedBox(width: 4),
        if (showNumber)
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.outfit(
              fontSize: size * 0.9,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (reviewsCount != null) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewsCount)',
            style: GoogleFonts.outfit(
              fontSize: size * 0.8,
              color: AppColors.textMutedLight,
            ),
          ),
        ],
      ],
    );
  }
}
