import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swinpay/global/app_util.dart';

import '../view/widgets/toastMessage.dart';

class CommonFunctions {
  CommonFunctions._privateConstructor();

  static final CommonFunctions _instance =
      CommonFunctions._privateConstructor();

  factory CommonFunctions() {
    return _instance;
  }

  static void closeKeyPad() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String convertToDouble({required dynamic value}) {
    try {
      var no = num.parse('$value');

      return no.toStringAsFixed(2);
    } catch (_) {
      return '0.00';
    }
  }

  String formatTime(DateTime dateTime) {
    try {
      return DateFormat('h:mm a').format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String getRandomTxnId() {
    Random random = Random();
    double randomDouble = random.nextDouble();
    int scaledRandomNumber = (randomDouble * 9000000000000000).floor();
    String randomNumberString = scaledRandomNumber.toString();
    while (randomNumberString.length < 20) {
      randomNumberString = '0$randomNumberString';
    }
    return 'Txn$randomNumberString';
  }

  String getOrderId({required String terminalId}) {
    return "$terminalId${DateTime.now().microsecondsSinceEpoch}";
  }

  String dateFormatForBackend(dynamic dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse('${dateTimeString!}');
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
    } catch (_) {
      return '-';
    }
  }

  String dateFormatDMYHMSA(dynamic dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse('${dateTimeString!}');
      return DateFormat('dd MMM yyyy hh:mm:ss a').format(dateTime);
    } catch (_) {
      return '-';
    }
  }

  // String dateFormatTwelveHour(dynamic dateTimeString) {
  //   try {
  //     DateTime dateTime = DateTime.parse('$dateTimeString');
  //     return DateFormat('dd MMM yyyy hh:mm:ss a').format(dateTime);
  //   } catch (_) {
  //     return '-';
  //   }
  // }

  String getDeviceType() {
    try {
      if (Platform.isIOS) {
        return 'iOS';
      }
      else if (Platform.isAndroid) {
        return 'Android';
      }
      else {
          return 'Android';
        }
    } catch (_) {
      return 'Android';
    }
  }

  String formatRupeesAndPaise(String rupees) {
    try {
      List<String> parts = rupees.split('.');

      String rupeesPart = parts[0];
      String paisePart = '';

      if (parts.length > 1) {
        int paiseValue = int.parse(parts[1]);
        paisePart = paiseValue == 0 ? '' : '.$paiseValue';
      }

      String rupeesText = rupeesPart == '0' ? '' : '$rupeesPart rupees';
      String paiseText =
          paisePart.isEmpty ? '' : '${paisePart.substring(1)} paisa';
      String result = rupeesText.isEmpty
          ? paiseText
          : (paiseText.isEmpty ? rupeesText : '$rupeesText and $paiseText');
      String formattedRupeesAndPaise = result.isEmpty ? '0 rupees' : result;

      return formattedRupeesAndPaise;
    } catch (e) {
      return '';
    }
  }

  // String ddMmYyyyMHSAMPM({required dynamic dynamicDate}) {
  //   try {
  //     return DateFormat("dd MMM yyyy hh:mm:ss a")
  //         .format(DateTime.parse(dynamicDate.toString()));
  //   } catch (_) {
  //     AppUtil.printData('i am ddMmYyyyMHSAMPM $dynamicDate :  $_');
  //     return '-';
  //   }
  // }

  void restartApp() {
    const MethodChannel platform = MethodChannel('flutter/platform');
    platform.invokeMethod<void>('SystemNavigator.pop');
  }

  Future<bool> requestCamaraPermission() async {
    try {
      // Check camera permission status
      PermissionStatus status = await Permission.camera.status;
      if (status.isGranted) {
        AppUtil.printData('Camera permission already granted.');
        return true;
      } else if (status.isDenied || status.isPermanentlyDenied) {
        // Request permission
        status = await Permission.camera.request();
        if (status.isGranted) {
          AppUtil.printData('Camera permission granted after request.');
          return true;
        } else {
          ToastMessage().showToast(content: 'Camera permission denied after request.');
          AppUtil.printData('Camera permission denied after request.');
          return false;
        }
      }
      return false;
    } catch (e) {
      ToastMessage().showToast(content: 'Oops! Something went wrong. Please try scanning again');
      return false;
    }
  }
}
