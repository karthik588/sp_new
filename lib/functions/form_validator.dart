import 'package:flutter/services.dart';
import 'package:swinpay/global/app_string.dart';

class FormValidator {
  FormValidator._privateConstructor();

  static final FormValidator _instance = FormValidator._privateConstructor();

  factory FormValidator() {
    return _instance;
  }

  static dynamic inputLenLimit({required int len}) =>
      LengthLimitingTextInputFormatter(len);

  static dynamic inputIntNumOnly = FilteringTextInputFormatter.digitsOnly;

  static dynamic inputTextNumberOnly =
      FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'));

  static dynamic inputDecimalWithPlaces({int decimalCount = 2}) =>
      FilteringTextInputFormatter.allow(
          RegExp(r'^\d+\.?\d{0,' + decimalCount.toString() + '}'));

  String? isEmpty({required String? text, String? errorMsg, int minLen = 1}) {
    if (text == null || text.isEmpty || text.length < minLen) {
      return errorMsg ?? '* Required';
    } else {
      return null;
    }
  }

  String? validateMobileNumber({required String? val}) {
    if (val != '') {
      if (val!.length < 10 || val.length > 10) {
        return AppString().mobNumberValidator;
      } else {
        return null;
      }
    } else {
      return AppString().mobNumberValidator;
    }
  }
}
