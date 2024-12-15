import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';

import '../../functions/general/contact_us_function.dart';

class UserNotRegisteredPrompt {
  UserNotRegisteredPrompt._privateConstructor();

  static final UserNotRegisteredPrompt _instance =
      UserNotRegisteredPrompt._privateConstructor();

  factory UserNotRegisteredPrompt() {
    return _instance;
  }

  void showInvalidUserPrompt() => Get.dialog(
        _body(),
        barrierDismissible: false,
    useSafeArea: false
      );

  Widget _body() => AlertDialog(

        contentPadding: const EdgeInsets.all(0),
        backgroundColor: AppColors.card,
        content: Container(
            width: double.infinity,
            color: AppColors.onBg,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: AppString().registrationErrorText,
                        style: TextStyle(
                          color: AppColors.card.withOpacity(0.6),
                        )),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              ContactFunction().call(number: '08041233230'),
                        text: '080-41233230',
                        style: TextStyle(
                          decorationColor: Colors.black,
                          decoration: TextDecoration.underline,
                          color: AppColors.card.withOpacity(0.8),
                        )),
                    TextSpan(
                        text: '\t${AppString().or}\t',
                        style: const TextStyle(
                          color: Colors.black,
                        )),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => ContactFunction().sendEmail(
                              recipients: ['sdhelpdesk@swinkpay-fintech.com']),
                        text: 'sdhelpdesk@swinkpay-fintech.com',
                        style: const TextStyle(
                          decorationColor: Colors.black,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        )),
                  ])),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(Get.context!),
                          child: Text(AppString().okayCaps,
                              style: const TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            )),
      );
}
