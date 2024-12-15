import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/common_functions.dart';
import 'package:swinpay/functions/login/login_function.dart';
import 'package:swinpay/global/app_icons.dart';
import '../../global/app_color.dart';
import '../../global/app_string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    CommonFunctions.closeKeyPad();
    Future.delayed(const Duration(seconds: 3), () async {
      await LoginFunction().checkSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Image.asset(
            AppIcons.splashBg,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                        height: 180,
                        width: 180,
                        child: Image.asset(
                          AppIcons.splashImage,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Container(margin: const EdgeInsets.all(10), child: _bottomUi()),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomUi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppString().poweredBy,
            maxLines: 2,
            style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                  color: AppColors.onBg,
                )),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
            height: 35,
            width: 35,
            child: Image.asset(
              AppIcons.splashBottomImageFirst,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
            height: 35,
            width: 35,
            child: Image.asset(
              AppIcons.splashBottomImageSecond,
              fit: BoxFit.cover,
            )),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
            height: 35,
            width: 35,
            child: Image.asset(
              AppIcons.splashBottomImageThird,
              fit: BoxFit.cover,
            )),
      ],
    );
  }
}
