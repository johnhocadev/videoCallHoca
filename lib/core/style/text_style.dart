import 'package:flutter/material.dart';

@immutable
class AppTextStyle extends TextTheme {
  const AppTextStyle();

  @override
  TextStyle? get displayMedium => const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: FontSize.size16,
      );

  @override
  @override
  TextStyle? get displaySmall => const TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w700,
        fontSize: FontSize.size12,
      );
}

@immutable
class FontSize {
  const FontSize._();

  static const double size48 = 48;
  static const double size12 = 12;
  static const double size16 = 16;
}
