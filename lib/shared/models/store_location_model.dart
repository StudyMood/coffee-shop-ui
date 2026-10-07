class StoreLocationModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String phone;
  final String workingHours;
  final double distanceKm;
  final double rating;

  const StoreLocationModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.workingHours,
    required this.distanceKm,
    this.rating = 4.9,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        'workingHours': workingHours,
        'distanceKm': distanceKm,
        'rating': rating,
      };

  factory StoreLocationModel.fromMap(Map<String, dynamic> map) => StoreLocationModel(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        address: map['address'] ?? '',
        latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
        phone: map['phone'] ?? '',
        workingHours: map['workingHours'] ?? '7:00 AM - 11:00 PM',
        distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 1.2,
        rating: (map['rating'] as num?)?.toDouble() ?? 4.9,
      );
}

class ReviewModel {
  final String id;
  final String productId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'productId': productId,
        'userName': userName,
        'userAvatar': userAvatar,
        'rating': rating,
        'comment': comment,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReviewModel.fromMap(Map<String, dynamic> map) => ReviewModel(
        id: map['id'] ?? '',
        productId: map['productId'] ?? '',
        userName: map['userName'] ?? 'Coffee Lover',
        userAvatar: map['userAvatar'] ?? '',
        rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
        comment: map['comment'] ?? '',
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
            : DateTime.now(),
      );
}
