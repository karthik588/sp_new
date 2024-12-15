import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/dashboard_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/screens/dashboard/cash_mode_prompt.dart';

import '../../../global/app_string.dart';
import '../../../models/uiModels.dart';
import '../../widgets/buttons.dart';
import '../../widgets/shapes.dart';
import '../scanUTR/scanUtrPage.dart';
import 'check_status_prompt.dart';

class MoreSheet {
  MoreSheet._privateConstructor();

  static final MoreSheet _instance = MoreSheet._privateConstructor();

  factory MoreSheet() {
    return _instance;
  }

  void show() => Get.bottomSheet(_body(),
      backgroundColor: AppColors.card,
      shape: Shapes().cardRoundedBorder(tl: 30, tr: 30));

  Widget _body() {
    final bottomData = [

      BottomBarModel(
          icon: Icons.check_circle_outline,
          onTap: () {
            Navigator.pop(Get.context!);
            DashboardFunction().amount.clear();
            DashboardFunction().utrNo.clear();
            CheckStatusPrompt().show();
          },
          text: AppString().checkStatus),
      BottomBarModel(
          icon: Icons.document_scanner,
          onTap: () async {
            if( await CommonFunctions().requestCamaraPermission()){
              Navigator.pop(Get.context!);
              Get.to(const ScanUtrPage());
            };

    },
          text: AppString().scanUtr),
    ];

    return SizedBox(
      height: 350,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            height: 4,
            width: 100,
            decoration: Shapes().containerRoundRectBorder(
                allRadius: 3, boxColor: AppColors.onBg),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(bottomData.length,
                (index) => Buttons().bottomBtn(data: bottomData[index])),
          ),
          const Spacer(),
          Buttons().raisedButton(
              padding: const EdgeInsets.all(16),
              btnColor: AppColors.bg,
              textColor: AppColors.onBg,
              isCircleShape: true,
              icon: Icons.close,
              iconSize: 26,
              onTap: () => Navigator.pop(Get.context!)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
