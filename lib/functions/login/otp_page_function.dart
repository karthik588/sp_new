import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swinpay/functions/login/mpin_page_function.dart';
import 'package:swinpay/localDb/local_db.dart';
import 'package:swinpay/view/screens/dashboard/dashboard_page.dart';
import 'package:swinpay/view/screens/login/login_page.dart';
import 'package:swinpay/view/screens/login/mpin_page.dart';
import '../../api_modules/api_services.dart';
import '../../global/app_util.dart';
import '../../models/backend/loginResponseModel.dart';
import '../../view/screens/dashboard/dashboard_page2.dart';
import '../../view/widgets/loadingPrompt.dart';
import '../../view/widgets/toastMessage.dart';
import '../sslEncryptionFunction.dart';
import 'login_function.dart';

class OtpPageFunction {
  OtpPageFunction._privateConstructor();

  static final OtpPageFunction _instance =
      OtpPageFunction._privateConstructor();

  factory OtpPageFunction() {
    return _instance;
  }

  var latitude = "";
  var longitude = "";
  Rx<LoginResponseModel> loginData = LoginResponseModel().obs;
  final TextEditingController otpController = TextEditingController();

  bool callGenerateApi() {
    if (LoginFunction().merchantDetails.value.data!.diffDevice == true &&
        LoginFunction().merchantDetails.value.data!.terminalRegistered ==
            true) {
      return true;
    } else if (LoginFunction().merchantDetails.value.data!.diffDevice ==
            false &&
        LoginFunction().merchantDetails.value.data!.terminalRegistered ==
            false) {
      return true;
    } else if (LoginFunction().merchantDetails.value.data!.isDeviceExist ==
            false &&
        LoginFunction().user.value.userType.toString() == '4') {
      return true;
    } else {
      return false;
    }
  }

