import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:swinpay/view/screens/splash_screen.dart';
import 'package:swinpay/view/widgets/toastMessage.dart';

import '../global/app_util.dart';
import '../main.dart';
import '../models/backend/baseResponseModel.dart';

class ApiExceptionInterceptor extends Interceptor {
  Dio dio;

  ApiExceptionInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    AppUtil.printData('${err} DioException!', isError: true);
    if (err.response != null && err.response!.statusCode == 403) {
      // todo
      ToastMessage().showToast(content: 'Slow Internet');
      //AppSettings.openAppSettings(type: AppSettingsType.settings);
     // return;
    }else if (err != null) {
      // todo
      ToastMessage().showToast(content: 'Sorry Server Error');
      //AppSettings.openAppSettings(type: AppSettingsType.wifi);
     // return;
    } else if (err.response != null &&
        err.type != DioExceptionType.badResponse &&
        err.response!.data != null) {
      ErrorModel errorModel = ErrorModel.fromJson(err.response!.data);
      var res = await _unauthorizedAccess(err: errorModel);
      if (res != null) {
        handler.resolve(res);
      }
    }
    super.onError(err, handler);
  }

  Future<dynamic> _unauthorizedAccess({required ErrorModel err}) async {
    if (err.errorCode.toString() == '-114' ||
        err.errorCode.toString() == '-121') {
      ToastMessage().showToast(content: 'Session Timed Out');
      Get.offAll(const SplashScreen());
    }
  }
}
