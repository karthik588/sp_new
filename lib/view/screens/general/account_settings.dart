import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/view/screens/general/terms_and_condition.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../global/app_icons.dart';
import '../../../global/app_string.dart';
import '../login/mpin_page.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  void initState() {
    if (AppUtil.htmlData.isEmpty) {
      _loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppString().accountSettings),
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
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 0),
          decoration: Shapes().containerRoundRectBorder(
              allRadius: 30, boxColor: AppColors.card),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if(AppUtil.showMpin)
              _tiles(
                  title: AppString().changeMpin,
                  onTap: () => Get.offAll(const MpinPage(isChangeMpin: true))),
              _tiles(
                  title: AppString().termsAndCondition,
                  onTap: () => Get.to(const TermsAndConditionPage()))
            ],
          )),
    );
  }

  Widget _tiles({required String title, required void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(Get.context!).textTheme.titleSmall!.copyWith(
                        color: AppColors.onBg.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.onBg.withOpacity(0.6),
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: AppColors.onBg.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  void _loadData() async {
    final loadedData = await rootBundle.loadString(AppIcons.termsAndCondition);
    AppUtil.htmlData = loadedData;
  }
}