  Future<void> generateOtp(
      {required String mobile, bool isResend = false}) async {
    try {
      LoadingPrompt().show();
      final response = await ApiServices().generateOtp(mobile: mobile);
      Navigator.pop(Get.context!);
      if (response != null) {
        if (response.status == 0) {
          isResend
              ? ToastMessage().showToast(
                  showImage: true,
                  content: response.data!.desc ?? 'OTP generated successfully',
                )
              : ToastMessage().showToast(
                  content: response.data!.desc ?? 'OTP generated successfully',
                );
        } else {
          Navigator.pop(Get.context!);
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> verifyOtp({required String mobile, required String otp}) async {
    var otpEnc = await AESEncryptor.encrypt(otp) ?? '';
    var mpinEnc = await AESEncryptor.encrypt('2255') ?? '';
    AppUtil.printData('i am otp $otp  : $otpEnc');
    try {
      LoadingPrompt().show();
      final response =
          await ApiServices().verifyOtp(mobile: mobile, otp: otpEnc);
      if (response != null) {
        if (response.status == 0) {
          if (LoginFunction().user.value.userType.toString() == '4') {
            //merchant flow
            await merchantReRegistration(
                data: response.data!.data!, mobile: mobile);
          } else {
            if (LoginFunction()
                        .merchantDetails
                        .value
                        .data!
                        .terminalRegistered ==
                    false &&
                LoginFunction().merchantDetails.value.data!.diffDevice ==
                    false) {
              regUser(
                  mobile: mobile,
                  password: mpinEnc,
                  data: response.data!.data!);
            } else if (LoginFunction().merchantDetails.value.data!.diffDevice ==
                true) {
              updateDevice(
                  mobile: mobile,
                  password: mpinEnc,
                  data: response.data!.data!);
            }
          }
        } else {
          Navigator.pop(Get.context!);
          ToastMessage().showToast(
            content: response.errorData!.errorMessage,
          );
          otpController.clear();
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> updateDevice(
      {required String mobile,
      required String password,
      required String data}) async {
    if (longitude.isEmpty || latitude.isEmpty) {
      await getCurrentPosition();
    }
    // await FireBaseMessaging().getFirebaseToken();
    try {
      final response = await ApiServices().updateDevice(
          data: data,
          mobile: LoginFunction().user.value.merchantMobileNumber,
          deviceId: AppUtil.deviceId.isNotEmpty ? AppUtil.deviceId : '',
          devicePushToken: AppUtil.fcmToken,
          geoLatitude: latitude,
          geoLongitude: longitude,
          terminal: LoginFunction().user.value.terminalNumber,
          terminalMobile: mobile,
          mpin: '');
      if (response != null) {
        if (response.status == 0) {
          await login(mobile: mobile, password: password);
        } else {
          Navigator.pop(Get.context!);
          ToastMessage().showToast(
            content: response.errorData!.errorMessage,
          );
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> getCurrentPosition() async {
    //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    //latitude = position.latitude.toString();
    //longitude = position.longitude.toString();

    latitude = (0).toString();
    longitude = (0).toString();
  }

  Future<void> login(
      {required String mobile,
      required String password,
      bool isNormalFlow = false}) async {
    isNormalFlow ? LoadingPrompt().show() : null;
    try {
      final response =
          await ApiServices().login(userName: mobile, password: password);
      if (response != null) {
        if (response.status == 0) {
          loginData(response);
          await LocalDB().setLoginToken(key: loginData.value.data!.token!);
          AppUtil.sessionToken = loginData.value.data!.sessionToken!;
          await ApiServices().resetDio();
          updateUserConfig();
        } else {
          ToastMessage().showToast(content: response.errorData!.errorMessage!);
          Navigator.pop(Get.context!);
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> updateUserConfig() async {
    try {
      final response = await ApiServices().userConfig();
      if (response != null) {
        if (response.status == 0) {
          updatePushToken();
        }
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> updatePushToken() async {
    try {
      final response = await ApiServices()
          .updatePushToken(devicePushToken: AppUtil.fcmToken);
      if (response != null) {
        if (response.status == 0) {
          Get.offAll(const DashBoardPage());
        }
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  //new flow

  Future<void> biometric() async {
    LoadingPrompt().show();
    try {
      await GetStorage.init();
      LocalDB localDB = LocalDB();
      AppUtil.reLoginToken = localDB.getLoginToken() ?? '-';
      final response =
          await ApiServices().bioMetricApi(token: AppUtil.reLoginToken);
      if (response != null) {
        if (response.status == 0) {
          loginData(response);
          AppUtil.printData(loginData.value.data!.userProfile!.profileUrl,
              isError: true);

          await LocalDB().setLoginToken(key: loginData.value.data!.token!);
          AppUtil.sessionToken = loginData.value.data!.sessionToken!;
          AppUtil.printData(loginData.value.data!.userProfile!.profileUrl,
              isError: true);
          AppUtil.printData(AppUtil.sessionToken);

          await ApiServices().resetDio();
          updateUserConfig();
        } else if (response.errorData!.errorCode.toString() == '-121') {
          //  ToastMessage().showToast(content: response.errorData!.errorMessage!);
          Navigator.pop(Get.context!);
          Get.off(const LoginPage());
        } else {
          ToastMessage().showToast(content: response.errorData!.errorMessage!);
          Navigator.pop(Get.context!);
          Get.off(const LoginPage());
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> regUser(
      {required String mobile,
      required String password,
      required String data}) async {
    if (longitude.isEmpty || latitude.isEmpty) {
      await getCurrentPosition();
    }
    var mpin = await AESEncryptor.encrypt('2255') ?? '';
    // await FireBaseMessaging().getFirebaseToken();
    try {
      final response = await ApiServices().registerser(
          data: data,
          mobile: LoginFunction().user.value.merchantMobileNumber,
          deviceId: AppUtil.deviceId.isNotEmpty ? AppUtil.deviceId : '',
          devicePushToken: AppUtil.fcmToken,
          geoLatitude: latitude,
          geoLongitude: longitude,
          terminal: LoginFunction().user.value.terminalNumber,
          terminalMobile: mobile,
          mpin: mpin);
      if (response != null) {
        if (response.status == 0) {
          await login(mobile: mobile, password: password);
        } else {
          Navigator.pop(Get.context!);
          ToastMessage().showToast(
            content: response.errorData!.errorMessage,
          );
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> merchantReRegistration(
      {required String mobile, required String data}) async {
    try {
      final response = await ApiServices()
          .merchantReRegistration(mobile: mobile, data: data);
      Navigator.pop(Get.context!);
      if (response != null) {
        if (response.status == 0) {
          MpinPageFunction().mpin.clear();
          Get.off(const MpinPage(isLoginFlow: true));
        }
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }
}
