import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:swinpay/functions/login/mpin_page_function.dart';
import 'package:swinpay/functions/login/otp_page_function.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/screens/login/mpin_page.dart';
import 'package:swinpay/view/screens/login/otp_page.dart';
import 'package:swinpay/view/widgets/loadingPrompt.dart';
import 'package:swinpay/view/widgets/toastMessage.dart';

import '../../api_modules/api_services.dart';
import '../../localDb/local_db.dart';
import '../../models/backend/secretKeyModel.dart';
import '../../models/backend/userDetailModel.dart';
import '../../models/backend/validateMerchantMobileModel.dart';
import '../../view/screens/login/PermissionRequiredPrompt.dart';
import '../../view/screens/login/login_page.dart';
import '../../view/widgets/userNotRegisteredPrompt.dart';
import '../sslEncryptionFunction.dart';

class LoginFunction {
  LoginFunction._privateConstructor();

  static final LoginFunction _instance = LoginFunction._privateConstructor();

  factory LoginFunction() {
    return _instance;
  }

  TextEditingController mobileNumber = TextEditingController();
  RxBool isLoginPageLoading = false.obs;

  Rx<UserDetail> user = UserDetail().obs;
  Rx<SecretKeyData> secretKey = SecretKeyData().obs;
  Rx<ValidateMerchantMobileModel> merchantDetails =
      ValidateMerchantMobileModel().obs;

