import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/dashboard_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../global/app_string.dart';
import '../../../functions/form_validator.dart';
import '../../widgets/buttons.dart';
import '../../widgets/formComponents.dart';

class PaymentLinkPage extends StatefulWidget {
  const PaymentLinkPage({super.key});

  @override
  State<PaymentLinkPage> createState() => _PaymentLinkPageState();
}

class _PaymentLinkPageState extends State<PaymentLinkPage> {
  @override
  void initState() {
    DashboardFunction().amount.clear();
    DashboardFunction().mobile.clear();
    DashboardFunction().isPaymentLInkLoading(false);
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppString().paymentLink),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(children: [
            _paymentBody(),
            _submitButton(),
            const SizedBox(
              height: 20,
            )
          ]),
        ),
      ),
    );
  }

  Widget _paymentBody() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 20, bottom: 20),
        padding: const EdgeInsets.all(15),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            _amountField(),
            const SizedBox(
              height: 30,
            ),
            _mobileField()
          ],
        ),
      ),
    );
  }

  Widget _mobileField() {
    return FormComponents().textField(
        focusedBorderColor: AppColors.primary,
        title: AppString().mobNumberText,
        keyboardType: TextInputType.number,
        controller: DashboardFunction().mobile,
        inputFormatter: [
          FormValidator.inputIntNumOnly,
          FormValidator.inputLenLimit(len: 10)
        ],
        validator: (val) => FormValidator().validateMobileNumber(val: val));
  }

  Widget _amountField() {
    return FormComponents().textField(
        focusedBorderColor: AppColors.primary,
        title: AppString().amount,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: DashboardFunction().amount,
        inputFormatter: [
          FormValidator.inputDecimalWithPlaces(),
          FormValidator.inputLenLimit(len: 12)

        ],
        validator: (val) => FormValidator()
            .isEmpty(text: val, errorMsg: AppString().amountVal));
  }

  Widget _submitButton() {
    return SizedBox(
        width: double.infinity,
        child: Obx(
          () => Buttons().raisedButton(
              isLoading: DashboardFunction().isPaymentLInkLoading.value,
              buttonText: AppString().sendPaymentLInk,
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  await DashboardFunction().sendPayemntLink();
                  Navigator.pop(Get.context!);
                }
              }),
        ));
  }
}
