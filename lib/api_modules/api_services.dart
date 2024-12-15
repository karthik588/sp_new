import 'dart:io';

import 'package:dio/dio.dart';
import 'package:swinpay/functions/login/login_function.dart';
import 'package:swinpay/models/backend/baseResponseModel.dart';
import 'package:swinpay/models/backend/qrCodeInfoModel.dart';
import 'package:swinpay/models/backend/userConfigModel.dart';

import '../functions/common_functions.dart';
import '../functions/deviceInfo.dart';
import '../functions/rsaCipherFunction.dart';
import '../global/app_util.dart';
import '../models/backend/countryListModel.dart';
import '../models/backend/dynamicQrModel.dart';
import '../models/backend/filterHistoryModel.dart';
import '../models/backend/get_static_qr_model.dart';
import '../models/backend/institutionForMobileModel.dart';
import '../models/backend/loginResponseModel.dart';
import '../models/backend/notificationModel.dart';
import '../models/backend/secretKeyModel.dart';
import '../models/backend/userDetailModel.dart';
import '../models/backend/validateCountryCodeModel.dart';
import '../models/backend/validateMerchantMobileModel.dart';
import 'apis.dart';
import 'http_caller_dio.dart';

class ApiServices {
  String platform = '';

  ApiServices._privateConstructor();

  static final ApiServices _instance = ApiServices._privateConstructor();

  dynamic response;

  final Dio _dio = HttpCaller().dio();

  Future<Dio> resetDio() async {
    if (AppUtil.deviceId.isEmpty) {
      AppUtil.deviceId =
          RSACipher().encryptUsingPublicKey(await DeviceInfo().getDeviceId());

      AppUtil.printData('device ID :  ${AppUtil.deviceId}');
    }
    _dio.options.headers = {
      'device-id': AppUtil.deviceId.isNotEmpty ? AppUtil.deviceId : '',
      'MOBILE-OS': CommonFunctions().getDeviceType(),
      'APP-VERSION': '1.0',
      'APP-VERSION-CODE': '2.0',
      'channel': '14',
      'auth_token': AppUtil.authToken,
      'session-token':
          AppUtil.sessionToken.isNotEmpty ? AppUtil.sessionToken : ''
    };

    return _dio;
  }

  factory ApiServices() {
    return _instance;
  }

  Future<CountryModel?> getCountry() async {
    final response = await _dio.get(Apis().getCountry);

    return CountryModel.fromJson(response.data);
    return null;
  }

  Future<ValidateCountryCodeModel?> validateCountryCode() async {
    final response = await _dio
        .post(Apis().validateCountryCode, data: {'countryCode': '91'});
    if (response.statusCode == 200) {
      return ValidateCountryCodeModel.fromJson(response.data);
    }
    return null;
  }

  Future<InstitutionForMobileModel?> getInstitutionForMobile(
      {required int institutionId, required String mobile}) async {
    final response = await _dio.post(Apis().getInstitutionForMobile,
        data: {'institutionId': institutionId, 'mobile': '91-$mobile'});
    if (response.statusCode == 200) {
      return InstitutionForMobileModel.fromJson(response.data);
    }
    return null;
  }

  Future<UserDetailModel?> fetchUserDetails({required String mobile}) async {
    final response = await _dio
        .post(Apis().fetchUserDetails, data: {'userName': '91-$mobile'});
    if (response.statusCode == 200) {
      return UserDetailModel.fromJson(response.data);
    }
    return null;
  }

  Future<SecretKeyModel?> getSecretKey() async {
    final response = await _dio.get(Apis().getSecretKey);
    if (response.statusCode == 200) {
      return SecretKeyModel.fromJson(response.data);
    }
    return null;
  }