  Future<void> getCountry() async {
    try {
      mobileNumber.clear();
      final response = await ApiServices().getCountry();
      if (response != null) {}
    } on DioException catch (_) {
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> validateCountryCode(
      {required String mobile, required bool isRegFlow}) async {
    try {
      LoadingPrompt().show();
      final response = await ApiServices().validateCountryCode();
      if (response != null && response.status == 0) {
        await _getInstitutionForMobile(mobile: mobile, isRegFlow: isRegFlow);
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      AppUtil.printData(' DioException! in validateCountryCode', isError: true);
      Navigator.pop(Get.context!);
      // ToastMessage().showToast(content: _.toString());

      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> _getInstitutionForMobile({
    required String mobile,
    required bool isRegFlow,
  }) async {
    try {
      // UAT
      final response = await ApiServices()
          .getInstitutionForMobile(institutionId: 1, mobile: mobile);

      // Production
      // final response = await ApiServices().getInstitutionForMobile(institutionId: 10, mobile: mobile);
      if (response != null && response.status == 0) {
        if (isRegFlow) {
          _validateMerchantMobileAndDevice();
        } else {
          _checkAllPermission(mobile: mobile);
        }
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> _checkAllPermission({required String mobile}) async {
    var isGranted = await _requestPermission();
    if (isGranted) {
      AppUtil.printData('I am check all permission');
      await ApiServices().resetDio();
      await _fetchUserDetails(mobile: mobile);
    } else {
      AppUtil.printData('I am denied start');
      PermissionRequiredPrompt().show();
      AppUtil.printData('I am denied end');
      Navigator.pop(Get.context!);
    }
  }

  Future<bool> _requestPermission() async {
    List<Permission> permissions = [
      // Permission.contacts,
      //Permission.camera,
      Permission.notification,
      //Permission.location,
    ];

    for (int i = 0; i < permissions.length; i++) {
      var permission = permissions[i];
      final status = await permission.request();

      if (status == PermissionStatus.granted) {
        AppUtil.printData('I am granted ${status.name}');
      } else {
        AppUtil.printData('I am denied ${status.name}');
      }
    }
    return true;
  }

  Future<void> _fetchUserDetails({required String mobile}) async {
    try {
      final response = await ApiServices().fetchUserDetails(mobile: mobile);

      if (response != null && response.status == 0) {
        user(response.data!);
        AppUtil.printData('i am merchant api', isError: true);
        UserDetail userDetailsWithMobile = response.data ?? UserDetail();
        userDetailsWithMobile.userMobile = mobile;
        await LocalDB().setUserData(userDetail: userDetailsWithMobile);
        AppUtil.printData(' i am userdata', isError: true);

        if (user.value.userType.toString() == '4') {
          // await ApiServices().resetDio();
          AppUtil.isMerchantUser = true;
          await _merchantFlow(data: response.data!);
        } else if (user.value.userType.toString() == '7') {
          AppUtil.isMerchantUser = false;
          await fetchSecretKey(isFreshLogin: true);
        }
      } else if (response != null && response.errorData!.errorCode == -105) {
        Navigator.pop(Get.context!);
        UserNotRegisteredPrompt().showInvalidUserPrompt();
      } else {
        Navigator.pop(Get.context!);
        ToastMessage().showToast(
          content: response!.errorData!.errorCode,
        );
      }
    } on DioException catch (_) {
      isLoginPageLoading(false);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> _merchantFlow({required UserDetail data}) async {
    AppUtil.printData('merchantFlow flow');
    AppUtil.printData(
      AppUtil.isMerchantUser.toString(),
    );
    _validateMerchantMobileAndDevice();
    //Get.to(const MpinPage());
  }

  Future<void> fetchSecretKey({required bool isFreshLogin}) async {
    try {
      final response = await ApiServices().getSecretKey();
      if (response != null && response.status == 0) {
        LocalDB().setSecretKey(key: response.data!.data ?? '');
        isFreshLogin ? await _validateMerchantTerminal() : null;
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> _validateMerchantTerminal() async {
    try {
      merchantDetails(ValidateMerchantMobileModel());
      final response = await ApiServices()
          .validateMerchantTerminalMobile(mobile: mobileNumber.text);
      if (response != null && response.status == 0) {
        merchantDetails(response);
        _validateUserDetail(
            mobile: mobileNumber.text, status: response.status!);
      } else {
        Navigator.pop(Get.context!);
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> _validateUserDetail(
      {required int status, required String mobile}) async {
    Navigator.pop(Get.context!);
    var otpEnc = await AESEncryptor.encrypt('2255') ?? '';

    if (status == 0 &&
        LoginFunction().merchantDetails.value.data!.diffDevice == false &&
        LoginFunction().merchantDetails.value.data!.terminalRegistered ==
            true) {
      OtpPageFunction()
          .login(mobile: mobile, password: otpEnc, isNormalFlow: true);
    } else if (status == 0) {
      Get.to(OtpPage(mobile: mobile));
    }
  }

  Future<void> checkSession() async {
    await GetStorage.init();
    LocalDB localDB = LocalDB();
    var loginToken = localDB.getLoginToken();
    String? userType = localDB.getUserData()?.userType.toString() ?? '';

    if (userType.toString() == '4') {
      AppUtil.isMerchantUser = true;
      await ApiServices().resetDio();
      LoginFunction().fetchSecretKey(isFreshLogin: false);
      Get.offAll(const MpinPage(
        isLoginFlow: true,
        isChangeMpin: false,
      ));

    } else {
      if (loginToken != null) {
        await alreadyLoginFlow();
        AppUtil.printData('user data already exits new flow', isError: true);
      } else {
        Get.off(const LoginPage());
        AppUtil.printData('user not logged in old flow', isError: true);
        // return false;
      }
    }
  }

  Future<void> alreadyLoginFlow() async {
    var userData = LocalDB().getUserData();
    LoadingPrompt().show();
    await ApiServices().resetDio();
    await fetchSecretKey(isFreshLogin: false).then((value) async {
      if (userData?.defaultMpin == false) {
        OtpPageFunction().biometric();
      }
    });
    Get.back(closeOverlays: false);
  }

  //merchant
  Future<void> _validateMerchantMobileAndDevice() async {
    try {
      merchantDetails(ValidateMerchantMobileModel());
      final response = await ApiServices()
          .validateMerchantMobileAndDevice(mobile: mobileNumber.text);
      Navigator.pop(Get.context!);
      if (response != null && response.status == 0) {
        merchantDetails(response);
        if (merchantDetails.value.data!.isMobileExist == true &&
            merchantDetails.value.data!.isDeviceExist == false) {
          AppUtil.printData('user data 22222 exits new flow', isError: true);

          Get.offAll(const MpinPage(
            isChangeMpin: false,
          ));
          fetchSecretKey(isFreshLogin: false);
        } else if (merchantDetails.value.data!.isMobileExist == true &&
            merchantDetails.value.data!.isDeviceExist == true) {
          var otpEnc = await AESEncryptor.encrypt(MpinPageFunction().mpin.text) ?? '';
          OtpPageFunction().login(
              mobile: LoginFunction().mobileNumber.text.isEmpty
                  ? LoginFunction().user.value.userMobile!
                  : LoginFunction().mobileNumber.text,
              password: otpEnc,
              isNormalFlow: true);
        }
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  bool callMerchantReRegistrationApi() {
    return merchantDetails.value.data!.isDeviceExist == false &&
        merchantDetails.value.data!.isMobileExist == true &&
        user.value.userType.toString() == '4';
  }

  Future<void> validateMpin({required String password}) async {
    try {
      var passEnc = await AESEncryptor.encrypt(password) ?? '';

      LoadingPrompt().show();
      final response = await ApiServices()
          .matchCredentials(password: passEnc, userName: mobileNumber.text);
      Navigator.pop(Get.context!);
      if (response != null && response.status == 0) {
        Get.off(OtpPage(
          mobile: mobileNumber.text,
        ));
      } else {
        ToastMessage().showToast(
          content: response!.errorData!.errorMessage,
        );
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }
}
