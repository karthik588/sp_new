import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_icons.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/screens/splash_screen.dart';
import 'package:swinpay/view/widgets/shapes.dart';

import '../../../functions/dashboard_function.dart';
import '../../../functions/login/otp_page_function.dart';
import '../../../global/app_string.dart';

import '../../../main.dart';
import '../../widgets/buttons.dart';

class StaticQrScreen extends StatefulWidget {
  const StaticQrScreen({super.key});

  @override
  State<StaticQrScreen> createState() => _StaticQrScreenState();
}

class _StaticQrScreenState extends State<StaticQrScreen> {
  static const platform = MethodChannel('com.swinkpayfintech.merchant/restart');

  @override
  void initState() {
    DashboardFunction().getStaticQr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          centerTitle: false,
          elevation: 0,
          title: Text(AppString().staticQr),
        ),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(children: [

              _body(),
              _downloadButton(),
              const SizedBox(
                height: 20,
              )
            ]),
          ),
        ));
  }

  Widget _body() {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5, bottom: 10),
        decoration: Shapes()
            .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
        child: qrBody(),
      ),
    );
  }

  Widget qrBody() {
    return Screenshot(
        controller: DashboardFunction().screenshotController,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: Shapes().containerRoundRectBorder(
              allRadius: 20, boxColor: AppColors.onBg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _qrHeader(),
              Expanded(
                child: Column(
                  children: [

                    const SizedBox(
                      height: 1,
                    ),
                    const Text('Scan and Pay',style: TextStyle(
                      color: Colors.black,
                        fontSize: 25,
                    ),),
                    Spacer(),
                    _qrCode(),
                    Spacer(),
                  ],
                ),
              ),
              _bottomCompanyLogoUi(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  Widget _icons() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 185,
                height: 50,
                child: Image.asset(
                  AppIcons.svgUpi,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  AppIcons.svgPaytm,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgGpay,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgPhonePay,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: Image.asset(
                  AppIcons.svgAmazonPay,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _qrHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 90,
          width: 90,
          child: FadeInImage(
            placeholder: const AssetImage(''),
            image: NetworkImage(
              OtpPageFunction()
                      .loginData
                      .value
                      .data!
                      .userProfile!
                      .profileUrl
                      .toString() ??
                  '',
              headers: {
                'session-token':
                    AppUtil.sessionToken.isNotEmpty ? AppUtil.sessionToken : '',
                'device-id':
                    AppUtil.deviceId.isNotEmpty ? AppUtil.deviceId : '',
              },
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _qrCode() {
    return Stack(alignment: Alignment.center, children: [
      Image.asset(AppIcons.rectImage),
      Visibility(
        visible: DashboardFunction()
            .staticQrCodeList
            .value
            .data!
            .qrStringData!
            .isNotEmpty,
        child: QrImageView(
          backgroundColor: AppColors.onBg,
          data: DashboardFunction().staticQrCodeList.value.data!.qrStringData!,
          version: 8,
          size: 180.0,
        ),
      ),
      Visibility(
        visible: DashboardFunction()
            .staticQrCodeList
            .value
            .data!
            .qrStringData!
            .isNotEmpty,
        child: Positioned(
          top: 15,
          child: Text(
              '${DashboardFunction().dashBoardInfo.value.data!.outletId.toString()}-${DashboardFunction().staticQrCodeList.value.data!.terminalName!}',
              style: TextStyle(
                  color: AppColors.bg,
                  fontWeight: FontWeight.w800,
                  fontSize: 12)),
        ),
      )
    ]);
  }

  Widget _downloadButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Buttons().raisedButton(
          buttonText: AppString().downloadQr,
          onTap: () => DashboardFunction().downloadQr()),
    );
  }

  Widget _bottomCompanyLogoUi() {
    return Column(
      children: [
        _icons(),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Text(AppString().poweredBy,
                  maxLines: 1,
                  style: const TextStyle(
                  fontSize: 8,
                  color: Colors.black, fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  AppIcons.splashBottomImageFirst,
                  fit: BoxFit.cover,
                )),
            const SizedBox(
              width: 5,
            ),
            //airtel payment bank logo
            // SizedBox(
            //     height: 60,
            //     width: 60,
            //     child: Image.asset(
            //       AppIcons.splashBottomImageSecond,
            //       fit: BoxFit.cover,
            //     )),
          ],
        ),
      ],
    );
  }
}
