import 'package:flutter/material.dart';

class AppColors {
  AppColors._privateConstructor();

  static final AppColors _instance = AppColors._privateConstructor();

  factory AppColors() {
    return _instance;
  }

  static Color bg = const Color(0xFF344955);
  static Color onBg = Colors.white;
  static Color primary = const Color(0xFFF9AA33);
  static Color onPrimary = const Color(0xFF232F34);
  static Color card = const Color(0xFF242F35);
  static Color accent = const Color(0xFF4A7685);

  static Color getStatusColor({required dynamic status}) {
    status = status.toString();
    var color = {"0": Colors.yellow, "1": Colors.green, "2": Colors.red};
    return color[status] ?? Colors.orange;
  }
}
