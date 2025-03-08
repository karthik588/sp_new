import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/screens/dashboard/moreSheet.dart';
import 'package:swinpay/view/screens/dashboard/sideDrawer.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../functions/dashboard_function.dart';
import '../../../functions/login/otp_page_function.dart';
import '../../../models/backend/filterHistoryModel.dart';
import '../../../models/uiModels.dart';
import '../../widgets/datePicker.dart';
import '../transactions/transaction_details.dart';
import 'cash_mode_prompt.dart';

class DashBoardPage2 extends StatefulWidget {
  const DashBoardPage2({Key? key}) : super(key: key);

  static const _headerStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  State<DashBoardPage2> createState() => _DashBoardPage2State();
}

class _DashBoardPage2State extends State<DashBoardPage2> {
  final Rx<BottomBarModel> _topAction = BottomBarModel().obs;
  RxList<String> selectedFilterVal = <String>[].obs;
  Rx<BottomBarModel> selectedHistoryType = BottomBarModel().obs;
  final scrollController = ScrollController();
  RxBool isLoading=false.obs;
  RxBool isLoadingSales=false.obs;

  final _bottomData = [
    BottomBarModel(
        icon: Icons.qr_code_scanner,
        onTap: () {
          DashboardFunction().amount.clear();
          CashModePrompt().show(
              controller: DashboardFunction().amount,
              onTapContinue: () async {
                Navigator.pop(Get.context!);
                await DashboardFunction().getTerminalQr();
              });
        },
        text: AppString().qr),
    BottomBarModel(
        icon: Icons.payments,
        onTap: () {
          DashboardFunction().amount.clear();
          CashModePrompt().show(
              controller: DashboardFunction().amount,
              onTapContinue: () async {
                Navigator.pop(Get.context!);
                await DashboardFunction().cash();
              });
        },
        text: AppString().cash),
    BottomBarModel(
        icon: Icons.add_circle,
        onTap: () => MoreSheet().show(),
        text: AppString().more),
  ];

  _topActions() => [
        BottomBarModel(
            icon: Icons.qr_code_scanner, onTap: () {},
            body: _body(),
            text: AppString().sales),
        BottomBarModel(
            icon: Icons.credit_card_rounded,
            onTap: () {},
            body: _body(),
            text: AppString().settlements),
        BottomBarModel(
            icon: Icons.add_circle,
            onTap: () {},
            body: _graph(),
            text: AppString().liveStatus,
            hideDuration: true),
      ];

