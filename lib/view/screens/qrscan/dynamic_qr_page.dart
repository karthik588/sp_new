import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/dashboard_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../global/app_icons.dart';
import '../../../global/app_string.dart';
import '../../widgets/buttons.dart';
import 'check_status_bottomsheet.dart';

class DynamicQrScreen extends StatefulWidget {
  final String amount;
  final String invoiceNo;
  const DynamicQrScreen(
      {super.key, required this.amount, required this.invoiceNo});

  @override
  State<DynamicQrScreen> createState() => _DynamicQrScreenState();
}

class _DynamicQrScreenState extends State<DynamicQrScreen> {
  final RxInt _secondsRemaining = 120.obs; // Total seconds for countdown
  int get secondsRemaining => _secondsRemaining.value;
  double get progress => _secondsRemaining.value / 120;
  Timer? _timer;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        timer.cancel();
        Navigator.pop(Get.context!);
        DashboardFunction().transactionList.clear();
        DashboardFunction().filterTransactionHistory(pageNo: 0);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(AppString().qr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(children: [
          _body(),
          _checkStatusButton(),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: qrBody(),
      ),
    );
  }

  Widget qrBody() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _qrHeader(),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 38),

                  child: Center(child: _qrCode())),
              const SizedBox(
                height:30,
              ),
              if (secondsRemaining >
                  0) // Show progress bar only if countdown is not zero
                Obx(() => Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            color: AppColors.onBg.withOpacity(0.4),
                          ),
                          Text(
                            secondsRemaining.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onBg.withOpacity(0.7)),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
        _bottomText(),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget _qrHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Text(AppString().totalAmount,
            style: Theme.of(Get.context!)
                .textTheme
                .titleLarge!
                .copyWith(color: AppColors.onBg.withOpacity(0.6),fontSize: 25)),
        Text(
            '${AppUtil.currency} ${CommonFunctions().convertToDouble(value: widget.amount)}',
            style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
                color: AppColors.onBg,
                fontWeight: FontWeight.w600,
                fontSize: 35)),

      ],
    );
  }

  Widget _qrCode() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 40),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: QrImageView(

            backgroundColor: AppColors.onBg,
            data: DashboardFunction().dynamicQrCodeList.value.data!.qrStringData ??
                '',
            version: 12,
            size: 250.0,
          ),
        ),
      ),
    );
  }

  Widget _checkStatusButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: Obx(
          () => Buttons().raisedButton(
              isLoading: DashboardFunction().isPaymentStatusCheckLoading.value,
              buttonText: AppString().checkStatus,
              onTap: () async {
                _timer?.cancel();
                await DashboardFunction().checkPaymentStatus(
                    amount: widget.amount,
                    utr: '',
                    invoiceNo: widget.invoiceNo,
                    isDynamicStatusCheck: true);

                Future.delayed(const Duration(milliseconds: 5), () {
                  CheckStatusBottomSheet().show();
                });
              }),
        ));
  }

  Widget _bottomText() {
    return Column(
      children: [
        Text(AppString().scanQrText,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
              fontSize: 14,
                  color: AppColors.onBg.withOpacity(0.6),
                )),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Image.asset(
                  AppIcons.svgPhonePay,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgGpay,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgWhatsApp,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgPaytm,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgFreeCharge,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgMobiKwik,
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgAmazonPay,
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
