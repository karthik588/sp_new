import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../widgets/shapes.dart';

class PermissionRequiredPrompt {
  PermissionRequiredPrompt._privateConstructor();

  static final PermissionRequiredPrompt _instance =
      PermissionRequiredPrompt._privateConstructor();

  factory PermissionRequiredPrompt() {
    return _instance;
  }

  void show() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: Shapes().cardRoundedBorder(allRadius: 2),
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              contentPadding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              titlePadding: const EdgeInsets.only(top: 15, left: 15),
              actionsPadding: const EdgeInsets.only(bottom: 5, right: 15),
              title: Text(AppString().permissionRequired,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              content: Text(AppString().permissionDes,
                  style: const TextStyle(
                      height: 1.2,
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              actions: [
                TextButton(
                  onPressed: () => exit(0),
                  child: Text(AppString().cancel.toUpperCase(),
                      style: const TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                  child: Text(
                    AppString().ok.toUpperCase(),
                    style: TextStyle(color: AppColors.card),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
