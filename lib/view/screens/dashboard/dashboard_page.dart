import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

//import 'package:screenshot/screenshot.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/login/otp_page_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/models/backend/filterHistoryModel.dart';
import 'package:swinpay/view/screens/Sales/salsesPage.dart';
import 'package:swinpay/view/screens/dashboard/moreSheet.dart';
import 'package:swinpay/view/screens/dashboard/sideDrawer.dart';
import 'package:swinpay/view/screens/general/notifications_screen.dart';
import 'package:swinpay/view/screens/general/payment_link_page.dart';
import 'package:swinpay/view/screens/splash_screen.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../functions/dashboard_function.dart';
import '../../../main.dart';
import '../../../models/uiModels.dart';
import '../transactions/transaction_details.dart';
import 'cash_mode_prompt.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  static const _headerStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DashboardFunction().selectedFilterValInDashboard.clear();
      _init();
      DashboardFunction().scrollController.addListener(() {
        _scrollListner();
      });
    });
    super.initState();
  }

  Future<void> _init() async {
    if (AppUtil.terminalId.isEmpty) {
      await DashboardFunction().getQRCodeInfo();
    }
    await DashboardFunction().onRefresh();
  }

  Future<void> _scrollListner() async {
    if (DashboardFunction().scrollController.position.pixels ==
        DashboardFunction().scrollController.position.maxScrollExtent) {
      if (DashboardFunction().salesData.value.txnCount > 15 &&
          DashboardFunction().transactionList.length !=
              DashboardFunction().salesData.value.txnCount) {
        DashboardFunction().pageNumber = DashboardFunction().pageNumber + 1;
        DashboardFunction().filterTransactionHistory(
            isFromScroll: true,
            pageNo: DashboardFunction().pageNumber,
            selectedStatus:
                DashboardFunction().selectedFilterValInDashboard.join(','));
      }
    }
  }

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
    // BottomBarModel(
    //     icon: Icons.credit_card_rounded,
    //     onTap: () => Get.to(const PaymentLinkPage()),
    //     text: AppString().paymentLink),
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

  final _tableHeader = [
    TableModel(text: AppString().time, style: DashBoardPage._headerStyle),
    TableModel(text: AppString().amount, style: DashBoardPage._headerStyle),
    TableModel(text: AppString().paidBy, style: DashBoardPage._headerStyle),
    TableModel(text: AppString().status, style: DashBoardPage._headerStyle),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      DashboardFunction().selectedFilterValInDashboard.clear();
    });
    return Scaffold(
        key: _scaffoldKey,
        drawer: SideDrawer(),
        body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async =>
                  await DashboardFunction().onRefresh(isOnRefresh: true),
              child: GestureDetector(
                  onVerticalDragUpdate: (details) async {
                    if (details.primaryDelta! > 5) {
                      _refreshIndicatorKey.currentState?.show();
                    }
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                _header(),
                                const SizedBox(height: 10),
                                Expanded(child: _body()),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _bottomBar(),
                    ],
                  )),
            )));
  }

  Widget _header() => Row(
        children: [
          Expanded(child: _profile()),
          InkWell(
            onTap: () => Get.to(const NotificationScreen()),
            child: Icon(
              Icons.notifications_none,
              size: 30,
              color: AppColors.onBg,
            ),
          ),
          // const SizedBox(width: 23\),
          // Buttons().raisedButton(
          //     buttonText: AppString().punchOut,
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //     onTap: () => CheckOutPrompt().show()),
        ],
      );

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
                  DashboardFunction().dashBoardInfo.value.data!.storeName ?? '',
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
                  : _bodyTable()),
        ],
      )));

  Widget _bodyHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppString().sales,
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Buttons().paymentStatusBtn(
                      selectedFilterVal:
                          DashboardFunction().selectedFilterValInDashboard,
                      onTapApply: () {
                        DashboardFunction().transactionList.clear();
                        DashboardFunction().pageNumber = 0;
                        DashboardFunction().filterTransactionHistory(
                            pageNo: 0,
                            selectedStatus: DashboardFunction()
                                .selectedFilterValInDashboard
                                .join(','));
                      }),
                ),
                InkWell(
                  onTap: () => Get.to(() => SalesPage(onBack: () => _init())),
                  child: Text(AppString().viewAll,
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                DashboardFunction().salesData.value.transactionInfo ??
                    AppString().today,
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    _titleText(AppString().noOfSales),
                    const SizedBox(height: 0),
                    Text(
                        DashboardFunction().salesData.value.txnCount.toString(),
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    _titleText(AppString().totalAmount),
                    const SizedBox(height: 2),
                    Text(
                        '${AppUtil.currency}${CommonFunctions().convertToDouble(value: DashboardFunction().salesData.value.total)}',
                        style: TextStyle(
                            color: Colors.yellow.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ],
                ))
              ],
            )
          ],
        ),
      );

  Widget _titleText(String text) => Text(text,
      style: TextStyle(
          color: AppColors.onBg.withOpacity(0.7),
          fontWeight: FontWeight.w300,
          fontSize: 14));

  Widget _bodyTable() => Column(
        children: [
          Visibility(
              visible: !DashboardFunction().isinitLoading.value,
              child: _tableRows(data: _tableHeader)),
          const SizedBox(height: 5),
          Obx(() => Expanded(
                child: ListView.separated(
                  controller: DashboardFunction().scrollController,
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
          Obx(() => DashboardFunction().isSalesLoading.value
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
          padding: const EdgeInsets.only(top: 10, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_bottomData.length,
                (index) => Buttons().bottomBtn(data: _bottomData[index])),
          ),
        ),
      );
}

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
          gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.6), AppColors.primary]),
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