  final _tableHeader = [
    TableModel(text: AppString().time, style: DashBoardPage2._headerStyle),
    TableModel(text: AppString().amount, style: DashBoardPage2._headerStyle),
    TableModel(text: AppString().paidBy, style: DashBoardPage2._headerStyle),
    TableModel(text: AppString().status, style: DashBoardPage2._headerStyle),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      selectedFilterVal.clear();
      _topAction(_topActions()[0]);
      DashboardFunction().clearFields();
      DashboardFunction().getQRCodeInfo();
      selectedHistoryType(_allHistoryTypes()[0]);
      scrollController.addListener(() {
        _scrollListner();
      });
      _fetchTransaction(pageno: 0, showLoader: true);
    });

  }
  void _scrollListner() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (DashboardFunction().salesData.value.txnCount > 15 &&
          DashboardFunction().transactionList.length !=
              DashboardFunction().salesData.value.txnCount) {
        DashboardFunction().pageNumber = DashboardFunction().pageNumber + 1;
        selectedHistoryType.value.value == '6'
            ? callDateApi(
          pageno: DashboardFunction().pageNumber,
        )
            : _fetchTransaction(
            pageno: DashboardFunction().pageNumber, showLoader: false,isFromScroll: true);

      }
    }
  }
  void callDateApi({required int pageno}) {
    DateTime startDate = DashboardFunction().fromDate;
    DateTime endDate = DashboardFunction().endDate;
    _fetchTransaction(
        fromDate: startDate, toDate: endDate, pageno: pageno, showLoader: false,isFromScroll: true);
  }



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
            fromDate: DashboardFunction().fromDate,
            toDate: DashboardFunction().endDate);
        if (dateRage != null) {
          DateFormat inputFormat =
          DateFormat('dd-MMM-yyyy'); // Adjust the input format

          DateTime startDate = dateRage.start;
          DateTime endDate = dateRage.end;
          DashboardFunction().fromDate = dateRage.start;
          DashboardFunction().endDate = dateRage.end;
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

    await DashboardFunction().filterSales(
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
      key: _scaffoldKey,
      drawer: SideDrawer(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _header(),
                  const SizedBox(height: 15),
                  Expanded(child: _body()),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _bottomBar(),
        ],
      )),
    );
  }

  Widget _header() => Column(children: [
        Row(
          children: [
            Expanded(child: _profile()),
            Icon(
              Icons.notifications_none,
              size: 38,
              color: AppColors.onBg,
            ),
          ],
        ),
        const SizedBox(height: 13),
        Obx(
          () => Row(
              children: List.generate(
                  _topActions().length,
                  (index) => Expanded(
                      child: _topActions()[index].text == _topAction.value.text
                          ? Buttons().raisedButton(
                              padding: const EdgeInsets.all(0),
                              textStyle: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w400),
                              radius: 80,
                              buttonText: _topActions()[index].text,
                              onTap: () =>
                                  _onTapTopAction(_topActions()[index]))
                          : TextButton(
                              onPressed: () =>
                                  _onTapTopAction(_topActions()[index]),
                              child: Text(
                                _topActions()[index].text ?? '',
                                style: TextStyle(
                                    color: AppColors.onBg.withOpacity(0.5),
                                    fontWeight: FontWeight.w300),
                              ))))),
        )
      ]);

  void _onTapTopAction(BottomBarModel action) {
    if (action.onTap != null) {
      action.onTap!();
    }
    _topAction(action);
  }

  Widget _profile() => Obx(() => Row(
    children: [
      InkWell(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: SizedBox(
          width: 40.0,
          // Adjust the width as needed to accommodate the outer circle
          height: 40.0,
          // Adjust the height as needed to accommodate the outer circle
          child: Stack(
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipOval(
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: const AssetImage(''),
                    image: NetworkImage(
                      OtpPageFunction()
                          .loginData
                          .value
                          .data!
                          .userProfile!
                          .profileUrl ??
                          '',
                      headers: {
                        'session-token': AppUtil.sessionToken.isNotEmpty
                            ? AppUtil.sessionToken
                            : '',
                        'device-id': AppUtil.deviceId.isNotEmpty
                            ? AppUtil.deviceId
                            : '',
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    // Pink color for the outer circle
                    width:
                    1.0, // Adjust the width of the outer circle as needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 5),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DashboardFunction().dashBoardInfo.value.data!.merchantName ?? '',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onBg,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            const SizedBox(height: 1),
            Text(
              DashboardFunction().dashBoardInfo.value.data!.storeLocation ??
                  '',
              style: TextStyle(
                  fontSize: 10,
                  color: AppColors.onBg,
                  fontWeight: FontWeight.w300),
              maxLines: 2,
            ),
          ],
        ),
      )
    ],
  ));

  Widget _body() => Obx(() => Card(
      color: AppColors.card,
      shape: Shapes().cardRoundedBorder(allRadius: 35),
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _bodyHeader(),
          Divider(color: AppColors.primary),
          const SizedBox(height: 10),
          Expanded(
              child: DashboardFunction().transactionList.isEmpty &&
                  !DashboardFunction().isinitLoading.value
                  ? Center(child: Text(AppString().noSales))
                  : _sales()),
        ],
      )));


  Widget _bodyHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                    height: 30,
                    padding: const EdgeInsets.only(bottom: 5),
                    alignment: Alignment.center,
                    child:Obx(() =>  Text( selectedHistoryType.value.value == '6'
                        ? selectedHistoryType.value.subTitle ?? ''
                        : selectedHistoryType.value.text ?? ''))),
                Obx(() => Visibility(
                      visible: !(_topAction.value.hideDuration ?? true),
                      child: Positioned(
                        right: 0,
                        child: Buttons().durationBtn(
                          offset: const Offset(80, 40),
                          data: _allHistoryTypes(),
                          onSelected: (history) {
                            if (history.value != DashboardFunction().tempHistoryType) {
                              selectedHistoryType(history);
                              scrollController.animateTo(
                                0.0,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                            }
                            if (selectedHistoryType.value.value != '6' &&
                                selectedHistoryType.value.value !=
                                    DashboardFunction().tempHistoryType) {
                              _fetchTransaction();
                            }
                          })
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: Column(
                      children: [
                        _titleText(AppString().noOfSales),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                            DashboardFunction().salesData.value.txnCount.toString(),
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
                            '${AppUtil.currency}${CommonFunctions().convertToDouble(value: DashboardFunction().salesData.value.total)}',
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

  Widget _titleText(String text) => Text(text,
      style: TextStyle(
          color: AppColors.onBg.withOpacity(0.6), fontWeight: FontWeight.w300));


  Widget _sales() => Column(
    children: [
      Visibility(
          visible: !DashboardFunction().isinitLoading.value,
          child: _tableRows(data: _tableHeader)),
      const SizedBox(height: 5),
      Obx(() => Expanded(
        child: ListView.separated(
          controller: scrollController,
          padding: const EdgeInsets.only(top: 25),
          itemCount: DashboardFunction().transactionList.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () => Get.to(TransactionDetailsPage(
              tranDetail: DashboardFunction().transactionList[index],
            )),
            child: _tableRows(data: [
              TableModel(
                  text: CommonFunctions().formatTime(DashboardFunction()
                      .transactionList![index]
                      .date!),
                  style: _tableBodyStyle),
              TableModel(
                  text:
                  '${AppUtil.currency}${CommonFunctions().convertToDouble(value: DashboardFunction().transactionList![index].amount)}',
                  style: _tableBodyStyle),
              TableModel(
                  text: DashboardFunction()
                      .transactionList![index]
                      .customerName,
                  style: _tableBodyStyle),
              TableModel(
                text: AppString.getStatus(
                    status: DashboardFunction()
                        .transactionList![index]
                        .transactionStatus),
                style: _tableBodyStyle.copyWith(
                  color: AppColors.getStatusColor(
                      status: DashboardFunction()
                          .transactionList![index]
                          .transactionStatus),
                ),
              ),
            ]),
          ),
          separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 30),
        ),
      )),
      const SizedBox(height: 10),
      Obx(() => isLoadingSales.value
          ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: CircularProgressIndicator(color: AppColors.onBg),
      )
          : Container()),
    ],
  );

  final _tableBodyStyle =
  TextStyle(color: AppColors.onBg, fontWeight: FontWeight.w300);

  Widget _tableRows({required List<TableModel> data}) => Row(
      children: List.generate(
          data.length,
              (index) => Expanded(
              child: Text(
                data[index].text ?? '',
                style: data[index].style,
                textAlign: data[index].textAlign ?? TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))));


  Widget _bottomBar() => Card(
        margin: const EdgeInsets.all(0),
        shape: Shapes().cardRoundedBorder(tr: 30, tl: 30),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_bottomData.length,
                (index) => Buttons().bottomBtn(data: _bottomData[index])),
          ),
        ),
      );

  Widget _graph() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 40),
      height: 150,
      child: SfCartesianChart(
        primaryYAxis: NumericAxis(
            isVisible: true,
            // Y axis labels will be rendered with currency format
            numberFormat:
                NumberFormat.simpleCurrency(name: '₹ ', decimalDigits: 2)),
        primaryXAxis: CategoryAxis(
            isVisible: true,
            title: AxisTitle(
                text: "Today",
                textStyle: TextStyle(
                    color: AppColors.onBg.withOpacity(0.6), fontSize: 10))),
        series: [
          ColumnSeries<Data, int>(
            animationDuration: 2000,
            gradient: LinearGradient(colors: [
              AppColors.primary.withOpacity(0.6),
              AppColors.primary
            ]),
            isTrackVisible: false,
            dataSource: testData,
            isVisible: true,
            xValueMapper: (Data transaction, _) =>
                // TrendFunction().activeTab.value ==
                //         'This Month'
                //     ? ('${transaction.id!.date.toString()}')
                (transaction.rate),
            yValueMapper: (Data transaction, _) => transaction.rate,
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.outer,
                //color: Colors.black,
                textStyle: TextStyle(color: AppColors.onBg)),
            enableTooltip: false,
          )
        ],
      ),
    );
  }
}

class Data {
  int? rate;
  double totalTransactionCount;

  Data({
    required this.rate,
    required this.totalTransactionCount,
  });
}

final List<Data> testData = [
  Data(rate: 100, totalTransactionCount: 10),

  // Add more data points as needed
];
