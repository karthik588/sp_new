import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:swinpay/global/app_color.dart';

class FormComponents {
  FormComponents._privateConstructor();

  static final FormComponents _instance = FormComponents._privateConstructor();

  factory FormComponents() {
    return _instance;
  }

  Widget textField(
      {String? title,
      String? hint,
      TextStyle? titleStyle,
      String? label,
      TextAlign textAlign = TextAlign.start,
      TextEditingController? controller,
      String? initialValue,
      String? Function(String?)? validator,
      List<TextInputFormatter>? inputFormatter,
      bool isReadOnly = false,
      bool isObscureText = false,
      bool isMandatory = false,
      TextInputType? keyboardType,
      int maxLine = 1,
      int? maxLen,
      void Function(String)? onChanged,
      void Function(String)? onSubmitted,
      Widget? suffixUi,
      IconData? prefixIcon,
      Widget? prefixUi,
      Function? onTap,
      Color? fillColor,
      AutovalidateMode? autoValidateMode,
      Iterable<String>? autofillHints,
      TextCapitalization textCapitalization = TextCapitalization.none,
      FocusNode? focusNode,
      double? textfiedsize,
      String? helpInfoTooltip,
      bool isAllowWhiteSpace = false,
      Color? focusedBorderColor}) {
    inputFormatter = inputFormatter ?? <TextInputFormatter>[];
    inputFormatter.add(FilteringTextInputFormatter.deny(RegExp(r'^\s')));
    return Column(
      children: [
        TextFormField(
          cursorColor: AppColors.onBg,
          style: TextStyle(height: textfiedsize, color: AppColors.onBg),
          textCapitalization: textCapitalization,
          autocorrect: true,
          scrollPhysics: const BouncingScrollPhysics(),
          autofillHints: autofillHints,
          autovalidateMode:
              autoValidateMode ?? AutovalidateMode.onUserInteraction,
          inputFormatters: inputFormatter,
          keyboardType: keyboardType ?? TextInputType.text,
          readOnly: isReadOnly,
          controller: controller,
          initialValue: controller != null ? null : initialValue,
          obscureText: isObscureText,
          maxLines: maxLine,
          maxLength: maxLen,
          validator: (email) => validator != null ? validator(email) : null,
          decoration: inputDecoration(
            focusedBorderColor: focusedBorderColor,
            suffixUi: suffixUi,
            hint: hint,
            title: title,
            isReadOnly: isReadOnly,
            prefixIcon: prefixIcon,
            prefixUi: prefixUi,
            fillColor: fillColor ?? (isReadOnly ? Colors.grey[200] : null),
          ),
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          onTap: () => onTap?.call(),
          textAlign: textAlign,
          focusNode: focusNode,
        ),
      ],
    );
  }

  InputDecoration inputDecoration(
          {required String? hint,
          Color? focusedBorderColor,
          String? title,
          bool isReadOnly = false,
          Color? borderColor,
          Widget? suffixUi,
          IconData? prefixIcon,
          Widget? prefixUi,
          Color? fillColor}) =>
      InputDecoration(
        hintText: hint,
        labelText: title,
        isDense: true,
        fillColor: fillColor ?? AppColors.onBg,
        enabledBorder: _border(),
        focusedBorder:
            _border(focusedBorderColor: focusedBorderColor, width: 2),
        errorBorder: _border(),
        border: _border(),
        focusedErrorBorder: _border(),
        disabledBorder: _border(),
        hintStyle: hintStyle(),
        labelStyle: hintStyle(),
        suffixIcon: suffixUi,
        prefixIcon: prefixUi ?? (prefixIcon != null ? Icon(prefixIcon) : null),
      );

  InputBorder _border({Color? focusedBorderColor, double width = 1}) =>
      OutlineInputBorder(
        borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.onBg.withOpacity(0.5), width: width),
        borderRadius: BorderRadius.circular(10),
      );

  TextStyle hintStyle() =>
      Theme.of(Get.context!).textTheme.labelLarge!.copyWith(
            color: AppColors.onBg,
          );
}
