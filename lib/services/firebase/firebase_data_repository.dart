import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_haven/core/constants/app_assets.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/models/order_model.dart';
import 'package:brew_haven/shared/models/booking_model.dart';
import 'package:brew_haven/shared/models/coupon_model.dart';
import 'package:brew_haven/shared/models/store_location_model.dart';
import 'package:brew_haven/shared/models/cart_item_model.dart';

class FirebaseDataRepository {
  static final FirebaseDataRepository _instance = FirebaseDataRepository._internal();
  factory FirebaseDataRepository() => _instance;

  bool get _isFirebaseReady {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseFirestore? get _firestore {
    try {
      return _isFirebaseReady ? FirebaseFirestore.instance : null;
    } catch (_) {
      return null;
    }
  }

  final _uuid = const Uuid();

  // Internal reactive state
  late List<ProductModel> _products;
  late List<OrderModel> _orders;
  late List<BookingModel> _bookings;
  late List<CouponModel> _coupons;
  late List<StoreLocationModel> _stores;
  late Map<String, List<ReviewModel>> _reviews;

  // Stream Controllers for real-time reactivity
  final _productsStreamController = StreamController<List<ProductModel>>.broadcast();
  final _ordersStreamController = StreamController<List<OrderModel>>.broadcast();
  final _bookingsStreamController = StreamController<List<BookingModel>>.broadcast();

  Stream<List<ProductModel>> get productsStream => _productsStreamController.stream;
  Stream<List<OrderModel>> get ordersStream => _ordersStreamController.stream;
  Stream<List<BookingModel>> get bookingsStream => _bookingsStreamController.stream;

  List<ProductModel> get currentProducts => List.unmodifiable(_products);
  List<OrderModel> get currentOrders => List.unmodifiable(_orders);
  List<BookingModel> get currentBookings => List.unmodifiable(_bookings);
  List<CouponModel> get currentCoupons => List.unmodifiable(_coupons);
  List<StoreLocationModel> get currentStores => List.unmodifiable(_stores);

  FirebaseDataRepository._internal() {
    _initSeededData();
    _initFirestoreSync();
  }

  void _initFirestoreSync() {
    try {
      final fs = _firestore;
      if (fs == null) return;
      fs.collection('orders').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final liveOrders = snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
          _orders = liveOrders;
          _ordersStreamController.add(List.unmodifiable(_orders));
        }
      }, onError: (e) => debugPrint('Firestore orders sync notice: $e'));

