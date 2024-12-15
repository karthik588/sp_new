mixin AppLimit {
  static const int requestTimeOut = 120000;
}

class Apis {
  static dynamic host = 'https://sandbox.swinkpay-fintech.com';

  String getCountry = host + '/api/v1/getCountry';

  String validateCountryCode = host + '/api/v1/validateCountryCode';

  String getInstitutionForMobile =
      host + '/api/v1/merchant/getinstituionformobile';

  String fetchUserDetails = host + '/api/v1/merchant/fetchUserDetails';

  String getSecretKey = host + '/api/v1/getSecretKey';

  String validateMerchantTerminalMobile =
      host + '/api/v1/ta/validatemerchantterminalmobile';

  String generateOtp = host + '/api/v1/merchant/generateotp';

  String verifyOtp = host + '/api/v1/merchant/verifyotp';

  String updateDevice = host + '/api/v1/ta/updatedevice';

  String login = host + '/api/v1/login';

  String userConfig = host + '/api/v1/userconfig';

  String updatePushToken = host + '/api/v1/merchant/updatepushtoken';

  String getQRCodeInfo = host + '/api/v1/merchant/getQRCodeInfo';

  String filterTransactionHistory =
      host + '/api/v1/merchant/filterTransactionHistory';

  String notificationList = host + '/api/v1/merchant/notificationlist';

  String changeNotificationStatus =
      host + '/api/v1/merchant/changenotificationstatus';

  String getStaticQr = host + '/api/v1/merchant/getstaticqr';

  String getTerminalQr = host + '/api/v1/getterminalqr';

  String cash = host + '/api/v1/cash';

  String statusCheck = host + '/api/v2/decision/static';

  String statusCheckDynamicQr = host + '/api/v2/decision';

  String smsPay = host + '/api/v2/plugin/sms/pay';

  String changePassword = host + '/api/v1/merchant/changepassword';

  String biometric = host + '/api/v1/auth/biometric';

  String registerUser = host + '/api/v1/ta/register';

  //merchant flow

  String verifyMobileAndDevice =
      host + '/api/v1/merchant/verifymobileanddevice';

  String matchCredentials = host + '/api/v1/merchant/matchcredentials';

  String merchantReRegistration = host + '/api/v1/merchant/reregistration';
}
