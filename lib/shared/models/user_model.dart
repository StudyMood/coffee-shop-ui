class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final int loyaltyPoints;
  final String referralCode;
  final String role; // 'customer' or 'admin'
  final DateTime createdAt;
  final List<String> addresses;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.loyaltyPoints,
    required this.referralCode,
    this.role = 'customer',
    required this.createdAt,
    this.addresses = const [],
  });

  bool get isAdmin => role == 'admin';

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    int? loyaltyPoints,
    String? referralCode,
    String? role,
    DateTime? createdAt,
    List<String>? addresses,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      referralCode: referralCode ?? this.referralCode,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      addresses: addresses ?? this.addresses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'loyaltyPoints': loyaltyPoints,
      'referralCode': referralCode,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'addresses': addresses,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'] ?? '',
      loyaltyPoints: (map['loyaltyPoints'] as num?)?.toInt() ?? 0,
      referralCode: map['referralCode'] ?? 'BREW100',
      role: map['role'] ?? 'customer',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      addresses: List<String>.from(map['addresses'] ?? []),
    );
  }
}
