import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/view/widgets/shapes.dart';
import '../../../global/app_string.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({super.key});

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  final TextStyle style = TextStyle(
    fontSize: 16,
    color: AppColors.onBg,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(AppString().termsAndCondition),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [
          _body(),
        ]),
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: Shapes().containerRoundRectBorder(
              allRadius: 30, boxColor: AppColors.card),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Html(data: AppUtil.htmlData, style: {
                'body': Style.fromTextStyle(style),
              }),
              const SizedBox(
                height: 40,
              ),
            ],
          )),
    );
  }
}
