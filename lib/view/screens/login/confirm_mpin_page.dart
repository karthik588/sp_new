import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../functions/login/mpin_page_function.dart';
import '../../../global/app_string.dart';
import '../../../functions/form_validator.dart';
import '../punchIn/punch_in_page.dart';

class ConfirmMpinPage extends StatelessWidget {
  final bool isChangeMpin;
  ConfirmMpinPage({super.key, this.isChangeMpin = false});
  var defaultPinTheme = PinTheme(
    margin: const EdgeInsets.all(5),
    width: 30,
    height: 30,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.transparent,
    ),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: MpinPageFunction().isCircleFilled.value
            ? AppColors.primary
            : AppColors.onBg,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(children: [
            _body(),
          ]),
        ),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.lock_open_outlined,
                  color: AppColors.primary,
                  size: 40,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                    isChangeMpin ? AppString().mpinText : AppString().cnfrmMpin,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(Get.context!)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.onBg.withOpacity(0.9))),
                const SizedBox(
                  height: 30,
                ),
                _pipputField(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pipputField() {
    return Pinput(
      inputFormatters: [
        FormValidator.inputIntNumOnly,
        FormValidator.inputLenLimit(len: 4)
      ],
      keyboardType: TextInputType.number,
      autofocus: true,
      controller: MpinPageFunction().confirmMpin,
      closeKeyboardWhenCompleted: true,
      obscureText: true,
      length: 4,
      submittedPinTheme: defaultPinTheme.copyWith(
        textStyle: TextStyle(
            fontSize: 20,
            color: MpinPageFunction().isCircleFilled.value
                ? Colors.transparent
                : Colors.transparent),
        decoration: defaultPinTheme.decoration!.copyWith(
          color: AppColors.primary, // Set the fill color to primary
          border: Border.all(color: AppColors.primary),
        ),
      ),
      separatorBuilder: (index) => const SizedBox(width: 8),
      hapticFeedbackType: HapticFeedbackType.disabled,
      onCompleted: (pin) {
        if (pin.length == 4) {
          MpinPageFunction().isCircleFilled(true);
          Get.to(const PunchInScreen());
        }
      },
      focusedPinTheme: defaultPinTheme.copyWith(
        textStyle: TextStyle(fontSize: 20, color: AppColors.onBg),
        decoration: defaultPinTheme.decoration!.copyWith(
          color: AppColors.onBg,
          border: Border.all(
            color: AppColors.onBg,
          ),
        ),
      ),
      defaultPinTheme: defaultPinTheme.copyWith(
        textStyle: const TextStyle(fontSize: 20, color: Colors.transparent),
        decoration: defaultPinTheme.decoration!.copyWith(
          color: AppColors.onBg, // Set the fill color to primary
          border: Border.all(color: AppColors.onBg),
        ),
      ),
    );
  }
}
