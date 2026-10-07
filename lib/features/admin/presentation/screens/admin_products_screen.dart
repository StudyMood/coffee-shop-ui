import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/constants/app_assets.dart';
import 'package:brew_haven/core/widgets/glass_card.dart';
import 'package:brew_haven/core/widgets/app_image.dart';
import 'package:brew_haven/core/widgets/custom_text_field.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

class _PresetItem {
  final String label;
  final String asset;
  const _PresetItem(this.label, this.asset);
}

const List<_PresetItem> _cafePresets = [
  _PresetItem('Espresso', AppAssets.espresso),
  _PresetItem('Latte', AppAssets.latte),
  _PresetItem('Cappuccino', AppAssets.cappuccino),
  _PresetItem('Caramel Macchiato', AppAssets.caramelMacchiato),
  _PresetItem('Mocha', AppAssets.mocha),
  _PresetItem('Cold Brew', AppAssets.coldBrew),
  _PresetItem('Cutting Chai', AppAssets.cuttingChai),
  _PresetItem('Artisan Tea', AppAssets.artisanBlackTea),
  _PresetItem('Croissant', AppAssets.croissant),
  _PresetItem('Blueberry Muffin', AppAssets.blueberryMuffin),
];

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  void _showProductDialog(BuildContext context, WidgetRef ref, {ProductModel? editProduct}) {
    final isEdit = editProduct != null;
    final nameController = TextEditingController(text: editProduct?.name ?? '');
    final priceController = TextEditingController(
      text: editProduct != null ? editProduct.basePrice.toStringAsFixed(0) : '',
    );
    final descController = TextEditingController(text: editProduct?.description ?? '');
    final calController = TextEditingController(
      text: editProduct != null ? editProduct.calories.toString() : '160',
    );
    final urlController = TextEditingController(
      text: (editProduct != null && (editProduct.imageUrl.startsWith('http://') || editProduct.imageUrl.startsWith('https://')))
          ? editProduct.imageUrl
          : '',
    );

    String selectedCat = editProduct?.category ?? 'Espresso';
    String selectedImageUrl = editProduct?.imageUrl ?? '';
    bool isPickingImage = false;
    bool showUrlInput = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;

          Future<void> pickImage(ImageSource source) async {
            try {
              setDialogState(() => isPickingImage = true);
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: source,
                maxWidth: 900,
                maxHeight: 900,
                imageQuality: 85,
              );
              if (picked != null) {
                final bytes = await picked.readAsBytes();
                final base64String = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                setDialogState(() {
                  selectedImageUrl = base64String;
                  urlController.clear();
                  isPickingImage = false;
                });
              } else {
                setDialogState(() => isPickingImage = false);
              }
            } catch (e) {
              setDialogState(() => isPickingImage = false);
              if (ctx.mounted) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    content: Text('Image selection notice: $e'),
                    backgroundColor: AppColors.accentRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          }

          return AlertDialog(
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Product' : 'Add New Product',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  isEdit ? 'Update product details, pricing, and photo.' : 'Add a new handcrafted item to the menu.',
                  style: GoogleFonts.outfit(fontSize: 13, color: AppColors.textMutedLight, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            content: SizedBox(
              width: 440,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Product Image Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product Image',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                        if (selectedImageUrl.isNotEmpty)
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              setDialogState(() {
                                selectedImageUrl = '';
                                urlController.clear();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.delete_outline_rounded, size: 15, color: AppColors.accentRed),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Remove',
                                    style: GoogleFonts.outfit(fontSize: 12, color: AppColors.accentRed, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (selectedImageUrl.isNotEmpty) ...[
                      // Image Preview
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primaryCoffee.withOpacity(0.5), width: 1.5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: AppImage(
                                imageUrl: selectedImageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Material(
                              color: Colors.black.withOpacity(0.75),
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => pickImage(ImageSource.gallery),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.photo_library_outlined, size: 14, color: Colors.white),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Change Photo',
                                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Image Selected',
                                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Upload Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (isPickingImage)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primaryCoffee),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Loading image...'),
                                  ],
                                ),
                              )
                            else ...[
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryCoffee.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primaryCoffee, size: 26),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Upload Product Image',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark ? AppColors.textLight : AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose an image from your device or take a photo',
                                style: GoogleFonts.outfit(fontSize: 12, color: AppColors.textMutedLight),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () => pickImage(ImageSource.gallery),
                                    icon: const Icon(Icons.photo_library_rounded, size: 16, color: Colors.white),
                                    label: Text(
                                      'Upload from Gallery',
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryCoffee,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => pickImage(ImageSource.camera),
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                      color: isDark ? AppColors.textLight : AppColors.textDark,
                                    ),
                                    label: Text(
                                      'Camera',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: isDark ? AppColors.textLight : AppColors.textDark,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    // Presets & URL Link selector
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Or Choose Cafe Preset:',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMutedLight,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => setDialogState(() => showUrlInput = !showUrlInput),
                          child: Row(
                            children: [
                              Icon(
                                showUrlInput ? Icons.keyboard_arrow_up_rounded : Icons.link_rounded,
                                size: 14,
                                color: AppColors.primaryCoffee,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                showUrlInput ? 'Hide URL' : 'Paste Image URL',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryCoffee,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _cafePresets.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, idx) {
                          final p = _cafePresets[idx];
                          final isSelected = selectedImageUrl == p.asset;
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setDialogState(() {
                                selectedImageUrl = p.asset;
                                urlController.clear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryCoffee.withOpacity(0.18)
                                    : (isDark ? AppColors.cardDark : AppColors.backgroundLight),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryCoffee : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: AppImage(
                                      imageUrl: p.asset,
                                      width: 22,
                                      height: 22,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    p.label,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primaryCoffee
                                          : (isDark ? AppColors.textLight : AppColors.textDark),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    if (showUrlInput) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: urlController,
                              hintText: 'https://images.unsplash.com/...',
                              prefixIcon: const Icon(Icons.link_rounded, size: 18),
                              onChanged: (val) {
                                if (val.trim().isNotEmpty) {
                                  setDialogState(() => selectedImageUrl = val.trim());
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final link = urlController.text.trim();
                              if (link.isNotEmpty) {
                                setDialogState(() => selectedImageUrl = link);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryCoffee,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: nameController,
                      labelText: 'Product Name',
                      hintText: 'Hazelnut Cortado',
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCat,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: ['Espresso', 'Cappuccino', 'Latte', 'Cold Coffee', 'Tea', 'Snacks']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCat = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: priceController,
                      labelText: 'Base Price (₹)',
                      hintText: '220',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: calController,
                      labelText: 'Calories (kcal)',
                      hintText: '150',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: descController,
                      labelText: 'Description',
                      hintText: 'Hand-pulled espresso with steamed hazelnut milk...',
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel', style: GoogleFonts.outfit(color: AppColors.textMutedLight)),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final price = double.tryParse(priceController.text.trim()) ?? 180.0;
                  final calories = int.tryParse(calController.text.trim()) ?? 150;
                  final desc = descController.text.trim();

                  // Determine final image URL
                  String finalImageUrl = selectedImageUrl.trim();
                  if (finalImageUrl.isEmpty && urlController.text.trim().isNotEmpty) {
                    finalImageUrl = urlController.text.trim();
                  }
                  if (finalImageUrl.isEmpty) {
                    // Category-based default fallback
                    switch (selectedCat.toLowerCase()) {
                      case 'cappuccino':
                        finalImageUrl = AppAssets.cappuccino;
                        break;
                      case 'latte':
                        finalImageUrl = AppAssets.latte;
                        break;
                      case 'tea':
                        finalImageUrl = AppAssets.cuttingChai;
                        break;
                      case 'snacks':
                        finalImageUrl = AppAssets.croissant;
                        break;
                      case 'cold coffee':
                        finalImageUrl = AppAssets.coldBrew;
                        break;
                      case 'espresso':
                      default:
                        finalImageUrl = AppAssets.espresso;
                        break;
                    }
                  }

                  if (name.isNotEmpty) {
                    if (isEdit) {
                      final updated = editProduct.copyWith(
                        name: name,
                        category: selectedCat,
                        description: desc.isNotEmpty ? desc : editProduct.description,
                        basePrice: price,
                        calories: calories,
                        imageUrl: finalImageUrl,
                      );
                      ref.read(dataRepositoryProvider).updateProduct(updated);
                    } else {
                      final newProd = ProductModel(
                        id: const Uuid().v4(),
                        name: name,
                        category: selectedCat,
                        description: desc.isNotEmpty ? desc : 'Signature handcrafted artisan brew.',
                        basePrice: price,
                        rating: 5.0,
                        reviewsCount: 1,
                        imageUrl: finalImageUrl,
                        calories: calories,
                        roastLevel: 'Fresh Roast',
                      );
                      ref.read(dataRepositoryProvider).addProduct(newProd);
                    }
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEdit ? 'Product updated successfully!' : 'Product added successfully!'),
                        backgroundColor: AppColors.accentGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryCoffee,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  isEdit ? 'Save Changes' : 'Add Product',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Product', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
        content: Text(
          'Are you sure you want to remove "${product.name}" from the menu?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(dataRepositoryProvider).deleteProduct(product.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${product.name}" deleted.'),
                  backgroundColor: AppColors.accentRed,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentRed),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsStreamProvider).value ?? ref.read(dataRepositoryProvider).currentProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Product',
            onPressed: () => _showProductDialog(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryCoffee,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('New Product', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
        onPressed: () => _showProductDialog(context, ref),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showProductDialog(context, ref, editProduct: product),
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  AppImage(
                    imageUrl: product.imageUrl,
                    width: 64,
                    height: 64,
                    borderRadius: BorderRadius.circular(12),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 15)),
                        Text('${product.category} • ₹${product.basePrice.toInt()}',
                            style: GoogleFonts.outfit(fontSize: 13, color: AppColors.primaryCoffee, fontWeight: FontWeight.w600)),
                        Text('${product.calories} kcal • ${product.roastLevel}',
                            style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMutedLight)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primaryCoffee, size: 20),
                    tooltip: 'Edit Product',
                    onPressed: () => _showProductDialog(context, ref, editProduct: product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.accentRed, size: 20),
                    tooltip: 'Delete Product',
                    onPressed: () => _confirmDelete(context, ref, product),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
