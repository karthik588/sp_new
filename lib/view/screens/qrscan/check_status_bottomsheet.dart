import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/dashboard_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_util.dart';

import '../../../global/app_icons.dart';
import '../../../global/app_string.dart';
import '../../widgets/buttons.dart';
import '../../widgets/shapes.dart';

class CheckStatusBottomSheet {
  CheckStatusBottomSheet._privateConstructor();

  static final CheckStatusBottomSheet _instance =
      CheckStatusBottomSheet._privateConstructor();

  factory CheckStatusBottomSheet() {
    return _instance;
  }

  void show() => Get.bottomSheet(_body(),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: Shapes().cardRoundedBorder(tl: 30, tr: 30));

  Widget _body() {
    return IntrinsicHeight(
        child: Column(
      children: [
        _payment(),
      ],
    ));
  }

  Widget _payment() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: Shapes()
          .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
      child: Column(
        children: [
          Row(
            children: [
              Text(AppString().checkStatus,
                  style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                      color: AppColors.onBg, fontWeight: FontWeight.w800)),
            ],
          ),
          Divider(
            color: AppColors.onBg.withOpacity(0.2),
          ),
          _paymentHeader(),
          Divider(
            color: AppColors.onBg.withOpacity(0.2),
          ),
          _paymentBody(),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: _homeButton(),
          ),
        ],
      ),
    );
  }

  Widget _paymentHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 55,
          width: 55,
          child: Image.asset(
            AppIcons.getIcon(
                status: DashboardFunction()
                    .dynamicQrStatus
                    .value
                    .data!
                    .transactionStatus
                    .toString()),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
            AppString.getPaymentStatusText(
                status: DashboardFunction()
                    .dynamicQrStatus
                    .value
                    .data!
                    .transactionStatus
                    .toString()),
            style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
                color: AppColors.getStatusColor(
                    status: DashboardFunction()
                        .dynamicQrStatus
                        .value
                        .data!
                        .transactionStatus
                        .toString()),
                fontWeight: FontWeight.w800,
                fontSize: 25)),
        const SizedBox(
          height: 15,
        ),
        Text(
            DashboardFunction().dynamicQrStatus.value.data!.date != null
                ? CommonFunctions().dateFormatDMYHMSA(DashboardFunction()
                    .dynamicQrStatus
                    .value
                    .data!
                    .date
                    .toString())
                : '-',
            style: Theme.of(Get.context!)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.onBg.withOpacity(0.6))),
        Text(
            '${AppUtil.currency} ${CommonFunctions().convertToDouble(value: DashboardFunction().dynamicQrStatus.value.data!.amount)}',
            style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
                color: AppColors.onBg,
                fontWeight: FontWeight.w600,
                fontSize: 35)),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _paymentBody() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(AppString().paymentDetails,
                    style: Theme.of(Get.context!)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.onBg, fontSize: 20)),
              ],
            ),
            _detailsView(
                title: AppString().from,
                subtitle: DashboardFunction()
                        .dynamicQrStatus
                        .value
                        .data!
                        .merchantName ??
                    '-'),
            _detailsView(
                title: AppString().utrNo,
                subtitle: DashboardFunction()
                        .dynamicQrStatus
                        .value
                        .data!
                        .bankRefNumber ??
                    '=='),
            _detailsView(
                title: '${AppString().orderId} :',
                subtitle: DashboardFunction()
                        .dynamicQrStatus
                        .value
                        .data!
                        .additionalData!
                        .invoiceNumber ??
                    '=='),
            _detailsView(
                title: '${AppString().transId} :',
                subtitle: DashboardFunction()
                        .dynamicQrStatus
                        .value
                        .data!
                        .transactionId
                        .toString() ??
                    '=='),
          ],
        ));
  }

  Widget _detailsView({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                    color: AppColors.onBg,
                  )),
          Text(subtitle,
              style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                    color: AppColors.onBg,
                  )),
        ],
      ),
    );
  }

  Widget _homeButton() {
    return SizedBox(
      width: double.infinity,
      child: Buttons().raisedButton(
          buttonText: AppString().home,
          onTap: () {
            Get.back();
            Get.back();
            DashboardFunction()
                .filterTransactionHistory(
                    selectedStatus: DashboardFunction()
                        .selectedFilterValInDashboard
                        .join(','))
                .asStream();
          }),
    );
  }
}
