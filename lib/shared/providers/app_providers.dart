import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brew_haven/core/storage/local_storage_service.dart';
import 'package:brew_haven/services/firebase/firebase_auth_service.dart';
import 'package:brew_haven/services/firebase/firebase_data_repository.dart';
import 'package:brew_haven/services/recommendation/ai_recommendation_service.dart';
import 'package:brew_haven/shared/models/user_model.dart';
import 'package:brew_haven/shared/models/product_model.dart';
import 'package:brew_haven/shared/models/order_model.dart';
import 'package:brew_haven/shared/models/booking_model.dart';
import 'package:brew_haven/shared/models/coupon_model.dart';
import 'package:brew_haven/shared/models/cart_item_model.dart';
import 'package:brew_haven/shared/models/store_location_model.dart';

// Repositories
final authServiceProvider = Provider<FirebaseAuthService>((ref) => FirebaseAuthService());
final dataRepositoryProvider = Provider<FirebaseDataRepository>((ref) => FirebaseDataRepository());

// Auth State Provider
final authStateProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateStream;
});

class CurrentUserNotifier extends StateNotifier<UserModel?> {
  final FirebaseAuthService _auth;
  StreamSubscription<UserModel?>? _sub;

  CurrentUserNotifier(this._auth) : super(_auth.currentUser) {
    _sub = _auth.authStateStream.listen((user) {
      state = user;
    });
  }

  Future<void> updateProfileImage(String imageUrl) async {
    await _auth.updateProfileImage(imageUrl);
    state = _auth.currentUser;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, UserModel?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return CurrentUserNotifier(auth);
});

// Theme Mode Provider
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_initialMode());

  static ThemeMode _initialMode() {
    final mode = LocalStorageService.getThemeMode();
    if (mode == 'light') return ThemeMode.light;
    if (mode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  void setMode(ThemeMode mode) {
    state = mode;
    final str = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    LocalStorageService.setThemeMode(str);
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setMode(ThemeMode.light);
    } else {
      setMode(ThemeMode.dark);
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

// Locale Provider
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(Locale(LocalStorageService.getLanguage()));

  void setLocale(String languageCode) {
    state = Locale(languageCode);
    LocalStorageService.setLanguage(languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

// Products Provider (Real-time Stream)
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return repo.productsStream;
});

// Selected Category for filter
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Search Query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Sort Option
enum ProductSortOption { popular, highestRated, priceLowHigh, priceHighLow }

final sortOptionProvider = StateProvider<ProductSortOption>((ref) => ProductSortOption.popular);

// Filtered & Sorted Products
final filteredProductsProvider = Provider<List<ProductModel>>((ref) {
  final productsAsync = ref.watch(productsStreamProvider);
  final category = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final sort = ref.watch(sortOptionProvider);

  return productsAsync.when(
    data: (products) {
      var list = List<ProductModel>.from(products);

      // Category filter
      if (category != 'All') {
        list = list.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
      }

      // Search filter
      if (query.isNotEmpty) {
        list = list.where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query)).toList();
      }

      // Sort
      switch (sort) {
        case ProductSortOption.popular:
          list.sort((a, b) => (b.isPopular ? 1 : 0).compareTo(a.isPopular ? 1 : 0));
          break;
        case ProductSortOption.highestRated:
          list.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case ProductSortOption.priceLowHigh:
          list.sort((a, b) => a.basePrice.compareTo(b.basePrice));
          break;
        case ProductSortOption.priceHighLow:
          list.sort((a, b) => b.basePrice.compareTo(a.basePrice));
          break;
      }

      return list;
    },
    loading: () => ref.read(dataRepositoryProvider).currentProducts,
    error: (_, __) => [],
  );
});

// Favorites Provider
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super(LocalStorageService.getFavorites());

  Future<void> toggleFavorite(String id) async {
    await LocalStorageService.toggleFavorite(id);
    state = LocalStorageService.getFavorites();
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  return FavoritesNotifier();
});

// Cart State & Calculations
class CartState {
  final List<CartItemModel> items;
  final CouponModel? appliedCoupon;
  final String deliveryType; // 'Doorstep Delivery' or 'Store Pickup'

