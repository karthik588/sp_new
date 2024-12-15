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
import '../../../models/uiModels.dart';
import '../../widgets/datePicker.dart';

class DashBoardPage2 extends StatefulWidget {
  const DashBoardPage2({Key? key}) : super(key: key);

  static const _headerStyle = TextStyle(fontWeight: FontWeight.bold);

  @override
  State<DashBoardPage2> createState() => _DashBoardPage2State();
}

class _DashBoardPage2State extends State<DashBoardPage2> {
  final Rx<BottomBarModel> _topAction = BottomBarModel().obs;

  final _bottomData = [
    BottomBarModel(
        icon: Icons.qr_code_scanner, onTap: () {}, text: AppString().qr),
    BottomBarModel(
        icon: Icons.credit_card_rounded,
        onTap: () => MoreSheet().show(),
        text: AppString().cash),
    BottomBarModel(
        icon: Icons.add_circle,
        onTap: () => MoreSheet().show(),
        text: AppString().more),
  ];

  _topActions() => [
        BottomBarModel(
            icon: Icons.qr_code_scanner, onTap: () {}, text: AppString().sales),
        BottomBarModel(
            icon: Icons.credit_card_rounded,
            onTap: () {},
            body: _bodyTable(),
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
      _topAction(_topActions()[0]);
    });
    super.initState();
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

  Widget _profile() => Row(
        children: [
          InkWell(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: CircleAvatar(
                backgroundColor: AppColors.onBg.withOpacity(0.1),
                radius: 25,
                backgroundImage: const AssetImage('assets/images/download.png'),
              )),
          const SizedBox(width: 8),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cafe Cofee Day',
                style: TextStyle(
                    color: AppColors.onBg, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              const SizedBox(height: 3),
              Text(
                'company registration address',
                style: TextStyle(
                    color: AppColors.onBg, fontWeight: FontWeight.w300),
                maxLines: 1,
              )
            ],
          ))
        ],
      );

  Widget _body() => Card(
      color: AppColors.card,
      shape: Shapes().cardRoundedBorder(allRadius: 35),
      margin: const EdgeInsets.all(0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          _bodyHeader(),
          const SizedBox(height: 5),
          Divider(color: AppColors.primary),
          const SizedBox(height: 10),
          Obx(() => Expanded(child: _topAction.value.body ?? Container())),
        ],
      ));

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
                    child: Text(AppString().today)),
                Obx(() => Visibility(
                      visible: !(_topAction.value.hideDuration ?? true),
                      child: Positioned(
                        right: 0,
                        child: Buttons()
                            .durationBtn(offset: const Offset(80, 40), data: [
                          BottomBarModel(text: AppString().today),
                          BottomBarModel(text: AppString().yesterday),
                          BottomBarModel(text: AppString().thisWeek),
                          BottomBarModel(text: AppString().thisMonth),
                          BottomBarModel(text: AppString().thisYear),
                          BottomBarModel(
                              text: AppString().customDate,
                              onTap: () => DatePickerUi().datePicker()),
                        ]),
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
                    Text('0',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                  ],
                )),
                Expanded(
                    child: Column(
                  children: [
                    _titleText(AppString().totalAmount),
                    const SizedBox(height: 4),
                    Text(
                        '${AppUtil.currency}${CommonFunctions().convertToDouble(value: '0')}',
                        style: TextStyle(
                            color: Colors.yellow.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
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

  Widget _bodyTable() => Column(
        children: [
          _tableRows(data: _tableHeader),
          const SizedBox(height: 5),
          Expanded(
              child: ListView.separated(
            padding: const EdgeInsets.only(top: 25),
            itemCount: 2,
            itemBuilder: (context, index) => _tableRows(data: [
              TableModel(text: '04:12 pm', style: _tableBodyStyle),
              TableModel(
                  text:
                      '${AppUtil.currency}${CommonFunctions().convertToDouble(value: '230')}',
                  style: _tableBodyStyle),
              TableModel(text: 'Yogish Shenoyshbfcisu', style: _tableBodyStyle),
              TableModel(
                  text: 'Success',
                  style: _tableBodyStyle.copyWith(
                      color: Colors.green.withOpacity(0.7))),
            ]),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 30),
          ))
        ],
      );

  final _tableBodyStyle = TextStyle(
      color: AppColors.onBg.withOpacity(0.7), fontWeight: FontWeight.w300);

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
