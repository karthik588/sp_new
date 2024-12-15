import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/dashboard_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import 'package:swinpay/view/widgets/shapes.dart';

import '../../../functions/form_validator.dart';
import '../../widgets/formComponents.dart';

class CheckStatusPrompt {
  CheckStatusPrompt._privateConstructor();

  static final CheckStatusPrompt _instance =
      CheckStatusPrompt._privateConstructor();

  factory CheckStatusPrompt() {
    return _instance;
  }

  final statusFormKey = GlobalKey<FormState>();

  void show() => Get.dialog(
        barrierColor: Colors.black87,
        _body(),
        barrierDismissible: false,
      );

  Widget _body() => AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        backgroundColor: AppColors.card,
        content: Card(
            margin: const EdgeInsets.all(0),
            shape: Shapes().cardRoundedBorder(allRadius: 15),
            color: AppColors.card,
            child: Form(
              key: statusFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          color: AppColors.onBg.withOpacity(0.5),
                          onPressed: () => Navigator.pop(Get.context!),
                          icon: const Icon(Icons.cancel))),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FormComponents().textField(
                        focusedBorderColor: AppColors.primary,
                        title: AppString().amount,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        controller: DashboardFunction().amount,
                        inputFormatter: [
                          FormValidator.inputDecimalWithPlaces(),
                          FormValidator.inputLenLimit(len: 12)

                        ],
                        validator: (val) => FormValidator().isEmpty(
                            text: val, errorMsg: AppString().amountVal)),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FormComponents().textField(
                        focusedBorderColor: AppColors.primary,
                        title: AppString().utrNum,
                        keyboardType: TextInputType.number,
                        controller: DashboardFunction().utrNo,
                        inputFormatter: [
                          FormValidator.inputLenLimit(len: 12),
                          FormValidator.inputIntNumOnly
                        ],
                        validator: (val) => FormValidator()
                            .isEmpty(text: val, errorMsg: AppString().utrVal)),
                  ),
                  const SizedBox(height: 45),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Buttons().raisedButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        buttonText: AppString().continueText,
                        onTap: () async {
                          if (statusFormKey.currentState!.validate()) {
                            Navigator.pop(Get.context!);
                            await DashboardFunction().checkPaymentStatus(
                                isDynamicStatusCheck: false,
                                utr: DashboardFunction().utrNo.text,
                                amount: DashboardFunction().amount.text);
                          }
                          // Get.to(DashBoardPage());
                        }),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            )),
      );
}
