// To parse this JSON data, do
//
//     final baseResponseModel = baseResponseModelFromJson(jsonString);

import 'dart:convert';

BaseResponseModel baseResponseModelFromJson(String str) =>
    BaseResponseModel.fromJson(json.decode(str));

class BaseResponseModel {
  int? status;
  String? message;
  BaseData? data;
  ErrorModel? errorData;

  BaseResponseModel({
    this.status,
    this.message,
    this.data,
    this.errorData,
  }) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? BaseData();
    errorData = errorData ?? ErrorModel();
  }

  factory BaseResponseModel.fromJson(Map<String, dynamic>? json) => json != null
      ? BaseResponseModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null ? null : BaseData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : BaseResponseModel();
}

class BaseData {
  String? referenceNo;
  String? desc;
  String? data;
  String? statusMessage;

  BaseData({this.referenceNo, this.desc, this.data, this.statusMessage}) {
    referenceNo = referenceNo ?? '';
    desc = desc ?? '';
    data = data ?? '';
    statusMessage = statusMessage ?? '';
  }

  factory BaseData.fromJson(Map<String, dynamic>? json) => json != null
      ? BaseData(
          referenceNo: json["referenceNo"],
          desc: json["desc"],
          data: json["data"],
          statusMessage: json['statusMessage'])
      : BaseData();
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
