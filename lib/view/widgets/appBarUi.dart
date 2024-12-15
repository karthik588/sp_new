import 'package:flutter/material.dart';
import 'package:swinpay/global/app_color.dart';

class AppBarUi extends StatelessWidget {
  const AppBarUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card,
    );
  }
}
