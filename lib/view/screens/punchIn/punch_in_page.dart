import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/view/screens/dashboard/dashboard_page.dart';
import '../../../global/app_color.dart';
import '../../../global/app_string.dart';
import '../../widgets/buttons.dart';

class PunchInScreen extends StatelessWidget {
  const PunchInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            _titleText(),
            _punchInButton(),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _titleText() {
    return Expanded(
      child: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(AppString().punchIn,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Theme.of(Get.context!)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(
            height: 150,
          ),
          _punchInImage()
        ],
      ),
    );
  }

  Widget _punchInImage() {
    return Image.network(
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbiPG7g5TndL5k-GcykR34EmsIvcW1u2ReIw&usqp=CAU',
    );
  }

  Widget _punchInButton() {
    return SizedBox(
      width: double.infinity,
      child: Buttons().raisedButton(
          buttonText: AppString().punchIn,
          onTap: () {
            Get.to(const DashBoardPage());
          }),
    );
  }
}
