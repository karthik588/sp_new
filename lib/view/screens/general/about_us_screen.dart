import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_icons.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../global/app_string.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppString().aboutUs),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [
          Expanded(child: _outerBody()),
          Text(
            '${AppString().version} ${AppUtil.appVersion}',
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                  color: AppColors.onBg,
                ),
          ),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              AppString().aboutUsContent,
              maxLines: 500,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                    color: AppColors.onBg.withOpacity(0.6),
                  ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _outerBody() {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: Shapes()
          .containerRoundRectBorder(allRadius: 30, boxColor: AppColors.card),
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 120,
          width: 130,
          child: Image.asset(
            AppIcons.splashBottomImageFirst,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Divider(
          color: AppColors.onBg.withOpacity(0.2),
        ),
        _body(),
      ]),
    );
  }
}
