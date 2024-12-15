import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MpinPageFunction {
  MpinPageFunction._privateConstructor();

  static final MpinPageFunction _instance =
      MpinPageFunction._privateConstructor();

  factory MpinPageFunction() {
    return _instance;
  }

  final loginFormKey = GlobalKey<FormState>();

  RxBool isCircleFilled = false.obs;

  TextEditingController mpin = TextEditingController();
  TextEditingController confirmMpin = TextEditingController();

  void clearFields() {
    //isCircleFilled(false);
    mpin.clear();
    confirmMpin.clear();
  }
}
