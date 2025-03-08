

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import '../../../functions/common_functions.dart';
import '../../../functions/sales_function.dart';
import '../../../global/app_util.dart';
import '../../../models/backend/filterHistoryModel.dart';
import '../../../models/uiModels.dart';
import '../../widgets/buttons.dart';
import '../../widgets/datePicker.dart';
import '../../widgets/shapes.dart';
import '../transactions/transaction_details.dart';

class SalesPage extends StatefulWidget {
  final Function? onBack;

  const SalesPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  RxList<String> selectedFilterVal = <String>[].obs;
  Rx<BottomBarModel> selectedHistoryType = BottomBarModel().obs;
  final scrollController = ScrollController();
  RxBool isLoading=false.obs;
  RxBool isLoadingSales=false.obs;

  List<BottomBarModel> _allHistoryTypes() => [
        BottomBarModel(text: AppString().today, value: '1'),
        BottomBarModel(text: AppString().yesterday, value: '2'),
        BottomBarModel(text: AppString().thisWeek, value: '3'),
        BottomBarModel(text: AppString().thisMonth, value: '4'),
        BottomBarModel(text: AppString().thisYear, value: '5'),
        BottomBarModel(
          text: AppString().customDate,
          onTap: () async {
            var dateRage = await DatePickerUi().dateRangePicker(
                fromDate: SalesFunction().fromDate,
                toDate: SalesFunction().endDate);
            if (dateRage != null) {
              DateFormat inputFormat =
                  DateFormat('dd-MMM-yyyy'); // Adjust the input format

              DateTime startDate = dateRage.start;
              DateTime endDate = dateRage.end;
              SalesFunction().fromDate = dateRage.start;
              SalesFunction().endDate = dateRage.end;
              String formattedStartDate =
                  DateFormat('dd-MMM-yyyy').format(startDate);
              String formattedEndDate =
                  DateFormat('dd-MMM-yyyy').format(endDate);
              selectedHistoryType.value.subTitle =
                  '$formattedStartDate to $formattedEndDate';
              _fetchTransaction(fromDate: startDate, toDate: endDate);
            } else {
              selectedHistoryType(_allHistoryTypes()[0]);
              _fetchTransaction();
            }
            selectedHistoryType.refresh();
          },
          value: '6',
        ),
      ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectedFilterVal.clear();
      SalesFunction().clearFields();
      selectedHistoryType(_allHistoryTypes()[0]);
      scrollController.addListener(() {
        _scrollListner();
      });
      _fetchTransaction(pageno: 0,showLoader: true);
    });
    super.initState();
  }

  void _scrollListner() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (SalesFunction().salesData.value.txnCount > 15 &&
          SalesFunction().transactionList.length !=
              SalesFunction().salesData.value.txnCount) {
        SalesFunction().pageNumber = SalesFunction().pageNumber + 1;
        selectedHistoryType.value.value == '6'
            ? callDateApi(
                pageno: SalesFunction().pageNumber,
              )
            : _fetchTransaction(
                pageno: SalesFunction().pageNumber, showLoader: false,isFromScroll: true);

      }
    }
  }

  void callDateApi({required int pageno}) {
    DateTime startDate = SalesFunction().fromDate;
    DateTime endDate = SalesFunction().endDate;
    _fetchTransaction(
        fromDate: startDate, toDate: endDate, pageno: pageno, showLoader: false,isFromScroll: true);
  }

  Future<void> _fetchTransaction(
      {DateTime? fromDate,
      DateTime? toDate,
      int pageno = 0,
      bool showLoader = true, bool isFromScroll=false}) async {
    isFromScroll? isLoadingSales(true):null;
    isLoading(true);
    dynamic fromDateString, toDateString;
    if (fromDate != null) {
      fromDateString =
          '${fromDate.year}-${fromDate.month}-${fromDate.day} 00:00:00';
    }

    if (toDate != null) {
      toDateString = '${toDate.year}-${toDate.month}-${toDate.day} 23:59:59';
    }

    await SalesFunction().filterTransactionHistory(
        showLoader: showLoader,
        selectedStatus: selectedFilterVal.join(','),
        historyType: selectedHistoryType.value.value,
        fromDate: fromDateString,
        toDate: toDateString,
        pageNo: pageno);
    isLoadingSales(false);
    isLoading(false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppString().sales),
        ),
        body: Card(
          color: AppColors.card,
          shape: Shapes().cardRoundedBorder(allRadius: 35),
          margin:
              const EdgeInsets.only(top: 18, right: 12, left: 12, bottom: 25),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _bodyHeader(),
              const SizedBox(height: 5),
              Divider(color: AppColors.onBg.withOpacity(0.3)),
              const SizedBox(height: 10),
              Obx(
                () => SalesFunction().transactionList.isEmpty && !isLoading.value
                    ? Expanded(child: Center(child: Text(AppString().noSales)))
                    : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: SalesFunction().transactionList.value.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Get.to(TransactionDetailsPage(
                                tranDetail:
                                    SalesFunction().transactionList![index],
                              )),
                              child: _tile(
                                sale: SalesFunction().transactionList![index],
                              ),
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) => Divider(
                            color: AppColors.onBg.withOpacity(0.3),
                            height: 30,
                          ),
                        ),
                      ),
                    ),
              ),
            Obx(() =>isLoadingSales.value?
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CircularProgressIndicator(color: AppColors.onBg),
                ):Container()),
            ],
          ),
        ));
  }

  Widget _bodyHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Buttons().paymentStatusBtn(
                    selectedFilterVal: selectedFilterVal,
                    onTapApply: () {
                      SalesFunction().transactionList.clear();
                      SalesFunction().salesData(FilterData());

                      SalesFunction().pageNumber = 0;
                      _fetchTransaction(fromDate: SalesFunction().fromDate!,toDate:SalesFunction().endDate);
                      scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    }),
                const Spacer(),
                _durationBtn(),
              ],
            ),
            const SizedBox(height: 0),
            Obx(() => Text(
                selectedHistoryType.value.value == '6'
                    ? selectedHistoryType.value.subTitle ?? ''
                    : selectedHistoryType.value.text ?? '',
                style: TextStyle(color: AppColors.primary, fontSize: 18))),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    _titleText(AppString().noOfSales),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                        SalesFunction().salesData.value.txnCount.toString(),
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 22))),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    _titleText(AppString().totalAmount),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                        '${AppUtil.currency}${CommonFunctions().convertToDouble(value: SalesFunction().salesData.value.total)}',
                        style: TextStyle(
                            color: Colors.yellow.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 22))),
                  ],
                ))
              ],
            )
          ],
        ),
      );

  Widget _durationBtn() => Buttons().durationBtn(
      offset: const Offset(80, 40),
      data: _allHistoryTypes(),
      onSelected: (history) {
        if (history.value != SalesFunction().tempHistoryType) {
          selectedHistoryType(history);
          scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
        if (selectedHistoryType.value.value != '6' &&
            selectedHistoryType.value.value !=
                SalesFunction().tempHistoryType) {
          _fetchTransaction();
        }
      });

  Widget _titleText(String text) => Text(text,
      style: TextStyle(
          color: AppColors.onBg.withOpacity(0.6), fontWeight: FontWeight.w300));

  Widget _tile({required TransactionListElement sale}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                        '${AppString().transactionId} : ${sale.transactionId}',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onBg.withOpacity(0.9)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis)),
                Text(
                    '${AppUtil.currency}${CommonFunctions().convertToDouble(value: '${sale.amount}')}',
                    style: const TextStyle(
                        //color: Colors.o.shade200,
                        fontWeight: FontWeight.bold,
                        fontSize: 21)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Text(
                  CommonFunctions().dateFormatDMYHMSA(sale.date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.onBg.withOpacity(0.9)),
                )),
                Text(AppString.getStatus(status: sale.transactionStatus),
                    style: TextStyle(
                        color: AppColors.getStatusColor(
                            status: sale.transactionStatus),
                        fontSize: 13)),
                const SizedBox(width: 5),
                Icon(
                  _getIcon(status: sale.transactionStatus),
                  color:
                      AppColors.getStatusColor(status: sale.transactionStatus),
                  size: 20,
                )
              ],
            )
          ],
        ),
      );

  static IconData _getIcon({required dynamic status}) {
    try {
      status = status.toString();
      var icon = {
        "0": Icons.refresh,
        "1": Icons.check_circle_outline,
        "2": Icons.close
      };
      return icon[status] ?? Icons.refresh;
    } catch (_) {
      return Icons.refresh;
    }
  }
}
