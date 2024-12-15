import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/view/screens/Sales/salsesPage.dart';
import 'package:swinpay/view/screens/general/about_us_screen.dart';
import 'package:swinpay/view/screens/general/account_settings.dart';
import 'package:swinpay/view/screens/general/contact_us_screen.dart';

import '../../../functions/login/otp_page_function.dart';
import '../../../global/app_util.dart';
import '../qrscan/static_qr_screen.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({Key? key}) : super(key: key);

  final _data = [
    SideDrawerModel(
        text: AppString().staticQr,
        onTap: () {
          Navigator.pop(Get.context!);
          Get.to(const StaticQrScreen());
        }),
    SideDrawerModel(
        text: AppString().sales,
        onTap: () {
          Navigator.pop(Get.context!);
          Get.to(const SalesPage());
        }),
    // SideDrawerModel(
    //     text: AppString().attendance,
    //     onTap: () => Get.to(const AttendanceScreen())),
    SideDrawerModel(
        text: AppString().accountSettings,
        onTap: () {
          Navigator.pop(Get.context!);
          Get.to(const AccountSettingsPage());
        }),
    SideDrawerModel(
        text: AppString().aboutUs,
        onTap: () {
          Navigator.pop(Get.context!);
          Get.to(const AboutUsPage());
        }),
    SideDrawerModel(
        text: AppString().contactUs,
        onTap: () {
          Navigator.pop(Get.context!);
          Get.to(const ContactUsPage());
        }),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Drawer(
          shape: const RoundedRectangleBorder(),
          backgroundColor: AppColors.bg,
          child: Column(
            children: [
              Obx(() => Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: AppColors.card,
                  height: 210,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: 100.0, // Adjust the width as needed
                        height: 100.0,
                        child: FadeInImage(
                          placeholder: const AssetImage(''),
                          image: NetworkImage(
                            OtpPageFunction()
                                    .loginData
                                    .value
                                    .data!
                                    .userProfile!
                                    .profileUrl ??
                                '',
                            headers: {
                              'session-token': AppUtil.sessionToken.isNotEmpty
                                  ? AppUtil.sessionToken
                                  : '',
                              'device-id': AppUtil.deviceId.isNotEmpty
                                  ? AppUtil.deviceId
                                  : '',
                            },
                          ),
                        ),
                      ),
                    ],
                  ))),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20),
                    itemCount: _data.length,
                    itemBuilder: (context, index) => ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          title: Text(
                            _data[index].text,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onBg),
                          ),
                          onTap: () => _data[index].onTap(),
                        )),
              )
            ],
          )),
    );
  }
}

class SideDrawerModel {
  Function onTap;
  String text;

  SideDrawerModel({required this.onTap, required this.text});
}
