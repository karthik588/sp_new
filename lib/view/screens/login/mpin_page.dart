import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:swinpay/functions/login/login_function.dart';
import 'package:swinpay/functions/login/mpin_page_function.dart';
import 'package:swinpay/functions/login/otp_page_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/screens/login/login_page.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../functions/form_validator.dart';
import '../../../functions/sslEncryptionFunction.dart';
import '../../../global/app_string.dart';
import 'confirm_mpin_page.dart';

class MpinPage extends StatefulWidget {
  final bool isChangeMpin;
  final bool isLoginFlow;

  const MpinPage(
      {super.key, this.isChangeMpin = false, this.isLoginFlow = false});

  @override
  State<MpinPage> createState() => _MpinPageState();
}

class _MpinPageState extends State<MpinPage> {
  @override
  void initState() {
    MpinPageFunction().clearFields();
    super.initState();
  }

  var defaultPinTheme = PinTheme(
    margin: const EdgeInsets.all(5),
    width: 30,
    height: 30,
    textStyle: TextStyle(
      fontSize: 20,
      color: MpinPageFunction().isCircleFilled.value
          ? AppColors.primary
          : Colors.transparent,
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
    return WillPopScope(
      onWillPop: () async {
        Get.to(const LoginPage());

        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(children: [
              _body(),
            ]),
          ),
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
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                    widget.isChangeMpin
                        ? AppString().changeMpinText
                        : AppString().mpinText,
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

  // Widget _mpinField() {
  Widget _pipputField() {
    return Pinput(
      inputFormatters: [
        FormValidator.inputIntNumOnly,
        FormValidator.inputLenLimit(len: 4)
      ],
      keyboardType: TextInputType.number,
      autofocus: true,
      controller: MpinPageFunction().mpin,
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
      onCompleted: (pin) async {
        if (pin.length == 4) {
          var otpEnc = await AESEncryptor.encrypt(pin) ?? '';

          MpinPageFunction().isCircleFilled(true);
          if (widget.isLoginFlow) {
            OtpPageFunction().login(
                mobile: LoginFunction().mobileNumber.text.isEmpty
                    ? LoginFunction().user.value.userMobile!
                    : LoginFunction().mobileNumber.text,
                password: otpEnc,
                isNormalFlow: true);
          } else {
            LoginFunction().validateMpin(password: pin);
            // Get.to(ConfirmMpinPage(isChangeMpin: false));
          }
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
