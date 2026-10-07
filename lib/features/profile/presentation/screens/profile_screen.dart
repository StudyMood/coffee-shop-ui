import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/constants/app_assets.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';
import 'package:brew_haven/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:brew_haven/features/loyalty/presentation/screens/loyalty_screen.dart';
import 'package:brew_haven/features/referral/presentation/screens/referral_screen.dart';
import 'package:brew_haven/features/orders/presentation/screens/orders_list_screen.dart';
import 'package:brew_haven/features/bookings/presentation/screens/bookings_screen.dart';
import 'package:brew_haven/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:brew_haven/core/widgets/theme_toggle_button.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showProfilePhotoPicker(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<String> presetAvatars = [
      AppAssets.defaultAvatar,
      AppAssets.adminAvatar,
      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
    ];

    Future<void> pickAndSetImage(ImageSource source) async {
      Navigator.of(context).pop();
      try {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: source,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );
        if (picked != null) {
          final bytes = await picked.readAsBytes();
          final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';
          await ref.read(currentUserProvider.notifier).updateProfileImage(base64String);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile photo updated successfully!'),
                backgroundColor: AppColors.accentGreen,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update photo: $e'),
              backgroundColor: AppColors.accentRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Update Profile Photo',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              'Upload a photo from your device, take a selfie, or choose an avatar',
              style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickAndSetImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded, size: 18, color: Colors.white),
                    label: Text(
                      'Gallery / Files',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryCoffee,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => pickAndSetImage(ImageSource.camera),
                    icon: Icon(
                      Icons.camera_alt_rounded,
                      size: 18,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                    label: Text(
                      'Camera',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Or Choose Avatar Preset:',
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMutedLight),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: presetAvatars.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, idx) {
                  final img = presetAvatars[idx];
                  return InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await ref.read(currentUserProvider.notifier).updateProfileImage(img);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Avatar updated!'),
                            backgroundColor: AppColors.accentGreen,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.4), width: 1.5),
                      ),
                      child: ClipOval(
                        child: AppImage(
                          imageUrl: img,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryCoffee.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.link_rounded, color: AppColors.primaryCoffee, size: 20),
              ),
              title: Text('Paste Image Link', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700)),
              subtitle: Text('Use any image URL from web', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                Navigator.of(context).pop();
                _showUrlInputDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUrlInputDialog(BuildContext context, WidgetRef ref) {
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Paste Image URL', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
        content: TextField(
          controller: urlController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'https://images.unsplash.com/...',
            labelText: 'Image Link',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final link = urlController.text.trim();
              if (link.isNotEmpty) {
                Navigator.of(ctx).pop();
                await ref.read(currentUserProvider.notifier).updateProfileImage(link);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile photo updated!'),
                      backgroundColor: AppColors.accentGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryCoffee),
            child: const Text('Save Photo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          const ThemeToggleButton(),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Header Card
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _showProfilePhotoPicker(context, ref),
                    child: Stack(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryCoffee, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryCoffee.withOpacity(0.25),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: AppImage(
                              imageUrl: (user?.profileImage != null && user!.profileImage.isNotEmpty)
                                  ? user.profileImage
                                  : AppAssets.defaultAvatar,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: AppColors.primaryCoffee,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Coffee Enthusiast',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.email ?? 'customer@brewhaven.com',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: user?.isAdmin == true ? AppColors.accentRed.withOpacity(0.15) : AppColors.accentGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      user?.isAdmin == true ? 'ADMINISTRATOR' : 'GOLD CLUB MEMBER',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: user?.isAdmin == true ? AppColors.accentRed : AppColors.accentGold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Switch to Admin Portal Card (Only visible to verified Administrators)
            if (user?.isAdmin == true) ...[
              GlassCard(
                padding: const EdgeInsets.all(16),
                border: Border.all(color: AppColors.primaryCoffee, width: 1.5),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                  );
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryCoffee.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primaryCoffee, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Open Admin Dashboard',
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primaryCoffee),
                          ),
                          Text(
                            'Manage products, live orders & analytics',
                            style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryCoffee),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Loyalty & Referral Quick Cards Row
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoyaltyScreen()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.accentGold, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          '${user?.loyaltyPoints ?? 340} Pts',
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        Text('Loyalty Wallet', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReferralScreen()),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.card_giftcard_rounded, color: AppColors.primaryCoffee, size: 28),
                        const SizedBox(height: 8),
                        Text(
                          user?.referralCode ?? 'BREW100',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        Text('Refer & Earn', style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Appearance & Theme Mode Quick Switch Card
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryCoffee.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: AppColors.primaryCoffee,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appearance & Theme Mode',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Switch between Light, Dark or System mode',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const ThemeModeSegmentedControl(),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Menu Items List
            GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.receipt_long_rounded,
                    title: 'My Orders',
                    subtitle: 'Order history & live tracking',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const OrdersListScreen()),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.table_restaurant_rounded,
                    title: 'Table Reservations',
                    subtitle: 'Manage upcoming cafe bookings',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BookingsScreen()),
                    ),
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: '${user?.addresses.length ?? 1} saved locations',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delivery addresses managed at checkout')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'App Settings',
                    subtitle: 'Dark mode, Language, Notifications',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            TextButton.icon(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const SignInScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.accentRed),
              label: Text(
                'Log Out',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryCoffee.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primaryCoffee, size: 20),
      ),
      title: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMutedLight),
      onTap: onTap,
    );
  }
}
