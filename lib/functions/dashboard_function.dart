import 'dart:io';
import 'dart:typed_data';
import 'package:open_filex/open_filex.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/widgets/loadingPrompt.dart';
import 'package:swinpay/view/widgets/toastMessage.dart';
import '../../api_modules/api_services.dart';
import '../models/backend/dynamicQrModel.dart';
import '../models/backend/filterHistoryModel.dart';
import '../models/backend/get_static_qr_model.dart';
import '../models/backend/notificationModel.dart';
import '../models/backend/qrCodeInfoModel.dart';
import '../view/screens/qrscan/dynamic_qr_page.dart';

class DashboardFunction {
  DashboardFunction._privateConstructor();

  static final DashboardFunction _instance =
      DashboardFunction._privateConstructor();

  factory DashboardFunction() {
    return _instance;
  }

  final scrollController = ScrollController();

  RxList<String> selectedFilterValInDashboard = <String>[].obs;
  RxList<NotificationList> allNotificationList = <NotificationList>[].obs;
  Rx<QRcodeInfoModel> dashBoardInfo = QRcodeInfoModel().obs;
  Rx<FilterData> salesData = FilterData().obs;
  Rx<GetStaticQrModel> staticQrCodeList = GetStaticQrModel().obs;
  Rx<GetStaticQrModel> dynamicQrCodeList = GetStaticQrModel().obs;
  Rx<DynamicQrModel> dynamicQrStatus = DynamicQrModel().obs;
  RxList<TransactionListElement> transactionList =
      <TransactionListElement>[].obs;
  int pageNumber = 0;
  ScreenshotController screenshotController = ScreenshotController();

  RxBool isNotificationLoading = false.obs;
  RxBool isCashLoading = false.obs;
  RxBool isStaticQrLoading = false.obs;
  RxBool isPaymentLInkLoading = false.obs;
  RxBool isPaymentStatusCheckLoading = false.obs;
  RxBool isDynamicQrLoading = false.obs;
  RxBool isSalesLoading = false.obs;
  RxString qrCodeString = ''.obs;
  RxBool isinitLoading = false.obs;

  final TextEditingController amount = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  final TextEditingController utrNo = TextEditingController();

  Future<void> fetchAllNotifications() async {
    allNotificationList.clear();
    try {
      isNotificationLoading(true);
      final response = await ApiServices().getNotificationList();
      isNotificationLoading(false);
      if (response != null && response.status == 0) {
        allNotificationList(response.data!.notificationList);
      }
    } on DioException catch (_) {
      isNotificationLoading(false);
      AppUtil.printData(
        'error: $_',
      );
    }
  }

