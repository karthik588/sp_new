import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';

import '../../../global/app_string.dart';
import '../../widgets/buttons.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        title: Text(AppString().attendance),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [
          _body(),
          const SizedBox(
            height: 15,
          )
        ]),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        _punchInButton(),
        _lastCheckinText(),
        const SizedBox(
          height: 35,
        ),
        _punchOutButton()
      ],
    ));
  }

  Widget _lastCheckinText() =>
      Text('${AppString().lastCheckinMsg} 2023-10-12 12:26:56',
          maxLines: 2,
          style: Theme.of(Get.context!).textTheme.labelMedium!.copyWith(
                color: AppColors.onBg,
              ));

  Widget _punchInButton() {
    return SizedBox(
      width: double.infinity,
      child: Buttons().raisedButton(
        textColor: AppColors.onBg,
        btnColor: AppColors.onBg.withOpacity(0.7),
        onTap: () {},
        buttonText: AppString().punchIn,
      ),
    );
  }

  Widget _punchOutButton() {
    return SizedBox(
      width: double.infinity,
      child: Buttons().raisedButton(
        onTap: () {},
        buttonText: AppString().punchOut,
      ),
    );
  }
}
