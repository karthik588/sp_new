import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:swinpay/global/app_util.dart';

import '../functions/login/login_function.dart';
import '../models/backend/userDetailModel.dart';

class LocalDB {
  final box = GetStorage();

  String userDetailsKey = 'UserDetailsKey';
  String secretKey = 'SecretKey';
  String loginToken = 'loginToken';

  Future<void> setUserData({
    required UserDetail userDetail,
  }) async {
    await box.write(userDetailsKey, json.encode(userDetail.toJson()));
    getUserData();
  }

  UserDetail? getUserData() {
    var dataString = '';
    dataString = box.read(userDetailsKey) ?? '';
    if (dataString != '') {
      var dataJson = jsonDecode(dataString);
      var userLocalData = UserDetail.fromJson(dataJson);
      AppUtil.showMpin = userLocalData.defaultMpin!;
      LoginFunction().user(userLocalData);
      print('111111111111111111');
      print(userLocalData.userMobile);
      print(LoginFunction().user.value.userMobile);
      return userLocalData;
    } else {
      return UserDetail();
    }
  }

  Future<void> setSecretKey({required String key}) async {
    await box.write(secretKey, key);
    getSecretKey();
  }

  String? getSecretKey() {
    var dataString = '';
    dataString = box.read(secretKey) ?? '';
    if (dataString != '') {
      return dataString;
    } else {
      return null;
    }
  }

  Future<void> setLoginToken({required String key}) async {
    await box.write(loginToken, key);
    getLoginToken();
  }

  String? getLoginToken() {
    var dataString = '';
    dataString = box.read(loginToken) ?? '';
    if (dataString != '') {
      return dataString;
    } else {
      return null;
    }
  }

  void removeAllData() {
    box.erase();
  }
}
