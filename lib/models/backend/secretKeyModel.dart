import 'dart:convert';

SecretKeyModel secretKeyModelFromJson(String str) =>
    SecretKeyModel.fromJson(json.decode(str));

class SecretKeyModel {
  int? status;
  String? message;
  SecretKeyData? data;
  ErrorModel? errorData;

  SecretKeyModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? SecretKeyData();
    errorData = errorData ?? ErrorModel();
  }

  factory SecretKeyModel.fromJson(Map<String, dynamic>? json) => json != null
      ? SecretKeyModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null
              ? null
              : SecretKeyData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : SecretKeyModel();
}

class SecretKeyData {
  String? referenceNo;
  String? data;
  String? currentAppVersion;

  SecretKeyData({
    this.referenceNo,
    this.data,
    this.currentAppVersion,
  }) {
    referenceNo = referenceNo ?? "";
    data = data ?? '';
    currentAppVersion = currentAppVersion ?? '';
  }

  factory SecretKeyData.fromJson(Map<String, dynamic>? json) => json != null
      ? SecretKeyData(
          referenceNo: json["referenceNo"],
          data: json["data"],
          currentAppVersion: json["currentAppVersion"],
        )
      : SecretKeyData();
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
