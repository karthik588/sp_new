// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  int? status;
  String? message;
  NotificationData? data;
  ErrorModel? errorData;

  NotificationModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? NotificationData();
    errorData = errorData ?? ErrorModel();
  }

  factory NotificationModel.fromJson(Map<String, dynamic>? json) => json != null
      ? NotificationModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null
              ? null
              : NotificationData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : NotificationModel();
}

class NotificationData {
  String? referenceNo;
  List<NotificationList>? notificationList;

  NotificationData({
    this.referenceNo,
    this.notificationList,
  }) {
    referenceNo = referenceNo ?? '';
    notificationList = notificationList ?? <NotificationList>[];
  }

  factory NotificationData.fromJson(Map<String, dynamic>? json) => json != null
      ? NotificationData(
          referenceNo: json["referenceNo"],
          notificationList: json["notificationList"] == null
              ? []
              : List<NotificationList>.from(json["notificationList"]!
                  .map((x) => NotificationList.fromJson(x))),
        )
      : NotificationData();
}

class NotificationList {
  String? title;
  String? description;
  DateTime? date;

  NotificationList({
    this.title,
    this.description,
    this.date,
  }) {
    title = title ?? '';
    description = description ?? '';
  }

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        title: json["title"],
        description: json["description"],
        date:
            json["date"] == null ? null : DateTime.tryParse('${json["date"]}'),
      );
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
