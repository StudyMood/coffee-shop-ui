import 'package:flutter_test/flutter_test.dart';
import 'package:brew_haven/core/constants/app_colors.dart';
import 'package:brew_haven/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  test('AppLocalizations translation verification', () {
    final enLoc = AppLocalizations(const Locale('en'));
    expect(enLoc.translate('app_name'), 'Caffè Royale');

    final hiLoc = AppLocalizations(const Locale('hi'));
    expect(hiLoc.translate('app_name'), 'कैफ़े रॉयल');

    final arLoc = AppLocalizations(const Locale('ar'));
    expect(arLoc.translate('app_name'), 'كافيه رويال');
  });

  test('AppColors palette integrity', () {
    expect(AppColors.primaryCoffee, const Color(0xFFC67C4E));
    expect(AppColors.primaryEspresso, const Color(0xFF2C1810));
  });
}
