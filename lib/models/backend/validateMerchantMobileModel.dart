import 'dart:convert';

ValidateMerchantMobileModel validateMerchantMobileModelFromJson(String str) =>
    ValidateMerchantMobileModel.fromJson(json.decode(str));

String validateMerchantMobileModelToJson(ValidateMerchantMobileModel data) =>
    json.encode(data.toJson());

class ValidateMerchantMobileModel {
  int? status;
  String? message;
  UserMobileTerminalData? data;
  ErrorModel? errorData;

  ValidateMerchantMobileModel(
      {this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? UserMobileTerminalData();
    errorData = errorData ?? ErrorModel();
  }

  factory ValidateMerchantMobileModel.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? ValidateMerchantMobileModel(
              status: json["status"],
              message: json["message"],
              data: json["data"] == null
                  ? null
                  : UserMobileTerminalData.fromJson(json["data"]),
              errorData: json['error'] == null
                  ? null
                  : ErrorModel.fromJson(json['error']))
          : ValidateMerchantMobileModel();

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserMobileTerminalData {
  String? referenceNo;
  bool? diffDevice;
  bool? terminalRegistered;
  bool? isMobileExist;
  bool? isDeviceExist;

  UserMobileTerminalData(
      {this.referenceNo,
      this.diffDevice,
      this.terminalRegistered,
      this.isMobileExist,
      this.isDeviceExist}) {
    referenceNo = referenceNo ?? '';
    diffDevice = diffDevice ?? false;
    terminalRegistered = terminalRegistered ?? false;
    isMobileExist = isMobileExist ?? false;
    isDeviceExist = isDeviceExist ?? false;
  }

  factory UserMobileTerminalData.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? UserMobileTerminalData(
              referenceNo: json["referenceNo"],
              diffDevice: json["diffDevice"],
              terminalRegistered: json["terminalRegistered"],
              isDeviceExist: json["isDeviceExist"],
              isMobileExist: json["isMobileExist"])
          : UserMobileTerminalData();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "diffDevice": diffDevice,
        "terminalRegistered": terminalRegistered,
      };
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
