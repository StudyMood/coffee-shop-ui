import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:brew_haven/core/constants/app_colors.dart';

/// Reusable universal image widget that automatically handles
/// local assets (assets/images/...), network URLs (http/https/blob),
/// and base64 data URIs (data:image/...).
class AppImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    final trimmed = imageUrl.trim();

    if (trimmed.startsWith('data:image/') || trimmed.startsWith('data:application/')) {
      try {
        final commaIdx = trimmed.indexOf(',');
        final base64Data = commaIdx != -1 ? trimmed.substring(commaIdx + 1) : trimmed;
        final bytes = base64Decode(base64Data);
        imageWidget = Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      } catch (_) {
        imageWidget = _buildFallback();
      }
    } else if (trimmed.startsWith('http://') || trimmed.startsWith('https://') || trimmed.startsWith('blob:')) {
      imageWidget = Image.network(
        trimmed,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.primaryCoffee.withOpacity(0.08),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryCoffee),
              ),
            ),
          );
        },
      );
    } else if (trimmed.isNotEmpty) {
      imageWidget = Image.asset(
        trimmed,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildFallback(),
      );
    } else {
      imageWidget = _buildFallback();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.primaryCoffee.withOpacity(0.12),
      child: const Center(
        child: Icon(
          Icons.coffee_rounded,
          color: AppColors.primaryCoffee,
          size: 32,
        ),
      ),
    );
  }
}
