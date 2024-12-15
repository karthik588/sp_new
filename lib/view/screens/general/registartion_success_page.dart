import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/login/login_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/buttons.dart';
import '../../../global/app_string.dart';

class RegistrationSuccessPage extends StatelessWidget {
  const RegistrationSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Icon(
                Icons.check_circle_outline_sharp,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(AppString().done,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(Get.context!)
                        .textTheme
                        .headlineLarge!
                        .copyWith(
                          color: AppColors.primary,
                        )),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(AppString().registrationSuccessMsg,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style:
                        Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
                              color: AppColors.onBg.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                            )),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Buttons().raisedButton(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 12),
                    buttonText: AppString().go,
                    onTap: () {
                      LoginFunction().validateCountryCode(
                          isRegFlow: true,
                          mobile: LoginFunction().mobileNumber.text);
                    }),
              )
            ]),
      ),
    );
  }
}