  const CartState({
    this.items = const [],
    this.appliedCoupon,
    this.deliveryType = 'Doorstep Delivery',
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get tax => subtotal * 0.05; // 5% GST
  double get deliveryCharge => (deliveryType == 'Store Pickup' || subtotal == 0) ? 0.0 : (subtotal > 400 ? 0.0 : 35.0);
  double get discount => appliedCoupon != null ? appliedCoupon!.calculateDiscount(subtotal) : 0.0;
  double get grandTotal => (subtotal + tax + deliveryCharge - discount).clamp(0.0, 999999.0);
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItemModel>? items,
    CouponModel? appliedCoupon,
    bool clearCoupon = false,
    String? deliveryType,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedCoupon: clearCoupon ? null : (appliedCoupon ?? this.appliedCoupon),
      deliveryType: deliveryType ?? this.deliveryType,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState()) {
    _loadFromCache();
  }

  void _loadFromCache() {
    final cached = LocalStorageService.getCachedCart();
    if (cached.isNotEmpty) {
      final items = cached.map((e) => CartItemModel.fromMap(e)).toList();
      state = state.copyWith(items: items);
    }
  }

  void _saveToCache() {
    LocalStorageService.saveCachedCart(state.items.map((e) => e.toMap()).toList());
  }

  void addItem({
    required ProductModel product,
    required String selectedSize,
    required String selectedSugar,
    required String selectedMilk,
    required List<String> selectedExtras,
    int quantity = 1,
  }) {
    final existingIndex = state.items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == selectedSize &&
        item.selectedSugar == selectedSugar &&
        item.selectedMilk == selectedMilk &&
        item.selectedExtras.join(',') == selectedExtras.join(','));

    if (existingIndex != -1) {
      final updated = List<CartItemModel>.from(state.items);
      final current = updated[existingIndex];
      updated[existingIndex] = current.copyWith(quantity: current.quantity + quantity);
      state = state.copyWith(items: updated);
    } else {
      final newItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        selectedSize: selectedSize,
        selectedSugar: selectedSugar,
        selectedMilk: selectedMilk,
        selectedExtras: selectedExtras,
        quantity: quantity,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
    _saveToCache();
  }

  void updateQuantity(String cartItemId, int newQty) {
    if (newQty <= 0) {
      removeItem(cartItemId);
      return;
    }
    final updated = state.items.map((item) {
      if (item.id == cartItemId) {
        return item.copyWith(quantity: newQty);
      }
      return item;
    }).toList();
    state = state.copyWith(items: updated);
    _saveToCache();
  }

  void removeItem(String cartItemId) {
    final updated = state.items.where((i) => i.id != cartItemId).toList();
    state = state.copyWith(items: updated);
    _saveToCache();
  }

  void applyCoupon(CouponModel coupon) {
    state = state.copyWith(appliedCoupon: coupon);
  }

  void removeCoupon() {
    state = state.copyWith(clearCoupon: true);
  }

  void setDeliveryType(String type) {
    state = state.copyWith(deliveryType: type);
  }

  void clearCart() {
    state = const CartState();
    LocalStorageService.saveCachedCart([]);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Orders Provider (Real-time Stream)
final ordersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return repo.ordersStream;
});

// Bookings Provider (Real-time Stream)
final bookingsStreamProvider = StreamProvider<List<BookingModel>>((ref) {
  final repo = ref.watch(dataRepositoryProvider);
  return repo.bookingsStream;
});

// AI Recommendation Provider
final aiRecommendationsProvider = Provider<List<ProductModel>>((ref) {
  final products = ref.watch(productsStreamProvider).value ?? ref.read(dataRepositoryProvider).currentProducts;
  final orders = ref.watch(ordersStreamProvider).value ?? ref.read(dataRepositoryProvider).currentOrders;
  final favs = ref.watch(favoritesProvider);

  return AiRecommendationService.getRecommendations(
    allProducts: products,
    userOrders: orders,
    favoriteProductIds: favs,
  );
});

// Available Coupons
final couponsProvider = Provider<List<CouponModel>>((ref) {
  return ref.watch(dataRepositoryProvider).currentCoupons;
});

// Coffee Stores
final storesProvider = Provider<List<StoreLocationModel>>((ref) {
  return ref.watch(dataRepositoryProvider).currentStores;
});

// Admin Analytics Provider
class AdminAnalytics {
  final double totalRevenue;
  final int totalOrders;
  final int activeOrders;
  final int activeBookings;
  final String topProduct;
  final double growthRate;

  const AdminAnalytics({
    required this.totalRevenue,
    required this.totalOrders,
    required this.activeOrders,
    required this.activeBookings,
    required this.topProduct,
    required this.growthRate,
  });
}

final adminAnalyticsProvider = Provider<AdminAnalytics>((ref) {
  final orders = ref.watch(ordersStreamProvider).value ?? ref.read(dataRepositoryProvider).currentOrders;
  final bookings = ref.watch(bookingsStreamProvider).value ?? ref.read(dataRepositoryProvider).currentBookings;

  double totalRevenue = 0;
  int activeOrders = 0;
  for (final o in orders) {
    if (o.status != OrderStatus.cancelled) {
      totalRevenue += o.grandTotal;
    }
    if (o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled) {
      activeOrders++;
    }
  }

  return AdminAnalytics(
    totalRevenue: totalRevenue,
    totalOrders: orders.length,
    activeOrders: activeOrders,
    activeBookings: bookings.where((b) => b.status == BookingStatus.confirmed).length,
    topProduct: 'Caramel Macchiato',
    growthRate: 18.4,
  );
});
