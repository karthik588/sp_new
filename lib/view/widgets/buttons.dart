import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';
import 'package:swinpay/global/app_string.dart';
import 'package:swinpay/view/widgets/shapes.dart';

import '../../models/uiModels.dart';
import '../screens/dashboard/filterSheet.dart';

class Buttons {
  Buttons._privateConstructor();

  static final Buttons _instance = Buttons._privateConstructor();

  factory Buttons() {
    return _instance;
  }

  Widget raisedButton({
    String? buttonText = '',
    Widget? btnChild,
    EdgeInsets? padding,
    Function? onTap,
    IconData? icon,
    double? iconSize,
    isCircleShape = false,
    Color? textColor,
    Color? btnColor,
    double? radius,
    double? elevation,
    TextAlign? textAlign,
    bool isLoading = false,
    TextStyle? textStyle,
  }) =>
      SelectionContainer.disabled(
        child: ElevatedButton(
          style: ButtonStyle(
            padding: padding != null
                ? MaterialStateProperty.all(padding)
                : MaterialStateProperty.all(const EdgeInsets.all(10)),
            elevation: MaterialStateProperty.all(elevation),
            backgroundColor: MaterialStateProperty.all(
                onTap == null || isLoading
                    ? Colors.grey
                    : btnColor ?? AppColors.primary),
            shape: MaterialStateProperty.all(isCircleShape
                ? const CircleBorder()
                : _roundedRectBorder(
                    radius: radius ?? 8,
                  )),
          ),
          onPressed: isLoading
              ? null
              : onTap != null
                  ? () => onTap()
                  : null,
          child: isLoading
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : btnChild ??
                  Visibility(
                    visible: icon != null,
                    replacement: _btnText(
                      textStyle: textStyle,
                      buttonText: buttonText,
                      textColor: textColor,
                      textAlign: textAlign,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: textColor,
                          size: iconSize ?? 17,
                        ),
                        Visibility(
                          visible: buttonText!.isNotEmpty,
                          child: _btnText(
                            textStyle: textStyle,
                            buttonText: '  $buttonText',
                            textColor: textColor,
                            textAlign: textAlign,
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      );

  Widget outlinedBtn({
    Key? key,
    Function? onTap,
    EdgeInsets? padding,
    String? buttonText = '',
    Color? textColor,
    Widget? btnChild,
    Color? borderColor,
    double? radius,
  }) =>
      SelectionContainer.disabled(
        child: OutlinedButton(
          key: key,
          style: OutlinedButton.styleFrom(
            padding: padding,
            shape: _roundedRectBorder(
              radius: radius,
            ),
            side: BorderSide(color: borderColor ?? AppColors.primary),
          ),
          onPressed: onTap != null ? () => onTap() : null,
          child: btnChild ??
              _btnText(
                buttonText: buttonText!,
                textColor: textColor ?? AppColors.primary,
              ),
        ),
      );

  Widget bottomBtn({required BottomBarModel data}) => InkWell(
        onTap: () => data.onTap!(),
        child: Column(
          children: [
            Container(
              decoration: Shapes().containerRoundRectBorder(
                  color: AppColors.onBg.withOpacity(0.3), allRadius: 8),
              padding: const EdgeInsets.all(6),
              child: Icon(
                data.icon,
                color: AppColors.primary,
                size: 25,
              ),
            ),
            const SizedBox(height: 5),
            Text(data.text!,
                style: TextStyle(
                    color: AppColors.onBg.withOpacity(0.8), fontSize: 13)),
          ],
        ),
      );

  Widget durationBtn(
          {required List<BottomBarModel> data,
          Offset? offset,
          Function(BottomBarModel)? onSelected}) =>
      PopupMenuButton<BottomBarModel>(
        shape: Shapes().cardRoundedBorder(allRadius: 10),
        color: AppColors.bg,
        offset: offset ?? Offset.zero,
        onSelected: (result) {
          if (result.onTap != null) {
            result.onTap!();
          }
          if (onSelected != null) {
            onSelected(result);
          }
        },
        itemBuilder: (BuildContext context) => List.generate(
            data.length,
            (index) => PopupMenuItem<BottomBarModel>(
                value: data[index],
                child: SizedBox(
                  width: 140,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Text(data[index].text ?? '',
                        style: TextStyle(
                            color: AppColors.onBg,
                            fontWeight: FontWeight.w400)),
                  ),
                ))),
        child: SizedBox(
          width: 100,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: Shapes().containerRoundRectBorder(
                allRadius: 20, color: AppColors.onBg.withOpacity(0.3)),
            child: Row(
              children: [
                const SizedBox(width: 6),
                Text(AppString().duration,
                    style: TextStyle(
                        color: AppColors.onBg.withOpacity(0.6),
                        fontWeight: FontWeight.w300)),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.onBg.withOpacity(0.3),
                )
              ],
            ),
          ),
        ),
      );

  Widget paymentStatusBtn(
          {required RxList<String> selectedFilterVal,
          required Function onTapApply}) =>
      InkWell(
        onTap: () => FilterSheet()
            .show(selectedFilterVal: selectedFilterVal, onTapApply: onTapApply),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: Shapes().containerRoundRectBorder(
              allRadius: 20, color: AppColors.bg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(AppString().status,
                  style: TextStyle(
                      color: AppColors.onBg.withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      fontSize: 13)),
              const SizedBox(width: 8),
              CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.onBg,
                  child: Obx(
                    () => Center(
                      child: Text(
                        (selectedFilterVal.isEmpty)
                            ? 1.toString()
                            : selectedFilterVal.length.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.primary,fontSize: 12),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );

  OutlinedBorder _roundedRectBorder({double? radius}) => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 5),
      );

  Widget _btnText(
          {String? buttonText,
          Color? textColor,
          TextAlign? textAlign,
          TextStyle? textStyle}) =>
      Text(
        buttonText ?? '',
        textScaleFactor: 1.0,
        style: textStyle ??
            Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
                color: textColor ?? AppColors.bg,
                fontSize: 16,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w900),
        textAlign: textAlign,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
}
