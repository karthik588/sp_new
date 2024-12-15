// To parse this JSON data, do
//
//     final dynamicQrModel = dynamicQrModelFromJson(jsonString);

import 'dart:convert';

DynamicQrModel dynamicQrModelFromJson(String str) =>
    DynamicQrModel.fromJson(json.decode(str));

String dynamicQrModelToJson(DynamicQrModel data) => json.encode(data.toJson());

class DynamicQrModel {
  int? status;
  String? message;
  DynamicQrData? data;
  ErrorModel? errorData;

  DynamicQrModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? DynamicQrData();
    errorData = errorData ?? ErrorModel();
  }

  factory DynamicQrModel.fromJson(Map<String, dynamic>? json) => json != null
      ? DynamicQrModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null
              ? null
              : DynamicQrData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']),
        )
      : DynamicQrModel();

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DynamicQrData {
  String? referenceNo;
  dynamic description;
  dynamic amount;
  String? transactionId;
  DateTime? date;
  dynamic transactionStatus;
  String? transactionStatusMsg;
  String? bankRefNumber;
  AdditionalData? additionalData;
  dynamic returnUrl;
  int? time;
  dynamic merchantAddress;
  String? statusMessage;
  dynamic statusCode;
  dynamic merchantLogo;
  dynamic merchantName;

  DynamicQrData({
    this.referenceNo,
    this.description,
    this.amount,
    this.transactionId,
    this.date,
    this.transactionStatus,
    this.transactionStatusMsg,
    this.bankRefNumber,
    this.additionalData,
    this.returnUrl,
    this.time,
    this.merchantAddress,
    this.statusMessage,
    this.statusCode,
    this.merchantLogo,
    this.merchantName,
  }) {
    referenceNo = referenceNo ?? '';
    description = description ?? '';
    amount = amount ?? 0.0;
    transactionId = transactionId ?? '';
    transactionStatus = transactionStatus ?? 0;
    transactionStatusMsg = transactionStatusMsg ?? '';
    bankRefNumber = bankRefNumber ?? '';
    additionalData = additionalData ?? AdditionalData();
    returnUrl = returnUrl ?? '';
    merchantAddress = merchantAddress ?? '';
    statusMessage = statusMessage ?? '';
    statusCode = statusCode ?? -1;
    merchantLogo = merchantLogo ?? '';
    merchantName = merchantName ?? '--';
  }

  factory DynamicQrData.fromJson(Map<String, dynamic>? json) => json != null
      ? DynamicQrData(
          referenceNo: json["referenceNo"],
          description: json["description"],
          amount: json["amount"],
          transactionId: json["transactionId"],
          date: json["date"] == null ? null : DateTime.parse(json["date"]),
          transactionStatus: json["transactionStatus"],
          transactionStatusMsg: json["transactionStatusMsg"],
          bankRefNumber: json["bankRefNumber"],
          additionalData: json["additionlData"] == null
              ? null
              : AdditionalData.fromJson(json["additionlData"]),
          returnUrl: json["returnURL"],
          time: json["time"],
          merchantAddress: json["merchantAddress"],
          statusMessage: json["statusMessage"],
          statusCode: json["statusCode"],
          merchantLogo: json["merchantLogo"],
          merchantName: json["merchantName"],
        )
      : DynamicQrData();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "description": description,
        "amount": amount,
        "transactionId": transactionId,
        "date": date?.toIso8601String(),
        "transactionStatus": transactionStatus,
        "transactionStatusMsg": transactionStatusMsg,
        "bankRefNumber": bankRefNumber,
        "additionalData": additionalData?.toJson(),
        "returnURL": returnUrl,
        "time": time,
        "merchantAddress": merchantAddress,
        "statusMessage": statusMessage,
        "statusCode": statusCode,
        "merchantLogo": merchantLogo,
        "merchantName": merchantName,
      };
}

class AdditionalData {
  String? terminalId;
  String? vpa;
  String? dateTime;
  String? txnId;
  String? invoiceNumber;

  AdditionalData({
    this.terminalId,
    this.vpa,
    this.dateTime,
    this.txnId,
    this.invoiceNumber,
  }) {
    terminalId = terminalId ?? '';
    vpa = vpa ?? '';
    txnId = txnId ?? '';
    invoiceNumber = invoiceNumber ?? '';
  }

  factory AdditionalData.fromJson(Map<String, dynamic>? json) => json != null
      ? AdditionalData(
          terminalId: json["terminalID"],
          vpa: json["vpa"],
          dateTime: json["dateTime"],
          txnId: json["txnID"],
          invoiceNumber: json["invoiceNumber"],
        )
      : AdditionalData();

  Map<String, dynamic> toJson() => {
        "terminalID": terminalId,
        "vpa": vpa,
        "dateTime": dateTime,
        "txnID": txnId,
        "invoiceNumber": invoiceNumber,
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
