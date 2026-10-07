class CouponModel {
  final String code;
  final String description;
  final double discountPercent; // e.g. 20 for 20%
  final double flatDiscount; // e.g. 50 for ₹50
  final double minOrderAmount;
  final double maxDiscountAmount;

  const CouponModel({
    required this.code,
    required this.description,
    this.discountPercent = 0.0,
    this.flatDiscount = 0.0,
    this.minOrderAmount = 0.0,
    this.maxDiscountAmount = 9999.0,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderAmount) return 0.0;
    double discount = 0.0;
    if (discountPercent > 0) {
      discount = (subtotal * discountPercent) / 100.0;
      if (discount > maxDiscountAmount) {
        discount = maxDiscountAmount;
      }
    } else if (flatDiscount > 0) {
      discount = flatDiscount;
    }
    return discount > subtotal ? subtotal : discount;
  }

  Map<String, dynamic> toMap() => {
        'code': code,
        'description': description,
        'discountPercent': discountPercent,
        'flatDiscount': flatDiscount,
        'minOrderAmount': minOrderAmount,
        'maxDiscountAmount': maxDiscountAmount,
      };

  factory CouponModel.fromMap(Map<String, dynamic> map) => CouponModel(
        code: map['code'] ?? '',
        description: map['description'] ?? '',
        discountPercent: (map['discountPercent'] as num?)?.toDouble() ?? 0.0,
        flatDiscount: (map['flatDiscount'] as num?)?.toDouble() ?? 0.0,
        minOrderAmount: (map['minOrderAmount'] as num?)?.toDouble() ?? 0.0,
        maxDiscountAmount: (map['maxDiscountAmount'] as num?)?.toDouble() ?? 9999.0,
      );
}
