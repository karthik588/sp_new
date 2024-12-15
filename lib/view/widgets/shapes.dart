import 'package:flutter/material.dart';

class Shapes {
  Shapes._privateConstructor();

  static final Shapes _instance = Shapes._privateConstructor();

  factory Shapes() {
    return _instance;
  }

  Decoration containerRoundRectBorder(
          {double? allRadius,
          Color? color,
          Color? boxColor,
          double? borderWidth,
          double? br,
          double? tr,
          double? bl,
          double? tl}) =>
      BoxDecoration(
          color: boxColor,
          border: Border.all(
              width: borderWidth ?? 1.0, color: color ?? Colors.transparent),
          borderRadius: allRadius != null
              ? radiusAll(allRadius: allRadius)
              : radiusOnly(bl: bl, br: br, tl: tl, tr: tr));

  ShapeBorder cardRoundedBorder(
          {double? allRadius,
          double? br,
          double? tr,
          double? bl,
          double? tl,
          Color? borderColor}) =>
      RoundedRectangleBorder(
          borderRadius: allRadius != null
              ? radiusAll(allRadius: allRadius)
              : radiusOnly(bl: bl, br: br, tl: tl, tr: tr),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
          ));

  BorderRadius radiusAll({double? allRadius}) =>
      BorderRadius.all(Radius.circular(allRadius ?? 0));

  BorderRadius radiusOnly({double? br, double? tr, double? bl, double? tl}) =>
      BorderRadius.only(
        bottomRight: Radius.circular(br ?? 0),
        topRight: Radius.circular(tr ?? 0),
        topLeft: Radius.circular(tl ?? 0),
        bottomLeft: Radius.circular(bl ?? 0),
      );
}