  Future<void> onRefresh({bool isOnRefresh = false}) async {
    try {
      pageNumber = 0;
      if (!isOnRefresh) {
        transactionList.clear();
        salesData(FilterData());
      }
      await filterTransactionHistory(
          selectedStatus: selectedFilterValInDashboard.join(','),
          isFromRefresh: isOnRefresh);
      //todo:

      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInCirc,
      );
    } catch (_) {
      AppUtil.printData('i am catch at onRefresh at dashboradfunctikon',
          isError: true);
    }
  }

  Future<void> getQRCodeInfo() async {
    dashBoardInfo(QRcodeInfoModel());
    try {
      final response = await ApiServices().getQRCodeInfo();
      if (response != null && response.status == 0) {
        dashBoardInfo(response);
        AppUtil.terminalId = dashBoardInfo.value.data!.terminalId!;
        AppUtil.merchantId = dashBoardInfo.value.data!.merchantIdentifier!;
        AppUtil.merchantName = dashBoardInfo.value.data!.merchantName!;
      }
    } on DioException catch (_) {
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> filterTransactionHistory(
      {String? selectedStatus = '1',
      String fromDate = '',
      String toDate = '',
      int pageNo = 0,
      bool isFromScroll = false,
      bool isFromRefresh = false}) async {
    try {
      isFromScroll ? isSalesLoading(true) : null;
      isinitLoading(true);
      //selectedStatus
      //0:processing 1: success 2: failed
      if (!isFromRefresh && !isFromScroll) {
        LoadingPrompt().show();
        salesData(FilterData());
      }
      final response = await ApiServices().filterTransactionHistory(
          toDate: toDate,
          historyType: 1,
          pageNumber: pageNo,
          recordsPerPage: 15,
          searchData: '',
          selectedStatus: selectedStatus != null && selectedStatus.isNotEmpty
              ? selectedStatus
              : '1',
          sort: 0,
          fromDate: fromDate,
          terminalID: '0');

      salesData(FilterData());

      if (pageNumber == 0) {
        transactionList.clear();
      }

      if (response != null && response.status == 0) {
        salesData(response.data);
        transactionList = transactionList + response.data!.transactionList!;
      }
    } on DioException catch (_) {
      salesData(FilterData());
      AppUtil.printData('error: $_', isError: true);
    } finally {
      if (!isFromRefresh && !isFromScroll) {
        Navigator.pop(Get.context!);
      }
      isSalesLoading(false);
      isinitLoading(false);
    }
  }

  Future<void> cash() async {
    try {
      LoadingPrompt().show();
      final response = await ApiServices().cash(
        amount: double.parse(amount.text),
        merchantId: dashBoardInfo.value.data!.merchantIdentifier.toString(),
        modeOfPayment: 'cash',
        orderID: CommonFunctions()
            .getOrderId(terminalId: dashBoardInfo.value.data!.terminalId!),
        terminalID: dashBoardInfo.value.data!.terminalId.toString(),
        txnID: '',
      );
      Navigator.pop(Get.context!);
      if (response != null && response.status == 0) {
        ToastMessage()
            .showToast(content: 'Transaction registered successfully');
        amount.clear();
        transactionList.clear();
        filterTransactionHistory(
                pageNo: 0,
                selectedStatus: selectedFilterValInDashboard.join(','))
            .asStream();
      }
    } on DioException catch (_) {
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> getStaticQr() async {
    try {
      staticQrCodeList(GetStaticQrModel());
      isStaticQrLoading(true);
      final response = await ApiServices().getStaticQr(
        terminalID: dashBoardInfo.value.data!.terminalId.toString(),
      );
      isStaticQrLoading(false);
      if (response != null && response.status == 0) {
        staticQrCodeList(response);
      } else {
        ToastMessage().showToast(content: response!.errorData!.errorMessage);
        utrNo.clear();
      }
    } on DioException catch (_) {
      isStaticQrLoading(false);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> sendPayemntLink() async {
    try {
      isPaymentLInkLoading(true);
      final response = await ApiServices().smsPay(
        txnID: CommonFunctions().getRandomTxnId(),
        amount: amount.text,
        dateTime:
            CommonFunctions().dateFormatForBackend(DateTime.now().toString()),
        invoiceNumber: CommonFunctions().getRandomTxnId(),
        mobNo: mobile.text,
        terminalID: dashBoardInfo.value.data!.terminalId.toString(),
      );
      isPaymentLInkLoading(false);
      if (response != null && response.status == 0) {
        amount.clear();
        mobile.clear();
        ToastMessage().showToast(content: 'payment link sent successfully');
      }
    } on DioException catch (_) {
      isPaymentLInkLoading(false);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  Future<void> checkPaymentStatus(
      {required String amount,
      required String utr,
      String invoiceNo = '',
      required bool isDynamicStatusCheck}) async {
    try {
      isDynamicStatusCheck
          ? isPaymentStatusCheckLoading(true)
          : LoadingPrompt().show();
      final response = await ApiServices().statusCheck(
        isDynamicQr: isDynamicStatusCheck,
        utr: utr,
        txnID: '',
        amount: amount,
        dateTime:
            CommonFunctions().dateFormatForBackend(DateTime.now().toString()),
        invoiceNumber: invoiceNo,
        terminalID: AppUtil.terminalId,
      );
      isDynamicStatusCheck
          ? isPaymentStatusCheckLoading(false)
          : Navigator.pop(Get.context!);
      if (response != null && response.status == 0) {
        isDynamicStatusCheck
            ? dynamicQrStatus(response)
            : ToastMessage()
                .showToast(content: response.data!.statusMessage ?? '-');
        utrNo.clear();
      } else {
        ToastMessage().showToast(content: response!.errorData!.errorMessage);
        utrNo.clear();
      }
    } on DioException catch (_) {
      isDynamicStatusCheck
          ? isPaymentStatusCheckLoading(false)
          : Navigator.pop(Get.context!);
      // ToastMessage()
      //     .showToast(content: AppString().somethingWentWrongPlzTryAgain);
    }
  }

  Future<void> getTerminalQr() async {
    try {
      LoadingPrompt().show();
      var randomId = CommonFunctions().getRandomTxnId();
      final response = await ApiServices().getterTerminalQr(
        invoiceNumber: randomId,
        dateTime:
            CommonFunctions().dateFormatForBackend(DateTime.now().toString()),
        amount: amount.text,
        terminalID: AppUtil.terminalId,
        txnID: randomId,
      );
      Navigator.pop(Get.context!);
      if (response != null && response.status == 0) {
        dynamicQrCodeList(response);
        Get.to(DynamicQrScreen(
          amount: amount.text,
          invoiceNo: randomId,
        ));
      } else {
        ToastMessage().showToast(
            content: response!.errorData!.errorMessage ??
                'Something went wrong, Please try again later');
      }
    } on DioException catch (_) {
      // ToastMessage()
      //     .showToast(content: 'Something went wrong, Please try again later');
      Navigator.pop(Get.context!);
      AppUtil.printData('error: $_', isError: true);
    }
  }

  void downloadQr() {
    try {
      screenshotController
          .capture(delay: const Duration(milliseconds: 10))
          .then((capturedImage) async {
        if (capturedImage != null) {
          _storeAndOpenImage(capturedImage);
        } else {
          AppUtil.printData('Image not captures');
        }
      }).catchError((onError) {
        AppUtil.printData(onError);
      });
    } catch (_) {
      AppUtil.printData('ERR downloadQr $_');
      ToastMessage().showToast(content: 'Something went wrong');
    }
  }

  void _storeAndOpenImage(Uint8List imageData) async {
    try {
      // Get the directory where the image will be saved
      Directory? directory;
      if (Platform.isIOS) {
        directory = await getTemporaryDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }
      String filePath = '${directory?.path}/my_image.png';

      // Write the image data to the file
      File file = File(filePath);
      await file.writeAsBytes(imageData);

      ToastMessage().showToast(content: 'QR code downloaded successfully');

      await Future.delayed(const Duration(seconds: 2));

      // Open the saved image file
      OpenFilex.open(filePath);
    } catch (_) {
      AppUtil.printData('ERR _storeAndOpenImage $_');
      ToastMessage().showToast(content: 'Something went wrong');
    }
  }

  void refreshPage() {
    scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }
}
