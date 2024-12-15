import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/view/widgets/toastMessage.dart';
import '../api_modules/api_services.dart';
import '../global/app_util.dart';
import '../models/backend/filterHistoryModel.dart';
import '../view/widgets/loadingPrompt.dart';

class SalesFunction {
  SalesFunction._privateConstructor();

  static final SalesFunction _instance = SalesFunction._privateConstructor();

  factory SalesFunction() {
    return _instance;
  }

  Rx<FilterData> salesData = FilterData().obs;
  RxList<TransactionListElement> transactionList =
      <TransactionListElement>[].obs;
  int pageNumber = 0;
  DateTime fromDate = DateTime.now().add(const Duration(days: -30));
  DateTime endDate = DateTime.now();

  RxBool isPaginationLoading = false.obs;

  //temp to refersh list
  String? tempsSelectedStatus = '1';
  String? tempHistoryType = '0';
  String? tempFromDate = '';
  String? tempToDate = '';

  Future<FilterData?> filterTransactionHistory(
      {String? selectedStatus = '1',
      bool isDownload = false,
      String? fromDate = '',
      String? historyType = '1',
      int recordsPerPage = 15,
      String? toDate = '',
      int pageNo = 0,
      bool showLoader = true}) async {
    try {
      //selectedStatus
      //0:processing 1: success 2: failed
      showLoader ? LoadingPrompt().show() : null;
      final response = await ApiServices().filterTransactionHistory(
          toDate: toDate ?? '',
          historyType: int.tryParse('$historyType') ?? 1,
          pageNumber: pageNo,
          recordsPerPage: recordsPerPage,
          searchData: '',
          selectedStatus: selectedStatus != null && selectedStatus.isNotEmpty
              ? selectedStatus
              : '1',
          sort: 0,
          fromDate: fromDate ?? '',
          terminalID: '0');

      if (response != null && response.status == 0) {
        if (isDownload) {
          return response.data;
        } else {
          if (tempHistoryType != historyType ||
              tempsSelectedStatus != selectedStatus ||
              tempFromDate != fromDate ||
              tempToDate != toDate) {
            AppUtil.printData('data cleared ', isError: true);
            pageNumber = 0;
            salesData(FilterData());
            transactionList.clear();
          }
          salesData(response.data);
          var transactionSet = transactionList.value.toSet();

          for (var transaction in response.data!.transactionList!) {
            transactionSet.add(transaction);
          }
          transactionList.value = transactionSet.toList();
          tempHistoryType = historyType ?? '0';
          tempsSelectedStatus = selectedStatus ?? '1';
          tempToDate = toDate;
          tempFromDate = fromDate;
        }
      }
    } on DioException catch (_) {
      AppUtil.printData('error: $_', isError: true);
    } finally {
      salesData.refresh();
      showLoader ? Navigator.pop(Get.context!) : null;
    }
    return null;
  }

  void clearFields() {
    fromDate = DateTime.now().add(const Duration(days: -30));
    endDate = DateTime.now();
    pageNumber = 0;
    salesData(FilterData());
    transactionList.clear();
    tempHistoryType = '0';
  }

  Future<void> downloadSales() async {
    LoadingPrompt().show();
    var res = await filterTransactionHistory(
        isDownload: true,
        pageNo: -1,
        fromDate: tempFromDate,
        toDate: tempToDate,
        historyType: tempHistoryType,
        selectedStatus: tempsSelectedStatus,
        recordsPerPage: -1,
        showLoader: false);
    Navigator.pop(Get.context!);
    if (res != null && res.transactionList!.isNotEmpty) {
      _generateExcel(transaction: res);
    } else {
      ToastMessage().showToast(content: 'No Transactions');
    }
  }

  Future<void> _generateExcel({required FilterData transaction}) async {
    // Create a new Excel workbook
    final excel = Excel.createExcel();
    // Remove the default Sheet1

    final Sheet sheet = excel['Sheet1'];

    // excel.delete(excel.sheets.keys.first);

    List<String> headers = [
      'Sl.No',
      'Merchant ID',
      'MERCHANT NAME',
      'Terminal ID',
      'Date',
      'Amount',
      'SwinkPay Txn ID',
      'Org Txn ID',
      'RRN/UTR',
      'Status'
    ];
    for (int col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(headers[col]);
    }
    var transactionList = transaction.transactionList!;
    // Add transaction data
    for (int row = 0; row < transactionList.length; row++) {
      var colData = _getColData(
          transaction: transactionList[row], slNo: (row + 1).toString());
      for (int col = 0; col < headers.length; col++) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1))
            .value = TextCellValue(colData[col].toString());
      }
    }

    sheet
        .cell(CellIndex.indexByColumnRow(
            columnIndex: 4, rowIndex: transactionList.length + 2))
        .value =  TextCellValue('Total Amount:');

    var total = num.tryParse('${transaction.total}') != null
        ? num.tryParse('${transaction.total}')!.toStringAsFixed(1)
        : '-';

    sheet
        .cell(CellIndex.indexByColumnRow(
            columnIndex: 5, rowIndex: transactionList.length + 2))
        .value = TextCellValue(total);

    sheet.merge(
        CellIndex.indexByColumnRow(
            columnIndex: 0, rowIndex: transactionList.length + 3),
        CellIndex.indexByColumnRow(
            columnIndex: 3, rowIndex: transactionList.length + 3));

    sheet
            .cell(CellIndex.indexByColumnRow(
                columnIndex: 0, rowIndex: transactionList.length + 3))
            .value =
        TextCellValue(
            'Report generated on Date: ${CommonFunctions().dateFormatDMYHMSA(DateTime.now())}');

    var fileBytes = excel.save();

    // var directory = Platform.isAndroid ? await getExternalStorageDirectory(): getApplicationDocumentsDirectory();
    Directory? directory;

    if (Platform.isIOS) {
      directory = await getTemporaryDirectory();
    } else {
      directory = await getExternalStorageDirectory();
    }

    var filePath =
        '${directory?.path}/SwinkPayTransactions${DateTime.now().microsecondsSinceEpoch}.xlsx';

    // Save the Excel file

    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsBytes(fileBytes!);

    _openExcelFile(filePath);
  }

  List<dynamic> _getColData(
          {required TransactionListElement transaction,
          required String slNo}) =>
      [
        slNo,
        AppUtil.merchantId,
        AppUtil.merchantName,
        AppUtil.terminalId,
        transaction.date.toString(),
        transaction.amount,
        transaction.transactionId!,
        transaction.orgTxnId!,
        transaction.bankref!,
        AppString.getPaymentStatusText(status: transaction.transactionStatus)
      ];

  void _openExcelFile(String filePath) async {
    File file = File(filePath);
    var isExist = await file.exists();
    if (isExist) {
      AppUtil.printData('file exist $filePath');
      var res = await OpenFilex.open(filePath);
      AppUtil.printData('Open file ${res.type}');

      var msg = {
        ResultType.noAppToOpen: 'Supported apps not found !!!',
        ResultType.fileNotFound: 'File not found',
        ResultType.permissionDenied: 'Permission denied',
        ResultType.error: 'Something went wrong',
      };

      if (msg[res.type] != null) {
        ToastMessage().showToast(content: msg[res.type] ?? '');
      }
    } else {
      AppUtil.printData('File does not exist at the specified path: $filePath');
    }
  }
}
