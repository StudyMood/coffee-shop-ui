# ☕ Caffè Royale (Brew Haven) — Smart Coffee Shop App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-Riverpod-blueviolet?style=for-the-badge)](https://riverpod.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Supported-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue?style=for-the-badge)]()

An artisanal, modern, and feature-rich Coffee Shop mobile application built using **Flutter** and **Riverpod**. Designed with a luxurious UI/UX, seamless ordering flow, store locator, loyalty rewards, table bookings, and multi-language support.

---

## 🌟 Key Features

### ☕ 1. Discovery & Products
- **Curated Menu**: Browse handcrafted coffees, cold brews, artisanal pastries, and specialty snacks.
- **Product Details & Customization**: Select roast types, milk options, sweetness levels, and add-ons.
- **Dynamic Search & Filtering**: Instant search across coffee categories with real-time price & rating filters.

### 🛒 2. Ordering & Checkout
- **Smart Cart System**: Real-time quantity adjustments, price calculations, and promo code discounts.
- **Interactive Checkout Flow**: Support for delivery, takeaway, and dine-in pickup.
- **Order Tracking**: Real-time order progress status from brewing to ready-for-pickup.

### 🎁 3. Loyalty & Rewards
- **Points & Rewards Program**: Earn loyalty beans on every purchase and redeem exclusive rewards.
- **Referral System**: Invite friends to unlock special discounts and reward tiers.
- **QR Code Scanner**: In-store scan for loyalty redemption and quick order verification.

### 📍 4. Store Locator & Table Bookings
- **Stores Map**: Locate nearby Caffè Royale outlets with addresses, hours, and direction support.
- **Table Reservations**: Reserve tables at your favorite cafe outlet in advance.

### 🎨 5. Premium UI/UX & Architecture
- **Dual Themes**: Handcrafted Luxury Dark Mode and Warm Artisanal Light Mode.
- **Internationalization (i18n)**: Built-in multi-language support (English, Hindi, Arabic).
- **Clean Feature-Driven Architecture**: Modular folder structure powered by Riverpod state management.
- **Admin Dashboard**: Built-in admin management capabilities for menu and order overviews.

---

## 🏗️ Architecture & Project Structure

```
lib/
├── core/
│   ├── localization/         # App translations & multi-language delegates
│   ├── storage/              # Local preferences & caching service
│   └── theme/                # Artisanal Color palettes, Typography & Themes
├── features/
│   ├── admin/                # Admin controls & dashboards
│   ├── auth/                 # Authentication & onboarding login
│   ├── bookings/             # Table reservations & slot booking
│   ├── cart/                 # Cart state management & calculations
│   ├── checkout/             # Payment processing & order finalization
│   ├── home/                 # Banner carousel, categories & trending drinks
│   ├── loyalty/              # Rewards, streak points & membership tiers
│   ├── onboarding/           # Welcome slides & intro
│   ├── orders/               # Active orders, history & live status
│   ├── products/             # Catalog views & product customization
│   ├── profile/              # User settings, addresses & preferences
│   ├── referral/             # Invite friends & coupon code generation
│   ├── scanner/              # In-store QR code scanner
│   ├── search/               # Search index & filter chips
│   ├── splash/               # Animated startup splash screen
│   └── stores_map/           # Interactive store locator & outlet details
├── services/                 # Firebase & backend services
├── shared/                   # Global providers, reusable widgets & models
├── firebase_options.dart     # Firebase configuration
└── main.dart                 # Application entry point & Riverpod Scope
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.0` or higher)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code with Flutter extension
- An Android device / iOS simulator or Chrome browser

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/StudyMood/coffee-shop-ui.git
   cd coffee-shop-ui
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🛠️ Tech Stack & Libraries

- **Framework**: [Flutter](https://flutter.dev)
- **Language**: [Dart](https://dart.dev)
- **State Management**: [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- **Backend / Auth**: [Firebase](https://firebase.google.com)
- **Icons & Graphics**: Cupertino Icons & Material Design 3
- **Local Storage**: Shared Preferences / Local Storage Cache

---

## 👨‍💻 Author

**Abhishek Kumar**
- GitHub: [@StudyMood](https://github.com/StudyMood)

---

## 📄 License
This project is licensed under the MIT License - feel free to use and customize for your own projects!
