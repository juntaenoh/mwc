// colors.dart 파일
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = const Color(0xFFCCFF8B);
  static const Color Black = const Color(0xFF1a1c21);
  static const Color secondary = const Color(0xFFB4BFD9);
  static const Color DarkenGreen = Color(0xFFc3f483);
  static const Color AlertGreen = Color(0xff00DE16);
  static const Color BlueGray = Color(0xFFB4BFD9);
  static const Color Gray850 = Color(0xFF2F3135);
  static const Color Gray700 = Color(0xFF4B4D51);
  static const Color Gray500 = Color(0xFF7C7F84);
  static const Color Gray300 = Color(0xFFAEB2B8);
  static const Color Gray200 = Color(0xFFD7DADE);
  static const Color Gray100 = Color(0xFFECEEF1);
  static const Color primaryBackground = const Color(0xFFFCFDFF);
  static const Color red = const Color(0xFFE95958);
}

class AppFont {
  static const TextStyle b24 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle r16 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle s12 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color(0xff4B4D51),
  );
  static const TextStyle s18 = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle s12w = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color(0xffAEB2B8),
  );
  static const TextStyle b24w = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xffFCFDFF),
  );
}

extension TextStyleHelper on TextStyle {
  TextStyle overrides({Color? color, double? fontSize, dynamic decoration}) => copyWith(color: color, fontSize: fontSize, decoration: decoration);
}
