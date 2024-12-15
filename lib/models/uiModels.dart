import 'package:flutter/cupertino.dart';

class BottomBarModel {
  String? imageData;
  IconData? icon;
  Function? onTap;
  String? text;
  String? subTitle;
  bool? hideDuration;
  Widget? body;
  String? value;

  BottomBarModel(
      {this.icon,
      this.onTap,
      this.text,
      this.hideDuration,
      this.body,
      this.value,
      this.imageData}) {
    text = text ?? '';
    hideDuration = hideDuration ?? false;
    value = value ?? '';
    subTitle = subTitle ?? '';
    imageData = imageData ?? '';
  }
}

class TableModel {
  String? text;
  TextStyle? style;
  TextAlign? textAlign;
  void Function()? onTap;

  TableModel({this.text, this.style, this.textAlign, this.onTap});
}
