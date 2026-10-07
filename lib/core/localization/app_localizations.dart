import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_name': 'Caffè Royale',
      'tagline': 'Crafted with Passion, Brewed to Perfection',
      'search_coffee': 'Search your favorite brew...',
      'categories': 'Categories',
      'special_offer': 'Special Offer',
      'promo_title': 'Buy 1 Get 1 Free\non Specialty Lattes',
      'order_now': 'Order Now',
      'featured_drinks': 'Featured Beverages',
      'popular_now': 'Popular Now',
      'ai_picks': 'AI Recommended For You',
      'book_table': 'Book a Table',
      'loyalty_points': 'Loyalty Points',
      'rewards': 'Rewards',
      'cart': 'My Cart',
      'checkout': 'Checkout',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'delivery_fee': 'Delivery Fee',
      'tax': 'Taxes & Fees',
      'discount': 'Discount',
      'place_order': 'Place Order',
      'home_delivery': 'Doorstep Delivery',
      'store_pickup': 'Store Pickup',
      'select_size': 'Select Size',
      'sugar_level': 'Sugar Level',
      'milk_options': 'Milk Alternatives',
      'extra_shots': 'Customize & Add-ons',
      'track_order': 'Track Order',
      'order_status': 'Order Status',
      'admin_panel': 'Admin Dashboard',
      'scan_qr': 'Scan Table QR',
      'nearby_cafes': 'Caffè Royale Outlets',
      'profile': 'My Profile',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
    },
    'hi': {
      'app_name': 'कैफ़े रॉयल',
      'tagline': 'शुद्ध स्वाद, बेहतरीन कॉफ़ी का अनुभव',
      'search_coffee': 'अपनी पसंदीदा कॉफ़ी खोजें...',
      'categories': 'श्रेणियाँ',
      'special_offer': 'विशेष ऑफर',
      'promo_title': 'एक खरीदें एक मुफ़्त\nस्पेशलिटी लाटे पर',
      'order_now': 'अभी ऑर्डर करें',
      'featured_drinks': 'विशेष पेय',
      'popular_now': 'लोकप्रिय कॉफ़ी',
      'ai_picks': 'आपके लिए एआई सुझाव',
      'book_table': 'टेबल बुक करें',
      'loyalty_points': 'लॉयल्टी पॉइंट्स',
      'rewards': 'इनाम',
      'cart': 'मेरी कार्ट',
      'checkout': 'चेकआउट',
      'total': 'कुल राशि',
      'subtotal': 'उप-कुल',
      'delivery_fee': 'डिलीवरी शुल्क',
      'tax': 'कर और शुल्क',
      'discount': 'छूट',
      'place_order': 'ऑर्डर प्लेस करें',
      'home_delivery': 'घर पर डिलीवरी',
      'store_pickup': 'स्टोर से पिकअप',
      'select_size': 'आकार चुनें',
      'sugar_level': 'मीठे का स्तर',
      'milk_options': 'दूध के विकल्प',
      'extra_shots': 'अतिरिक्त सामग्री',
      'track_order': 'ऑर्डर ट्रैक करें',
      'order_status': 'ऑर्डर स्थिति',
      'admin_panel': 'एडमिन डैशबोर्ड',
      'scan_qr': 'टेबल क्यूआर स्कैन करें',
      'nearby_cafes': 'पास के आउटलेट',
      'profile': 'मेरी प्रोफाइल',
      'settings': 'सेटिंग्स',
      'dark_mode': 'डार्क मोड',
      'language': 'भाषा',
    },
    'ar': {
      'app_name': 'كافيه رويال',
      'tagline': 'صُنعت بشغف، وحُضّرت بإتقان',
      'search_coffee': 'ابحث عن قهوتك المفضلة...',
      'categories': 'الفئات',
      'special_offer': 'عرض خاص',
      'promo_title': 'اشترِ واحدة واحصل على\nالأخرى مجاناً على اللاتيه',
      'order_now': 'اطلب الآن',
      'featured_drinks': 'مشروبات مميزة',
      'popular_now': 'الأكثر طلباً',
      'ai_picks': 'توصيات الذكاء الاصطناعي لك',
      'book_table': 'حجز طاولة',
      'loyalty_points': 'نقاط الولاء',
      'rewards': 'المكافآت',
      'cart': 'سلة المشتريات',
      'checkout': 'إتمام الطلب',
      'total': 'الإجمالي',
      'subtotal': 'المجموع الفرعي',
      'delivery_fee': 'رسوم التوصيل',
      'tax': 'الضرائب والرسوم',
      'discount': 'الخصم',
      'place_order': 'تأكيد الطلب',
      'home_delivery': 'توصيل للمنزل',
      'store_pickup': 'استلام من المتجر',
      'select_size': 'اختر الحجم',
      'sugar_level': 'مستوى السكر',
      'milk_options': 'خيارات الحليب',
      'extra_shots': 'إضافات وتخصيص',
      'track_order': 'تتبع الطلب',
      'order_status': 'حالة الطلب',
      'admin_panel': 'لوحة الإدارة',
      'scan_qr': 'مسح رمز الطاولة',
      'nearby_cafes': 'فروعنا القريبة',
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع الداكن',
      'language': 'اللغة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