  Future<ValidateMerchantMobileModel?> validateMerchantTerminalMobile(
      {required String mobile}) async {
    final response =
        await _dio.post(Apis().validateMerchantTerminalMobile, data: {
      "deviceId": AppUtil.deviceId,
      "mobile": LoginFunction().user.value.merchantMobileNumber,
      "terminal": LoginFunction().user.value.terminalNumber,
      "terminalMobile": "91-$mobile"
    });
    if (response.statusCode == 200) {
      return ValidateMerchantMobileModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> generateOtp({required String mobile}) async {
    final response = await _dio.post(Apis().generateOtp,
        data: {'mobile': '${AppUtil.countryCode}-$mobile'});
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> verifyOtp(
      {required String mobile, required String otp}) async {
    final response = await _dio.post(Apis().verifyOtp,
        data: {"mobile": '${AppUtil.countryCode}-$mobile', "otp": otp});
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> updateDevice({
    required String data,
    required String deviceId,
    required String devicePushToken,
    required String geoLatitude,
    required String geoLongitude,
    required String mobile,
    String? mpin,
    required String terminal,
    required String terminalMobile,
  }) async {
    final response = await _dio.post(Apis().updateDevice, data: {
      "data": data,
      "deviceId": deviceId,
      //  'VY6PfLr8/7inpwCX5KA50a0gzDJdN7KRJZA3OwC4UA7I+7kV3Q2JX7PmV84s1OaGXqwr3TQvK7xH7QYdN1yTMdwtjfl8M4rqJGgJIRxkW7Y4SIbe6+KkYe/f+0ET4v5Uqysep8sWGxEXTGf82H2iVI04Y1n0ereYCymmNQ7KwGe+lxGj8+LziDZCCe1+s4OVGxjTAF29R8+QBQfHb4q6lcSO61U61WsfV1niGIpn36hjaKO5+0tqVaIfl/YejCYVC0swfhjsFj13LoBnc6gZfEmR4tNKsszgTik1UAoIUmIA95pDg8ZGXJAut79D6mD/UytsEXzt1bACm6WbS+oGrQ==',
      "devicePushToken": devicePushToken,
      "deviceType": CommonFunctions().getDeviceType(),
      "geoLatitude": geoLatitude,
      "geoLongitude": geoLongitude,
      "mobile": mobile,
      //"mpin": mpin,
      "terminal": terminal,
      "terminalMobile": '${AppUtil.countryCode}-$terminalMobile'
    });
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> registerser({
    required String data,
    required String deviceId,
    required String devicePushToken,
    required String geoLatitude,
    required String geoLongitude,
    required String mobile,
    String? mpin,
    required String terminal,
    required String terminalMobile,
  }) async {
    final response = await _dio.post(Apis().registerUser, data: {
      "data": data,
      "deviceId": deviceId,
      "devicePushToken": devicePushToken,
      "deviceType": CommonFunctions().getDeviceType(),
      "geoLatitude": geoLatitude,
      "geoLongitude": geoLongitude,
      "mobile": mobile,
      "mpin": mpin,
      "terminal": terminal,
      "terminalMobile": '${AppUtil.countryCode}-$terminalMobile'
    });
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<LoginResponseModel?> login(
      {required String password, required String userName}) async {
    final response = await _dio.post(Apis().login, data: {
      "password": password,
      "userName": '${AppUtil.countryCode}-$userName'
    });
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(response.data);
    }

    return null;
  }

  Future<LoginResponseModel?> bioMetricApi({required String token}) async {
    final response = await _dio.post(Apis().biometric, data: {
      "token": token,
    });
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(response.data);
    }

    return null;
  }

  Future<UserConfigModel?> userConfig() async {
    final response = await _dio.get(Apis().userConfig);
    if (response.statusCode == 200) {
      return UserConfigModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> updatePushToken(
      {required String devicePushToken}) async {
    final deviceType = Platform.isIOS ? 'iOS' : 'Android';
    final response = await _dio.post(Apis().updatePushToken,
        data: {"deviceType": deviceType, "devicePushToken": devicePushToken});
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<QRcodeInfoModel?> getQRCodeInfo() async {
    final response = await _dio.get(Apis().getQRCodeInfo);
    if (response.statusCode == 200) {
      return QRcodeInfoModel.fromJson(response.data);
    }
    return null;
  }

  Future<NotificationModel?> getNotificationList() async {
    final response = await _dio.get(Apis().notificationList);
    if (response.statusCode == 200) {
      return NotificationModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> changeNotificationStatus() async {
    final response = await _dio.post(Apis().changeNotificationStatus);
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<GetStaticQrModel?> getStaticQr({required String terminalID}) async {
    final response =
        await _dio.post(Apis().getStaticQr, data: {'terminalID': terminalID});
    if (response.data != null) {
      return GetStaticQrModel.fromJson(response.data);
    }
    return null;
  }

  Future<GetStaticQrModel?> getterTerminalQr(
      {required String amount,
      required String dateTime,
      required String invoiceNumber,
      required String terminalID,
      required String txnID}) async {
    final response = await _dio.post(Apis().getTerminalQr, data: {
      "amount": double.parse(amount),
      "dateAndTime": dateTime,
      "invoiceNumber": invoiceNumber,
      "terminalID": terminalID,
      "txnID": txnID
    });
    if (response.statusCode == 200) {
      return GetStaticQrModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> smsPay(
      {required String amount,
      required String dateTime,
      required String invoiceNumber,
      required String terminalID,
      required String txnID,
      required String mobNo}) async {
    final response = await _dio.post(Apis().smsPay, data: {
      "amount": amount,
      "dateAndTime": dateTime, // 2024-01-27 01:01:01",
      "invoiceNumber": invoiceNumber,
      "terminalID": terminalID,
      "txnID": txnID,
      "mobile": '${AppUtil.countryCode}-$mobNo'
    });
    if (response.data != null) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> cash({
    required double amount,
    required String merchantId,
    required String modeOfPayment,
    required String orderID,
    required String terminalID,
    required String txnID,
  }) async {
    final response = await _dio.post(Apis().cash, data: {
      "amount": amount,
      "merchantId": merchantId,
      "modeofpayment": modeOfPayment,
      "orderID": orderID,
      "terminalId": terminalID,
      "txnID": '',
    });
    if (response.data != null) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<DynamicQrModel?> statusCheck(
      {required String amount,
      required String dateTime,
      required String invoiceNumber,
      required String terminalID,
      required String txnID,
      required String utr,
      required bool isDynamicQr}) async {
    var data = {
      "amount": double.parse(amount),
      "dateAndTime": dateTime,
      "invoiceNumber": invoiceNumber,
      "terminalID": terminalID,
      "txnID": txnID,
    };
    if (utr.isNotEmpty) {
      data['utr'] = utr;
    }
    final response = isDynamicQr
        ? await _dio.post(Apis().statusCheckDynamicQr, data: data)
        : await _dio.post(Apis().statusCheck, data: data);
    if (response.data != null) {
      return DynamicQrModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> changePassword({
    required String newMpin,
    required String oldMpin,
    required String terminalMobile,
  }) async {
    final response = await _dio.post(Apis().changePassword, data: {
      "newMpin": newMpin,
      "oldMpin": oldMpin,
      "terminalMobile": '${AppUtil.countryCode}-$terminalMobile'
    });
    if (response.data != null) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<FilterTransactionHistoryodel?> filterTransactionHistory({
    required String toDate,
    required int historyType,
    required int pageNumber,
    required int recordsPerPage,
    required String searchData,
    required String selectedStatus,
    required int sort,
    required String fromDate,
    required String terminalID,
  }) async {
    var data = {
      "toDate": toDate,
      "historyType": historyType,
      "pageNumber": pageNumber,
      "searchData": searchData,
      "selectedStatus": selectedStatus,
      "sort": sort,
      "fromDate": fromDate,
      "terminalID": terminalID,
      "recordsPerPage": recordsPerPage,
    };

    final response =
        await _dio.post(Apis().filterTransactionHistory, data: data);
    if (response.data != null) {
      return FilterTransactionHistoryodel.fromJson(response.data);
    }
    return null;
  }

  //merchant

  Future<ValidateMerchantMobileModel?> validateMerchantMobileAndDevice(
      {required String mobile}) async {
    final response = await _dio.post(Apis().verifyMobileAndDevice, data: {
      "deviceId": AppUtil.deviceId,
      "mobile": '${AppUtil.countryCode}-$mobile',
    });
    if (response.data != null) {
      return ValidateMerchantMobileModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> matchCredentials(
      {required String password, required String userName}) async {
    final response = await _dio.post(Apis().matchCredentials, data: {
      "password": password,
      "userName": '${AppUtil.countryCode}-$userName',
    });
    if (response.data != null) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }

  Future<BaseResponseModel?> merchantReRegistration(
      {required String data, required String mobile}) async {
    final response = await _dio.post(Apis().merchantReRegistration, data: {
      "data": data,
      "deviceId": AppUtil.deviceId,
      "deviceType": CommonFunctions().getDeviceType(),
      "newMobile": '${AppUtil.countryCode}-$mobile',
      "oldMobile": '${AppUtil.countryCode}-$mobile',
      "devicePushToken": AppUtil.fcmToken
    });
    if (response.statusCode == 200) {
      return BaseResponseModel.fromJson(response.data);
    }
    return null;
  }
}
