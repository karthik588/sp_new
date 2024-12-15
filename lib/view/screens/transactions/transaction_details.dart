

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/widgets/shapes.dart';

import '../../../global/app_icons.dart';
import '../../../global/app_string.dart';
import '../../../models/backend/filterHistoryModel.dart';

class TransactionDetailsPage extends StatelessWidget {
  final TransactionListElement tranDetail;
  const TransactionDetailsPage({super.key, required this.tranDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [
          _payment(),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }

  Widget _payment() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          top: 20,
        ),
        padding: const EdgeInsets.all(15),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: Column(
          children: [
            _paymentHeader(),
            Divider(
              color: AppColors.onBg,
              thickness: 0.3,
            ),
            _paymentBody(),
          ],
        ),
      ),
    );
  }

  Widget _paymentHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 50,
          width: 50,
          child: Image.asset(
            AppIcons.getIcon(status: tranDetail.transactionStatus.toString()),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
            AppString.getPaymentStatusText(
                status: tranDetail.transactionStatus.toString()),
            style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
                color: AppColors.getStatusColor(

                    status: tranDetail.transactionStatus.toString()),
                fontWeight: FontWeight.w800,fontSize: 25)),
        const SizedBox(
          height: 12,
        ),
        Text(CommonFunctions().dateFormatDMYHMSA(tranDetail.date.toString()),
            style: Theme.of(Get.context!)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.onBg.withOpacity(0.6))),
        Text('${AppUtil.currency}${CommonFunctions().convertToDouble(value:tranDetail.amount)}',
            style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
                color: AppColors.onBg,
                fontWeight: FontWeight.w800,
                fontSize: 35)),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _paymentBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(AppString().paymentDetails,
                style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                      color: AppColors.onBg,
                  fontSize: 20
                    )),
          ],
        ),
        _detailsView(
            title: AppString().from, subtitle: tranDetail.customerName ?? '--'),
        _detailsView(
            title: AppString().utrNo, subtitle: tranDetail.bankref ?? '--'),
        _detailsView(
            title:'${AppString().orderId} :', subtitle: tranDetail.orgTxnId ?? '--'),
        _detailsView(
            title: '${AppString().transId} :',
            subtitle: tranDetail.transactionId ?? '--'),
        _detailsView(title:'${AppString().remarks} :', subtitle: '--'),
      ],
    );
  }

  Widget _detailsView({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                    color: AppColors.onBg.withOpacity(0.6),
                  )),
          const SizedBox(
            height: 5,
          ),
          Text(subtitle,
              style: Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                    color: AppColors.onBg,
                  )),
        ],
      ),
    );
  }
}
