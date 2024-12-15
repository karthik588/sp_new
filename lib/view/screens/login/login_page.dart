import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/login/login_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import 'package:swinpay/view/widgets/toastMessage.dart';
import '../../../functions/login/otp_page_function.dart';
import '../../../global/app_string.dart';
import '../../../functions/form_validator.dart';
import '../../widgets/buttons.dart';
import '../../widgets/formComponents.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    OtpPageFunction().getCurrentPosition();
   // LoginFunction().getCountry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [
          _loginBody(),
          _loginButton(),
          const SizedBox(height: 25)
        ]),
      ),
    );
  }

  Widget _loginBody() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 100, bottom: 50),
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
            Text(AppString().enterMobNumber,
                maxLines: 2,
                style: Theme.of(Get.context!).textTheme.titleLarge!.copyWith(
                    color: AppColors.onBg, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _mobileField(),
          ],
        ),
      ),
    );
  }

  Widget _mobileField() {
    return FormComponents().textField(
      onChanged: (val) {
        if (val.isNotEmpty && val.length == 10) {
          CommonFunctions.closeKeyPad();
        }
      },
      title: AppString().mobNumberText,
      keyboardType: TextInputType.number,
      controller: LoginFunction().mobileNumber,
      focusedBorderColor: AppColors.primary,
      autoValidateMode: AutovalidateMode.disabled,
      fillColor: Colors.transparent,
      inputFormatter: [
        FormValidator.inputIntNumOnly,
        FormValidator.inputLenLimit(len: 10)
      ],
    );
  }

  Widget _loginButton() {
    return SizedBox(
      width: double.infinity,
      child: Buttons().raisedButton(
          buttonText: AppString().proceed, onTap: () => _onTapLogin()),
    );
  }

  void _onTapLogin() {
    var isError = FormValidator()
        .validateMobileNumber(val: LoginFunction().mobileNumber.text);
    if (isError == null) {
      LoginFunction()
          .validateCountryCode(mobile: LoginFunction().mobileNumber.text);
    } else {
      ToastMessage().showToast(content: isError);
    }
  }
}
