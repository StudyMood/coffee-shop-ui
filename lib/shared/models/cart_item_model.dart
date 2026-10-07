import 'product_model.dart';

class CartItemModel {
  final String id;
  final ProductModel product;
  final String selectedSize;
  final String selectedSugar;
  final String selectedMilk;
  final List<String> selectedExtras;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.selectedSize,
    required this.selectedSugar,
    required this.selectedMilk,
    required this.selectedExtras,
    this.quantity = 1,
  });

  double get unitPrice {
    double price = product.basePrice;
    // Size addition
    price += product.sizePriceAdditions[selectedSize] ?? 0.0;
    // Milk additions
    if (selectedMilk.contains('+₹30')) price += 30.0;
    if (selectedMilk.contains('+₹40')) price += 40.0;
    // Extras additions
    for (final extra in selectedExtras) {
      price += product.extras[extra] ?? 0.0;
    }
    return price;
  }

  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    String? selectedSize,
    String? selectedSugar,
    String? selectedMilk,
    List<String>? selectedExtras,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedSugar: selectedSugar ?? this.selectedSugar,
      selectedMilk: selectedMilk ?? this.selectedMilk,
      selectedExtras: selectedExtras ?? this.selectedExtras,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'selectedSize': selectedSize,
      'selectedSugar': selectedSugar,
      'selectedMilk': selectedMilk,
      'selectedExtras': selectedExtras,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] ?? '',
      product: ProductModel.fromMap(Map<String, dynamic>.from(map['product'] ?? {})),
      selectedSize: map['selectedSize'] ?? 'Medium',
      selectedSugar: map['selectedSugar'] ?? 'Regular',
      selectedMilk: map['selectedMilk'] ?? 'Whole Milk',
      selectedExtras: List<String>.from(map['selectedExtras'] ?? []),
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}
