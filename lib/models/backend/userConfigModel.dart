// To parse this JSON data, do
//
//     final userConfigModel = userConfigModelFromJson(jsonString);

import 'dart:convert';

UserConfigModel userConfigModelFromJson(String str) =>
    UserConfigModel.fromJson(json.decode(str));

class UserConfigModel {
  int? status;
  String? message;
  ConfigData? data;
  ErrorModel? errorData;

  UserConfigModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? ConfigData();
    errorData = errorData ?? ErrorModel();
  }

  factory UserConfigModel.fromJson(Map<String, dynamic>? json) => json != null
      ? UserConfigModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null ? null : ConfigData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : UserConfigModel();
}

class ConfigData {
  String? referenceNo;
  bool? ispaymentlink;
  bool? pushnotificationSoundEnabled;
  bool? bioMetricLoginEnabled;
  bool? enablePortalEdit;
  bool? defaultMpin;
  bool? terminalLevelSmsEnabled;
  bool? scanInvoice;
  bool? scanQr;
  bool? quickBilling;
  bool? collectRequest;
  bool? cash;

  ConfigData({
    this.referenceNo,
    this.ispaymentlink,
    this.pushnotificationSoundEnabled,
    this.bioMetricLoginEnabled,
    this.enablePortalEdit,
    this.defaultMpin,
    this.terminalLevelSmsEnabled,
    this.scanInvoice,
    this.scanQr,
    this.quickBilling,
    this.collectRequest,
    this.cash,
  }) {
    referenceNo = referenceNo ?? '';
    ispaymentlink = ispaymentlink ?? false;
    pushnotificationSoundEnabled = pushnotificationSoundEnabled ?? false;
    bioMetricLoginEnabled = bioMetricLoginEnabled ?? false;
    enablePortalEdit = enablePortalEdit ?? false;
    defaultMpin = defaultMpin ?? false;
    terminalLevelSmsEnabled = terminalLevelSmsEnabled ?? false;
    scanInvoice = scanInvoice ?? false;
    scanQr = scanQr ?? false;
    quickBilling = quickBilling ?? false;
    collectRequest = collectRequest ?? false;
    cash = cash ?? false;
  }

  factory ConfigData.fromJson(Map<String, dynamic>? json) => json != null
      ? ConfigData(
          referenceNo: json["referenceNo"],
          ispaymentlink: json["ispaymentlink"],
          pushnotificationSoundEnabled: json["pushnotificationSoundEnabled"],
          bioMetricLoginEnabled: json["bioMetricLoginEnabled"],
          enablePortalEdit: json["enablePortalEdit"],
          defaultMpin: json["defaultMPIN"],
          terminalLevelSmsEnabled: json["terminalLevelSMSEnabled"],
          scanInvoice: json["scanInvoice"],
          scanQr: json["scanQR"],
          quickBilling: json["quickBilling"],
          collectRequest: json["collectRequest"],
          cash: json["cash"],
        )
      : ConfigData();
}

class ErrorModel {
  dynamic errorCode;
  dynamic errorMessage;

  ErrorModel({
    this.errorCode,
    this.errorMessage,
  }) {
    errorCode = errorCode ?? -1;
    errorMessage = errorMessage ?? '';
  }

  factory ErrorModel.fromJson(Map<String, dynamic>? json) => json != null
      ? ErrorModel(
          errorCode: json['errorCode'],
          errorMessage: json['errorMessage'],
        )
      : ErrorModel();
}
