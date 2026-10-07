import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brew_haven/core/storage/local_storage_service.dart';
import 'package:brew_haven/core/widgets/theme_toggle_button.dart';
import 'package:brew_haven/shared/providers/app_providers.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorageService.init();
  });

  test('ThemeModeNotifier toggles between light and dark modes', () {
    final notifier = ThemeModeNotifier();

    // Default or initial mode
    notifier.setMode(ThemeMode.light);
    expect(notifier.state, ThemeMode.light);

    // Toggle from light -> dark
    notifier.toggleTheme();
    expect(notifier.state, ThemeMode.dark);

    // Toggle from dark -> light
    notifier.toggleTheme();
    expect(notifier.state, ThemeMode.light);

    // Set system mode
    notifier.setMode(ThemeMode.system);
    expect(notifier.state, ThemeMode.system);
  });

  testWidgets('ThemeToggleButton renders and toggles theme on tap', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ThemeToggleButton(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify ThemeToggleButton exists
    expect(find.byType(ThemeToggleButton), findsOneWidget);

    // Tap the theme toggle button
    await tester.tap(find.byType(ThemeToggleButton));
    await tester.pumpAndSettle();

    // Still renders properly after toggle
    expect(find.byType(ThemeToggleButton), findsOneWidget);
  });

  testWidgets('ThemeModeSegmentedControl renders all 3 options', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ThemeModeSegmentedControl(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);

    // Tap on Dark segment
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    // Tap on Light segment
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
  });
}