      fs.collection('bookings').snapshots().listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final liveBookings = snapshot.docs.map((doc) => BookingModel.fromMap(doc.data())).toList();
          _bookings = liveBookings;
          _bookingsStreamController.add(List.unmodifiable(_bookings));
        }
      }, onError: (e) => debugPrint('Firestore bookings sync notice: $e'));
    } catch (e) {
      debugPrint('Firestore sync initialization notice: $e');
    }
  }

  void _initSeededData() {
    _products = [
      const ProductModel(
        id: 'p1',
        name: 'Caramel Macchiato',
        category: 'Espresso',
        description: 'Freshly steamed milk with vanilla-flavored syrup marked with espresso and topped with a caramel drizzle.',
        basePrice: 240.0,
        rating: 4.9,
        reviewsCount: 312,
        imageUrl: AppAssets.caramelMacchiato,
        isPopular: true,
        isFeatured: true,
        calories: 190,
        roastLevel: 'Dark Roast',
      ),
      const ProductModel(
        id: 'p2',
        name: 'Artisan Vanilla Latte',
        category: 'Latte',
        description: 'Rich, full-bodied espresso in steamed whole milk, lightly infused with pure Madagascar vanilla extract.',
        basePrice: 220.0,
        rating: 4.8,
        reviewsCount: 245,
        imageUrl: AppAssets.latte,
        isPopular: true,
        isFeatured: true,
        calories: 170,
        roastLevel: 'Medium Roast',
      ),
      const ProductModel(
        id: 'p3',
        name: 'Velvet Cappuccino',
        category: 'Cappuccino',
        description: 'Dark, rich espresso lies in wait under a smoothed and stretched layer of thick milk foam.',
        basePrice: 210.0,
        rating: 4.7,
        reviewsCount: 189,
        imageUrl: AppAssets.cappuccino,
        isPopular: true,
        isFeatured: false,
        calories: 130,
        roastLevel: 'Medium Roast',
      ),
      const ProductModel(
        id: 'p4',
        name: 'Nitro Reserve Cold Brew',
        category: 'Cold Coffee',
        description: 'Slow-steeped for 20 hours, infused with nitrogen as it pours to create a velvety cascading head.',
        basePrice: 260.0,
        rating: 4.9,
        reviewsCount: 420,
        imageUrl: AppAssets.coldBrew,
        isPopular: true,
        isFeatured: true,
        calories: 5,
        roastLevel: 'Dark Roast',
      ),
      const ProductModel(
        id: 'p0',
        name: 'Artisan 3D Velvet Latte',
        category: 'Latte',
        description: 'Our signature zero-gravity 3D extracted brew with silky microfoam rosette and slow-roasted highland beans.',
        basePrice: 260.0,
        rating: 5.0,
        reviewsCount: 512,
        imageUrl: AppAssets.hero3dSplash,
        isPopular: true,
        isFeatured: true,
        calories: 160,
        roastLevel: 'Artisan Roast',
      ),
      const ProductModel(
        id: 'p5',
        name: 'Barista Americano Reserve',
        category: 'Americano',
        description: 'Bold espresso poured over hot purified mineral water creating a rich aromatic crema ring, served in a matte artisanal mug.',
        basePrice: 180.0,
        rating: 4.9,
        reviewsCount: 280,
        imageUrl: AppAssets.americano3d,
        isPopular: true,
        isFeatured: true,
        calories: 5,
        roastLevel: 'Dark Arabica',
      ),
      const ProductModel(
        id: 'p6',
        name: 'Dark Chocolate Mocha',
        category: 'Espresso',
        description: 'Espresso combined with bittersweet mocha sauce, steamed milk, and crowned with sweetened whipped cream.',
        basePrice: 250.0,
        rating: 4.8,
        reviewsCount: 215,
        imageUrl: AppAssets.mocha,
        isPopular: true,
        isFeatured: false,
        calories: 280,
        roastLevel: 'Dark Roast',
      ),
      const ProductModel(
        id: 'p7',
        name: 'Special Cutting Chai',
        category: 'Tea',
        description: 'Authentic Indian street-style spiced milk tea brewed with crushed ginger, cardamom, and premium Assam tea leaves.',
        basePrice: 120.0,
        rating: 4.9,
        reviewsCount: 388,
        imageUrl: AppAssets.cuttingChai,
        isPopular: true,
        isFeatured: true,
        calories: 95,
        roastLevel: 'Assam Gold',
      ),
      const ProductModel(
        id: 'p7b',
        name: 'Artisan Amber Black Tea',
        category: 'Tea',
        description: 'Single-estate hand-plucked loose leaf tea, slow-steeped to a rich golden amber hue with subtle floral notes.',
        basePrice: 160.0,
        rating: 4.8,
        reviewsCount: 142,
        imageUrl: AppAssets.artisanBlackTea,
        isPopular: false,
        isFeatured: true,
        calories: 2,
        roastLevel: 'Darjeeling First Flush',
      ),
      const ProductModel(
        id: 'p8',
        name: 'Italian Gelato Affogato',
        category: 'Espresso',
        description: 'A scoop of creamy artisanal Madagascar vanilla bean gelato drowned in a piping-hot double shot of espresso.',
        basePrice: 270.0,
        rating: 5.0,
        reviewsCount: 156,
        imageUrl: AppAssets.affogato,
        isPopular: true,
        isFeatured: true,
        calories: 210,
        roastLevel: 'Italian Roast',
      ),
      const ProductModel(
        id: 'p9',
        name: 'French Butter Croissant',
        category: 'Snacks',
        description: 'Golden-brown, flaky, buttery Viennoiserie baked fresh every morning in-house.',
        basePrice: 140.0,
        rating: 4.8,
        reviewsCount: 380,
        imageUrl: AppAssets.croissant,
        isPopular: true,
        isFeatured: false,
        calories: 260,
        roastLevel: 'Fresh Bake',
      ),
      const ProductModel(
        id: 'p10',
        name: 'Wild Blueberry Streusel Muffin',
        category: 'Snacks',
        description: 'Plump organic blueberries folded into tender sponge batter with a crisp cinnamon streusel crumble.',
        basePrice: 160.0,
        rating: 4.7,
        reviewsCount: 142,
        imageUrl: AppAssets.blueberryMuffin,
        isPopular: false,
        isFeatured: false,
        calories: 320,
        roastLevel: 'Fresh Bake',
      ),
      const ProductModel(
        id: 'p11',
        name: 'Fudge Walnut Brownie',
        category: 'Snacks',
        description: 'Dense Belgian dark chocolate fudge brownie studded with toasted California walnuts.',
        basePrice: 180.0,
        rating: 4.9,
        reviewsCount: 290,
        imageUrl: AppAssets.chocolateBrownie,
        isPopular: true,
        isFeatured: false,
        calories: 350,
        roastLevel: 'Fresh Bake',
      ),
      const ProductModel(
        id: 'p12',
        name: 'Sourdough Avocado Toast',
        category: 'Snacks',
        description: 'Toasted artisan sourdough, smashed Hass avocado, chili flakes, sea salt, and a splash of extra virgin olive oil.',
        basePrice: 220.0,
        rating: 4.8,
        reviewsCount: 178,
        imageUrl: AppAssets.avocadoToast,
        isPopular: false,
        isFeatured: true,
        calories: 240,
        roastLevel: 'Kitchen Fresh',
      ),
    ];

    _coupons = [
      const CouponModel(
        code: 'BREW20',
        description: '20% off on all specialty coffee orders',
        discountPercent: 20.0,
        minOrderAmount: 200.0,
        maxDiscountAmount: 120.0,
      ),
      const CouponModel(
        code: 'FIRSTBREW',
        description: 'Flat ₹50 off on your first order',
        flatDiscount: 50.0,
        minOrderAmount: 150.0,
      ),
      const CouponModel(
        code: 'FESTIVE100',
        description: 'Flat ₹100 off on party orders above ₹500',
        flatDiscount: 100.0,
        minOrderAmount: 500.0,
      ),
    ];

    _stores = [
      const StoreLocationModel(
        id: 's1',
        name: 'Caffè Royale Flagship Roastery',
        address: '100ft Road, 12th Main, Indiranagar, Bangalore',
        latitude: 12.9716,
        longitude: 77.5946,
        phone: '+91 98765 43210',
        workingHours: '07:00 AM - 11:30 PM',
        distanceKm: 0.8,
        rating: 4.9,
      ),
      const StoreLocationModel(
        id: 's2',
        name: 'Caffè Royale Coffee Lounge',
        address: '5th Block, Koramangala, Bangalore',
        latitude: 12.9352,
        longitude: 77.6245,
        phone: '+91 98765 43211',
        workingHours: '08:00 AM - 11:00 PM',
        distanceKm: 2.4,
        rating: 4.8,
      ),
      const StoreLocationModel(
        id: 's3',
        name: 'Caffè Royale Artisanal Cafe',
        address: 'Church Street, Off MG Road, Bangalore',
        latitude: 12.9754,
        longitude: 77.6047,
        phone: '+91 98765 43212',
        workingHours: '07:30 AM - 12:00 AM',
        distanceKm: 3.1,
        rating: 4.9,
      ),
    ];

    _orders = [
      OrderModel(
        id: 'ord_1',
        orderNumber: 'BH-8842',
        userId: 'u_demo',
        customerName: 'Aarav Sharma',
        customerPhone: '+91 98765 00112',
        items: [
          CartItemModel(
            id: 'c1',
            product: _products[0],
            selectedSize: 'Medium',
            selectedSugar: 'Less Sugar',
            selectedMilk: 'Oat Milk (+₹30)',
            selectedExtras: const ['Extra Shot'],
            quantity: 1,
          ),
          CartItemModel(
            id: 'c2',
            product: _products[8],
            selectedSize: 'Regular',
            selectedSugar: 'None',
            selectedMilk: 'None',
            selectedExtras: const [],
            quantity: 2,
          ),
        ],
        deliveryType: 'Doorstep Delivery',
        deliveryAddress: 'Flat 402, Oakwood Manor, 12th Cross, Indiranagar',
        paymentMethod: 'UPI (Google Pay)',
        subtotal: 640.0,
        tax: 32.0,
        deliveryCharge: 30.0,
        discount: 50.0,
        grandTotal: 652.0,
        status: OrderStatus.preparing,
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
        estimatedMinutes: 15,
        timeline: [
          OrderTimelineEvent(
            title: 'Order Placed',
            description: 'Order successfully received and verified',
            timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Accepted by Kitchen',
            description: 'Barista team has confirmed your recipe',
            timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Crafting Your Brew',
            description: 'Grinding fresh beans & steaming milk',
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
            isCompleted: true,
          ),
          OrderTimelineEvent(
            title: 'Ready for Pickup / Dispatch',
            description: 'Package sealed with safety stickers',
            timestamp: DateTime.now().add(const Duration(minutes: 5)),
            isCompleted: false,
          ),
          OrderTimelineEvent(
            title: 'Out for Delivery',
            description: 'Rider is on the way to Oakwood Manor',
            timestamp: DateTime.now().add(const Duration(minutes: 10)),
            isCompleted: false,
          ),
          OrderTimelineEvent(
            title: 'Delivered',
            description: 'Enjoy your Caffè Royale handcrafted coffee!',
            timestamp: DateTime.now().add(const Duration(minutes: 18)),
            isCompleted: false,
          ),
        ],
      ),
    ];

    _bookings = [
      BookingModel(
        id: 'bk_1',
        userId: 'u_demo',
        customerName: 'Aarav Sharma',
        customerPhone: '+91 98765 00112',
        date: DateTime.now().add(const Duration(days: 1)),
        timeSlot: '05:00 PM - 06:30 PM',
        guestCount: 2,
        seatingArea: 'Window Bar',
        status: BookingStatus.confirmed,
        notes: 'Anniversary coffee date, quiet corner preferred',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];

    _reviews = {
      'p1': [
        ReviewModel(
          id: 'r1',
          productId: 'p1',
          userName: 'Priya Mehta',
          userAvatar: AppAssets.defaultAvatar,
          rating: 5.0,
          comment: 'The caramel drizzle with the oat milk is absolute perfection! My daily morning fix.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        ReviewModel(
          id: 'r2',
          productId: 'p1',
          userName: 'Rohan Sen',
          userAvatar: AppAssets.adminAvatar,
          rating: 4.8,
          comment: 'Rich crema, intense aroma. The baristas definitely know their craft.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ]
    };

    _emitAll();
  }

  void _emitAll() {
    _productsStreamController.add(List.unmodifiable(_products));
    _ordersStreamController.add(List.unmodifiable(_orders));
    _bookingsStreamController.add(List.unmodifiable(_bookings));
  }

  // --- Products Operations ---
  Future<void> addProduct(ProductModel product) async {
    _products.insert(0, product);
    _productsStreamController.add(List.unmodifiable(_products));
  }

  Future<void> updateProduct(ProductModel product) async {
    final idx = _products.indexWhere((p) => p.id == product.id);
    if (idx != -1) {
      _products[idx] = product;
      _productsStreamController.add(List.unmodifiable(_products));
    }
  }

  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
    _productsStreamController.add(List.unmodifiable(_products));
  }

  // --- Orders Operations ---
  Future<OrderModel> placeOrder({
    required String userId,
    required String customerName,
    required String customerPhone,
    required List<CartItemModel> items,
    required String deliveryType,
    required String deliveryAddress,
    required String paymentMethod,
    required double subtotal,
    required double tax,
    required double deliveryCharge,
    required double discount,
    required double grandTotal,
  }) async {
    final newOrder = OrderModel(
      id: _uuid.v4(),
      orderNumber: 'BH-${1000 + _orders.length + 1}',
      userId: userId,
      customerName: customerName,
      customerPhone: customerPhone,
      items: items,
      deliveryType: deliveryType,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      subtotal: subtotal,
      tax: tax,
      deliveryCharge: deliveryCharge,
      discount: discount,
      grandTotal: grandTotal,
      status: OrderStatus.placed,
      createdAt: DateTime.now(),
      estimatedMinutes: 25,
      timeline: [
        OrderTimelineEvent(
          title: 'Order Placed',
          description: 'Received at Caffè Royale roastery',
          timestamp: DateTime.now(),
          isCompleted: true,
        ),
        OrderTimelineEvent(
          title: 'Accepted',
          description: 'Assigned to head barista',
          timestamp: DateTime.now().add(const Duration(minutes: 2)),
          isCompleted: false,
        ),
        OrderTimelineEvent(
          title: 'Preparing',
          description: 'Extracting espresso shots & baking',
          timestamp: DateTime.now().add(const Duration(minutes: 8)),
          isCompleted: false,
        ),
        OrderTimelineEvent(
          title: 'Ready',
          description: 'Quality tested & sealed',
          timestamp: DateTime.now().add(const Duration(minutes: 15)),
          isCompleted: false,
        ),
        OrderTimelineEvent(
          title: 'Out for Delivery',
          description: 'Handed over to delivery rider',
          timestamp: DateTime.now().add(const Duration(minutes: 20)),
          isCompleted: false,
        ),
        OrderTimelineEvent(
          title: 'Delivered',
          description: 'Delivered to your hands',
          timestamp: DateTime.now().add(const Duration(minutes: 25)),
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, newOrder);
    _ordersStreamController.add(List.unmodifiable(_orders));
    try {
      final fs = _firestore;
      if (fs != null) {
        await fs.collection('orders').doc(newOrder.id).set(newOrder.toMap());
      }
    } catch (e) {
      debugPrint('Firestore order persist notice: $e');
    }
    return newOrder;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      final order = _orders[idx];
      final currentTimeline = List<OrderTimelineEvent>.from(order.timeline);
      final currentStep = newStatus.stepIndex;

      for (int i = 0; i < currentTimeline.length; i++) {
        if (i <= currentStep) {
          currentTimeline[i] = OrderTimelineEvent(
            title: currentTimeline[i].title,
            description: currentTimeline[i].description,
            timestamp: currentTimeline[i].timestamp,
            isCompleted: true,
          );
        }
      }

      _orders[idx] = order.copyWith(
        status: newStatus,
        timeline: currentTimeline,
      );
      _ordersStreamController.add(List.unmodifiable(_orders));
      try {
        final fs = _firestore;
        if (fs != null) {
          await fs.collection('orders').doc(orderId).update({
            'status': newStatus.name,
            'timeline': currentTimeline.map((e) => e.toMap()).toList(),
          });
        }
      } catch (e) {
        debugPrint('Firestore order update notice: $e');
      }
    }
  }

  // --- Bookings Operations ---
  Future<BookingModel> createBooking({
    required String userId,
    required String customerName,
    required String customerPhone,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    required String seatingArea,
    String notes = '',
  }) async {
    final booking = BookingModel(
      id: _uuid.v4(),
      userId: userId,
      customerName: customerName,
      customerPhone: customerPhone,
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
      seatingArea: seatingArea,
      status: BookingStatus.confirmed,
      notes: notes,
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, booking);
    _bookingsStreamController.add(List.unmodifiable(_bookings));
    try {
      final fs = _firestore;
      if (fs != null) {
        await fs.collection('bookings').doc(booking.id).set(booking.toMap());
      }
    } catch (e) {
      debugPrint('Firestore booking persist notice: $e');
    }
    return booking;
  }

  Future<void> updateBookingStatus(String bookingId, BookingStatus newStatus) async {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx != -1) {
      _bookings[idx] = _bookings[idx].copyWith(status: newStatus);
      _bookingsStreamController.add(List.unmodifiable(_bookings));
      try {
        final fs = _firestore;
        if (fs != null) {
          await fs.collection('bookings').doc(bookingId).update({
            'status': newStatus.name,
          });
        }
      } catch (e) {
        debugPrint('Firestore booking update notice: $e');
      }
    }
  }

  // --- Reviews ---
  List<ReviewModel> getReviewsForProduct(String productId) {
    return _reviews[productId] ?? [];
  }

  Future<void> addReview(ReviewModel review) async {
    final list = _reviews[review.productId] ?? [];
    list.insert(0, review);
    _reviews[review.productId] = list;
  }
}
