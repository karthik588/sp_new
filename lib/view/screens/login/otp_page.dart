import 'package:flutter/material.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/login/login_function.dart';
import 'package:swinpay/functions/login/otp_page_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../functions/form_validator.dart';
import '../../../functions/sslEncryptionFunction.dart';
import '../../../global/app_string.dart';

class OtpPage extends StatefulWidget {
  final String mobile;

  const OtpPage({super.key, required this.mobile});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    OtpPageFunction().otpController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FocusScope.of(context).requestFocus(_focusNode);
      if (OtpPageFunction().callGenerateApi()) {
        OtpPageFunction().generateOtp(mobile: widget.mobile);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (val) {
        LoginFunction().mobileNumber.clear();
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
        margin: const EdgeInsets.only(top: 20, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(AppString().verifyPhoneText,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.onBg, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(AppString().otpText,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.onBg.withOpacity(0.6))),
                const SizedBox(
                  height: 2,
                ),
                Text('${AppUtil.countryCode}-${widget.mobile}',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.onBg.withOpacity(0.6))),
                const SizedBox(height: 20),
                _otpField(),
                const SizedBox(height: 20),
                _resendButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpField() {
    return PinCodeTextField(
      focusNode: _focusNode,
      appContext: context,
      autoDisposeControllers: false,
      controller: OtpPageFunction().otpController,
      length: 4,
      keyboardType: TextInputType.number,
      cursorColor: AppColors.onBg,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autoDismissKeyboard: true,
      autoFocus: true,
      inputFormatters: [FormValidator.inputIntNumOnly],
      textStyle: TextStyle(color: AppColors.primary),
      cursorHeight: 0,
      cursorWidth: 0,
      obscureText: true,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.underline,
        fieldHeight: 50,
        fieldWidth: 60,
        activeColor: AppColors.onBg,
        activeFillColor: AppColors.primary,
        inactiveFillColor: AppColors.primary,
        selectedColor: AppColors.onBg,
        selectedFillColor: AppColors.primary,
        inactiveColor: AppColors.onBg,
      ),
      onCompleted: (val) async {
        var otpEnc = await AESEncryptor.encrypt(val) ?? '';

        OtpPageFunction().callGenerateApi()
            ? OtpPageFunction().verifyOtp(mobile: widget.mobile, otp: val)
            : OtpPageFunction().login(
                mobile: widget.mobile, password: otpEnc, isNormalFlow: true);
      },
      validator: (val) =>
          FormValidator().isEmpty(text: val, errorMsg: AppString().otpValText),
    );
  }

  Widget _resendButton() {
    return InkWell(
      onTap: () {
        CommonFunctions.closeKeyPad();
        OtpPageFunction().otpController.clear();
        Future.delayed(const Duration(milliseconds: 10), () {
          OtpPageFunction().generateOtp(mobile: widget.mobile, isResend: true);
        });
      },
      child: Text(AppString().resendOtp,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: AppColors.primary)),
    );
  }
}
