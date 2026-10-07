enum BookingStatus {
  pending,
  confirmed,
  cancelled,
}

class BookingModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final DateTime date;
  final String timeSlot;
  final int guestCount;
  final String seatingArea; // 'Cozy Indoor', 'Patio Garden', 'Window Bar'
  final BookingStatus status;
  final String notes;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.seatingArea,
    this.status = BookingStatus.confirmed,
    this.notes = '',
    required this.createdAt,
  });

  BookingModel copyWith({
    String? id,
    String? userId,
    String? customerName,
    String? customerPhone,
    DateTime? date,
    String? timeSlot,
    int? guestCount,
    String? seatingArea,
    BookingStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      guestCount: guestCount ?? this.guestCount,
      seatingArea: seatingArea ?? this.seatingArea,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'guestCount': guestCount,
      'seatingArea': seatingArea,
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(map['date']) ?? DateTime.now()
          : DateTime.now(),
      timeSlot: map['timeSlot'] ?? '5:00 PM - 6:00 PM',
      guestCount: (map['guestCount'] as num?)?.toInt() ?? 2,
      seatingArea: map['seatingArea'] ?? 'Cozy Indoor',
      status: BookingStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      notes: map['notes'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
