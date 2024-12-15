import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import 'package:swinpay/view/widgets/shapes.dart';

import '../../../functions/form_validator.dart';
import '../../widgets/formComponents.dart';

class CashModePrompt {
  CashModePrompt._privateConstructor();

  static final CashModePrompt _instance = CashModePrompt._privateConstructor();

  factory CashModePrompt() {
    return _instance;
  }

  final formKey = GlobalKey<FormState>();

  void show(
          {required Function onTapContinue,
          required TextEditingController controller}) =>
      Get.dialog(
        barrierColor: Colors.black87,
        _body(onTapContinue: onTapContinue, controller: controller),
        barrierDismissible: false,
      );

  Widget _body(
          {required Function onTapContinue,
          required TextEditingController controller}) =>
      AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Card(
            margin: const EdgeInsets.all(0),
            shape: Shapes().cardRoundedBorder(allRadius: 15),
            color: AppColors.card,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(width: double.infinity,
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () => Navigator.pop(Get.context!),
                          icon: Icon(
                            Icons.cancel,
                            color: AppColors.onBg.withOpacity(0.5),
                          ))),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: FormComponents().textField(
                        focusedBorderColor: AppColors.primary,
                        title: AppString().amount,
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatter: [
                          FormValidator.inputDecimalWithPlaces(),
                          FormValidator.inputLenLimit(len: 12)
                        ],
                        validator: (val) => FormValidator().isEmpty(
                            text: val, errorMsg: AppString().amountVal)),
                  ),
                  const SizedBox(height: 35),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Buttons().raisedButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        buttonText: AppString().continueText,
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            onTapContinue();
                          }
                        }),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ));
}
