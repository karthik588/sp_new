import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';

class LoadingPrompt {
  LoadingPrompt._privateConstructor();

  static final LoadingPrompt _instance = LoadingPrompt._privateConstructor();

  factory LoadingPrompt() {
    return _instance;
  }

  void show() {
    Get.dialog(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                    color: AppColors.onBg.withOpacity(0.5))),
            const SizedBox(width: 10),
            DefaultTextStyle(
                style: TextStyle(
                    color: AppColors.onBg.withOpacity(0.5),
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
                child: Text(AppString().loading))
          ],
        ),
        barrierDismissible: false
        //barrierColor: Colors.black45
        );
  }

  Widget customProgressBar({required bool isLoading}) {
    return isLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.onBg.withOpacity(0.6),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                AppString().loading,
                style: TextStyle(
                    color: AppColors.onBg.withOpacity(0.6), fontSize: 15),
              )
            ],
          )
        : Container();
  }
}
