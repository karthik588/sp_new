import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/app_icons.dart';

class ToastMessage {
  ToastMessage._privateConstructor();

  static final ToastMessage _instance = ToastMessage._privateConstructor();

  factory ToastMessage() {
    return _instance;
  }

  void showToast({
    String? title = '',
    required String content,
    bool showImage=false
  }) {
    showImage?
    Get.showSnackbar(GetSnackBar(
      icon:showImage? Padding(
        padding: const EdgeInsets.only(left:10),
        child: Container(
          height: 30,
            width: 30,
            color: Colors.white,
            child: Image.asset(AppIcons.splashImage,filterQuality: FilterQuality.high,))
      ):Container(),
      message: content,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      duration: const Duration(seconds: 2),
    )): Get.showSnackbar(GetSnackBar(
      message: content,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      duration: const Duration(seconds: 2),
    ));
  }
}
