class ProductModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double basePrice;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final bool isPopular;
  final bool isFeatured;
  final int calories;
  final String roastLevel;
  final List<String> availableSizes;
  final Map<String, double> sizePriceAdditions;
  final List<String> sugarLevels;
  final List<String> milkOptions;
  final Map<String, double> extras;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.basePrice,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    this.isPopular = false,
    this.isFeatured = false,
    this.calories = 140,
    this.roastLevel = 'Medium Roast',
    this.availableSizes = const ['Small', 'Medium', 'Large'],
    this.sizePriceAdditions = const {
      'Small': 0.0,
      'Medium': 40.0,
      'Large': 80.0,
    },
    this.sugarLevels = const ['No Sugar', 'Less Sugar', 'Regular'],
    this.milkOptions = const ['Whole Milk', 'Oat Milk (+₹30)', 'Almond Milk (+₹40)', 'Soy Milk (+₹30)'],
    this.extras = const {
      'Extra Shot': 50.0,
      'Chocolate Syrup': 30.0,
      'Whipped Cream': 40.0,
      'Vanilla Syrup': 35.0,
    },
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    double? basePrice,
    double? rating,
    int? reviewsCount,
    String? imageUrl,
    bool? isPopular,
    bool? isFeatured,
    int? calories,
    String? roastLevel,
    List<String>? availableSizes,
    Map<String, double>? sizePriceAdditions,
    List<String>? sugarLevels,
    List<String>? milkOptions,
    Map<String, double>? extras,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageUrl: imageUrl ?? this.imageUrl,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
      calories: calories ?? this.calories,
      roastLevel: roastLevel ?? this.roastLevel,
      availableSizes: availableSizes ?? this.availableSizes,
      sizePriceAdditions: sizePriceAdditions ?? this.sizePriceAdditions,
      sugarLevels: sugarLevels ?? this.sugarLevels,
      milkOptions: milkOptions ?? this.milkOptions,
      extras: extras ?? this.extras,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'basePrice': basePrice,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'imageUrl': imageUrl,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
      'calories': calories,
      'roastLevel': roastLevel,
      'availableSizes': availableSizes,
      'sizePriceAdditions': sizePriceAdditions,
      'sugarLevels': sugarLevels,
      'milkOptions': milkOptions,
      'extras': extras,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'Espresso',
      description: map['description'] ?? '',
      basePrice: (map['basePrice'] as num?)?.toDouble() ?? 150.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: (map['reviewsCount'] as num?)?.toInt() ?? 120,
      imageUrl: map['imageUrl'] ?? '',
      isPopular: map['isPopular'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      calories: (map['calories'] as num?)?.toInt() ?? 140,
      roastLevel: map['roastLevel'] ?? 'Medium Roast',
      availableSizes: List<String>.from(map['availableSizes'] ?? ['Small', 'Medium', 'Large']),
      sizePriceAdditions: Map<String, double>.from(
        (map['sizePriceAdditions'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toDouble())) ?? {
          'Small': 0.0,
          'Medium': 40.0,
          'Large': 80.0,
        },
      ),
      sugarLevels: List<String>.from(map['sugarLevels'] ?? ['No Sugar', 'Less Sugar', 'Regular']),
      milkOptions: List<String>.from(
        map['milkOptions'] ?? ['Whole Milk', 'Oat Milk (+₹30)', 'Almond Milk (+₹40)', 'Soy Milk (+₹30)'],
      ),
      extras: Map<String, double>.from(
        (map['extras'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toDouble())) ?? {
          'Extra Shot': 50.0,
          'Chocolate Syrup': 30.0,
          'Whipped Cream': 40.0,
        },
      ),
    );
  }
}
