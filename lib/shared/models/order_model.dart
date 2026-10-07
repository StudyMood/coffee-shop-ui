import 'cart_item_model.dart';

enum OrderStatus {
  placed,
  accepted,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.accepted:
        return 'Accepted';
      case OrderStatus.preparing:
        return 'Preparing Brew';
      case OrderStatus.ready:
        return 'Ready for Pickup / Dispatch';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.accepted:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.outForDelivery:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return -1;
    }
  }
}

class OrderTimelineEvent {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;

  const OrderTimelineEvent({
    required this.title,
    required this.description,
    required this.timestamp,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory OrderTimelineEvent.fromMap(Map<String, dynamic> map) => OrderTimelineEvent(
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        timestamp: map['timestamp'] != null
            ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
            : DateTime.now(),
        isCompleted: map['isCompleted'] ?? false,
      );
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String userId;
  final String customerName;
  final String customerPhone;
  final List<CartItemModel> items;
  final String deliveryType; // 'Doorstep Delivery' or 'Store Pickup'
  final String deliveryAddress;
  final String paymentMethod; // 'UPI', 'Credit Card', 'Cash on Delivery'
  final double subtotal;
  final double tax;
  final double deliveryCharge;
  final double discount;
  final double grandTotal;
  final OrderStatus status;
  final DateTime createdAt;
  final int estimatedMinutes;
  final List<OrderTimelineEvent> timeline;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.deliveryType,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.deliveryCharge,
    required this.discount,
    required this.grandTotal,
    required this.status,
    required this.createdAt,
    this.estimatedMinutes = 20,
    required this.timeline,
  });

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? userId,
    String? customerName,
    String? customerPhone,
    List<CartItemModel>? items,
    String? deliveryType,
    String? deliveryAddress,
    String? paymentMethod,
    double? subtotal,
    double? tax,
    double? deliveryCharge,
    double? discount,
    double? grandTotal,
    OrderStatus? status,
    DateTime? createdAt,
    int? estimatedMinutes,
    List<OrderTimelineEvent>? timeline,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      userId: userId ?? this.userId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      deliveryType: deliveryType ?? this.deliveryType,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      discount: discount ?? this.discount,
      grandTotal: grandTotal ?? this.grandTotal,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      timeline: timeline ?? this.timeline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'userId': userId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'items': items.map((e) => e.toMap()).toList(),
      'deliveryType': deliveryType,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'tax': tax,
      'deliveryCharge': deliveryCharge,
      'discount': discount,
      'grandTotal': grandTotal,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'estimatedMinutes': estimatedMinutes,
      'timeline': timeline.map((e) => e.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      orderNumber: map['orderNumber'] ?? 'BH-0001',
      userId: map['userId'] ?? '',
      customerName: map['customerName'] ?? 'Customer',
      customerPhone: map['customerPhone'] ?? '',
      items: (map['items'] as List? ?? [])
          .map((e) => CartItemModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      deliveryType: map['deliveryType'] ?? 'Doorstep Delivery',
      deliveryAddress: map['deliveryAddress'] ?? '124 High Street, Indiranagar',
      paymentMethod: map['paymentMethod'] ?? 'UPI',
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (map['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      grandTotal: (map['grandTotal'] as num?)?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => OrderStatus.placed,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      estimatedMinutes: (map['estimatedMinutes'] as num?)?.toInt() ?? 20,
      timeline: (map['timeline'] as List? ?? [])
          .map((e) => OrderTimelineEvent.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
