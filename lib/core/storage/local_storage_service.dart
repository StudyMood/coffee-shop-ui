import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyThemeMode = 'brew_haven_theme_mode';
  static const String _keyLanguage = 'brew_haven_language';
  static const String _keyOnboardingDone = 'brew_haven_onboarding_done';
  static const String _keyUserSession = 'brew_haven_user_session';
  static const String _keyFavorites = 'brew_haven_favorites';
  static const String _keySearchHistory = 'brew_haven_search_history';
  static const String _keyCartCache = 'brew_haven_cart_cache';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('LocalStorageService must be initialized with init() first.');
    }
    return _prefs!;
  }

  // Onboarding
  static bool isOnboardingCompleted() {
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    await prefs.setBool(_keyOnboardingDone, value);
  }

  // Theme Mode: 'light', 'dark', or 'system'
  static String getThemeMode() {
    return prefs.getString(_keyThemeMode) ?? 'system';
  }

  static Future<void> setThemeMode(String mode) async {
    await prefs.setString(_keyThemeMode, mode);
  }

  // Language: 'en', 'hi', 'ar'
  static String getLanguage() {
    return prefs.getString(_keyLanguage) ?? 'en';
  }

  static Future<void> setLanguage(String code) async {
    await prefs.setString(_keyLanguage, code);
  }

  // User Profile Session
  static Map<String, dynamic>? getUserSession() {
    final raw = prefs.getString(_keyUserSession);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveUserSession(Map<String, dynamic> userMap) async {
    await prefs.setString(_keyUserSession, jsonEncode(userMap));
  }

  static Future<void> clearUserSession() async {
    await prefs.remove(_keyUserSession);
  }

  // Favorites
  static List<String> getFavorites() {
    return prefs.getStringList(_keyFavorites) ?? [];
  }

  static Future<void> toggleFavorite(String productId) async {
    final favs = getFavorites();
    if (favs.contains(productId)) {
      favs.remove(productId);
    } else {
      favs.add(productId);
    }
    await prefs.setStringList(_keyFavorites, favs);
  }

  // Search History
  static List<String> getSearchHistory() {
    return prefs.getStringList(_keySearchHistory) ?? [
      'Caramel Macchiato',
      'Iced Latte',
      'Butter Croissant',
      'Cold Brew',
    ];
  }

  static Future<void> addSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    final list = getSearchHistory();
    list.remove(query);
    list.insert(0, query);
    if (list.length > 10) {
      list.removeLast();
    }
    await prefs.setStringList(_keySearchHistory, list);
  }

  static Future<void> clearSearchHistory() async {
    await prefs.remove(_keySearchHistory);
  }

  // Cart Cache
  static List<Map<String, dynamic>> getCachedCart() {
    final raw = prefs.getString(_keyCartCache);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveCachedCart(List<Map<String, dynamic>> items) async {
    await prefs.setString(_keyCartCache, jsonEncode(items));
  }
}
