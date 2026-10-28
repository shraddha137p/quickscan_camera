import 'package:flutter/material.dart';
import 'package:quickscan_camera/app/core/theme/app_colors.dart';

extension $BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => theme.brightness == Brightness.dark;

  ColorScheme get colorScheme => lightColorScheme;

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get topInset => mediaQuery.viewInsets.top;

  double get bottomInset => mediaQuery.viewInsets.bottom;

  Object? get args => ModalRoute.of(this)?.settings.arguments;

  // TextDirection get textDirection => Directionality.of(this);

  void hideKeyboard() {
    final currentFocus = FocusScope.of(this);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
