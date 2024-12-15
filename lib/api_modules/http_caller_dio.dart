
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:swinpay/functions/common_functions.dart';
import '../global/app_util.dart';
import 'api_exception_interceptor.dart';
import 'apis.dart';

class HttpCaller {
  HttpCaller._privateConstructor();

  static final HttpCaller _instance = HttpCaller._privateConstructor();

  factory HttpCaller() {
    return _instance;
  }

  Dio dio()  {
    final options = BaseOptions(
      baseUrl: Apis.host,
      connectTimeout: const Duration(milliseconds: AppLimit.requestTimeOut),
      receiveTimeout: const Duration(milliseconds: AppLimit.requestTimeOut),
      sendTimeout: const Duration(milliseconds: AppLimit.requestTimeOut),
    );

    var dio = Dio(options);

    dio.options.headers['MOBILE-OS'] = CommonFunctions().getDeviceType();
    dio.options.headers['APP-VERSION'] = '1.0';
    dio.options.headers['APP-VERSION-CODE'] = '2.0';
    dio.options.headers['channel'] = '14';

    if (AppUtil.authToken != '') {
      dio.options.headers['auth_token'] = AppUtil.authToken;
    }

    if (AppUtil.sessionToken != '') {
      dio.options.headers['session-token'] = AppUtil.sessionToken;
    }

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

    dio.interceptors.add(
      ApiExceptionInterceptor(dio: dio),
    );

    return dio;
  }
}

