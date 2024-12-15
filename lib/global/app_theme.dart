import 'package:flutter/material.dart';
import 'package:swinpay/global/app_color.dart';

class AppTheme {
  AppTheme._privateConstructor();

  static final AppTheme _instance = AppTheme._privateConstructor();

  factory AppTheme() {
    return _instance;
  }

  // static ThemeData get darkTheme {

  // return
  var theme = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.card,
        titleTextStyle: TextStyle(
            color: AppColors.onBg,
            fontFamily: 'mukta',
            fontSize: 20,
            fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: AppColors.primary)),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.bg,
    cardTheme:
        CardTheme(color: AppColors.card, surfaceTintColor: Colors.transparent),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.primary),
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'mukta',
          // Apply 'mukta' font to the entire app
        ),
  );
// }
}
