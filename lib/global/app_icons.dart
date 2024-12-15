
class AppIcons {
  AppIcons._privateConstructor();

  static final AppIcons _instance = AppIcons._privateConstructor();

  factory AppIcons() {
    return _instance;
  }
  static const String _imgPath = 'assets/images/';
  static const String _svgPath = 'assets/svg/';

  static String splashImage = '${_imgPath}splash.png';
  static String splashBg = '${_imgPath}splash_bg.png';
  static String splashBottomImageFirst = '${_imgPath}swinkpay_new_logo.png';
  static String splashBottomImageSecond = '${_imgPath}ic_airtel_logo.png';
  static String splashBottomImageThird = '${_imgPath}pci_dss_logo.png';
  static String termsAndCondition = 'assets/terms_n_conditions.html';

  static String svgAirtel = '${_svgPath}ic_airtel_logo.png';
  static String svgAmazonPay = '${_svgPath}ic_amazonpay.png';
  static String svgFreeCharge = '${_svgPath}ic_freecharge.png';
  static String svgGpay = '${_svgPath}ic_gpay.png';
  static String svgPaytm = '${_svgPath}ic_paytm.png';
  static String svgPhonePay = '${_svgPath}ic_phonepe.png';
  static String svgWhatsApp = '${_svgPath}ic_whatsapp.png';
  static String svgMobiKwik = '${_svgPath}ic_mobikwik.png';
  static String svgUpi = '${_svgPath}BHIM UPI-01.png';
  static String svgVhim = '${_svgPath}logo_bhim.png';

  static String cashImage = '${_svgPath}img_cash.png';
  static String rectImage = '${_svgPath}sp_rect_3.png';

  static String paymentSuccess = '${_imgPath}payment_link_success.png';
  static String paymentProcessing = '${_imgPath}payment_processing.png';
  static String paymentFailed = '${_imgPath}transaction_failure.png';

  static String getIcon({required dynamic status}) {
    try {
      status = status.toString();
      var icon = {
        "0": paymentProcessing,
        "1": paymentSuccess,
        "2": paymentFailed
      };
      return icon[status] ?? paymentProcessing;
    } catch (_) {
      return paymentProcessing;
    }
  }
}
