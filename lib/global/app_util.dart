import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppUtil {
  AppUtil._privateConstructor();

  static final AppUtil _instance = AppUtil._privateConstructor();

  factory AppUtil() {
    return _instance;
  }

  static String currency = '₹';

  static String countryCode = '91';

  static String deviceId = '';
  static String authToken = "FREFA45D\$B2#18842765#992";
  static String sessionToken = '';
  static String fcmToken = '';
  static String htmlData = '';
  static String terminalId = '';
  static String merchantName = '';
  static String merchantId = '';
  static String reLoginToken = '';
  static bool showMpin = false;
  static AppLifecycleState? appLifecycleState;
  static String appVersion = '1.1.2';
  static bool isMerchantUser = false;

  static void printData(dynamic data, {bool isError = false}) {
    if (kDebugMode) {
      debugPrint('SwinkPay : ${isError ? '\x1B[31m$data\x1B[0m' : '$data'} ');
    }
  }
}
