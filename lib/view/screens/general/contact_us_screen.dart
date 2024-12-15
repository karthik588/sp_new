import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/functions/general/contact_us_function.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../global/app_string.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppString().contactUs),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [
          _body(),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }

  Widget _body() {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(
              top: 15,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: Shapes().containerRoundRectBorder(
                allRadius: 30, boxColor: AppColors.card),
            child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                AppString().contactus,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                      color: AppColors.onBg.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () => ContactFunction().sendEmail(
                      recipients: ['mmsrecon@swinkpay-fintech.com']),
                child: _tile(
                    icon: Icons.mail_outline_outlined,
                    text: 'mmsrecon@swinkpay-fintech.com',
                    onTap: () => ContactFunction().sendEmail(
                        recipients: ['mmsrecon@swinkpay-fintech.com'])),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () => ContactFunction().call(number: '080 4123 3230'),
                  child: _tile(
                    icon: Icons.call,
                    text: '080-4123 3230',
                    onTap: () => ContactFunction().call(number: '080 4123 3230')),
              )
            ])));
  }

  Widget _tile(
      {required String text,
      required IconData icon,
      required void Function()? onTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.onBg,
              child: Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              )),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                color: AppColors.onBg.withOpacity(0.8),
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
