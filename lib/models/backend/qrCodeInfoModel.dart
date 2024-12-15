// To parse this JSON data, do
//
//     final qRcodeInfoModel = qRcodeInfoModelFromJson(jsonString);

import 'dart:convert';

QRcodeInfoModel qRcodeInfoModelFromJson(String str) =>
    QRcodeInfoModel.fromJson(json.decode(str));

String qRcodeInfoModelToJson(QRcodeInfoModel data) =>
    json.encode(data.toJson());

class QRcodeInfoModel {
  int? status;
  String? message;
  QrData? data;
  ErrorModel? errorData;

  QRcodeInfoModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? QrData();
    errorData = errorData ?? ErrorModel();
  }

  factory QRcodeInfoModel.fromJson(Map<String, dynamic>? json) => json != null
      ? QRcodeInfoModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null ? null : QrData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : QRcodeInfoModel();

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class QrData {
  String? referenceNo;
  String? payloadFormatIndicator;
  String? merchantIdentifier;
  String? ifscCode;
  String? accountNumber;
  String? merchantCategoryCode;
  String? transactionCurrencyCode;
  String? countryCode;
  String? merchantName;
  String? merchantCity;
  String? postalCode;
  String? crc;
  String? billNumber;
  String? mobileNumber;
  String? storeId;
  String? loyaltyNumber;
  String? referenceId;
  String? terminalId;
  String? purpose;
  dynamic alipayUrl1;
  dynamic alipayUrl2;
  dynamic alipayUrl3;
  dynamic tempTransactionId;
  String? vpa;
  String? outletId;
  String? storeName;
  String? storeLocation;

  QrData({
    this.referenceNo,
    this.payloadFormatIndicator,
    this.merchantIdentifier,
    this.ifscCode,
    this.accountNumber,
    this.merchantCategoryCode,
    this.transactionCurrencyCode,
    this.countryCode,
    this.merchantName,
    this.merchantCity,
    this.postalCode,
    this.crc,
    this.billNumber,
    this.mobileNumber,
    this.storeId,
    this.loyaltyNumber,
    this.referenceId,
    this.terminalId,
    this.purpose,
    this.alipayUrl1,
    this.alipayUrl2,
    this.alipayUrl3,
    this.tempTransactionId,
    this.vpa,
    this.outletId,
    this.storeName,
    this.storeLocation,
  }) {
    referenceNo = referenceNo ?? '';
    payloadFormatIndicator = payloadFormatIndicator ?? '';
    merchantIdentifier = merchantIdentifier ?? '';
    ifscCode = ifscCode ?? '';
    accountNumber = accountNumber ?? '';
    merchantCategoryCode = merchantCategoryCode ?? '';
    transactionCurrencyCode = transactionCurrencyCode ?? '';
    countryCode = countryCode ?? '';
    merchantName = merchantName ?? ' ';
    merchantCity = merchantCity ?? '';
    postalCode = postalCode ?? '';
    crc = crc ?? '';
    billNumber = billNumber ?? '';
    mobileNumber = mobileNumber ?? '';
    storeId = storeId ?? '';
    loyaltyNumber = loyaltyNumber ?? '';
    referenceId = referenceId ?? '';
    terminalId = terminalId ?? '';
    purpose = purpose ?? '';
    alipayUrl1 = alipayUrl1 ?? '';
    alipayUrl2 = alipayUrl2 ?? '';
    alipayUrl3 = alipayUrl3 ?? '';
    tempTransactionId = tempTransactionId ?? '';
    vpa = vpa ?? '';
    outletId = outletId ?? '';
    storeName = storeName ?? '';
    storeLocation = storeLocation ?? '';
  }

  factory QrData.fromJson(Map<String, dynamic>? json) => json != null
      ? QrData(
          referenceNo: json["referenceNo"],
          payloadFormatIndicator: json["payloadFormatIndicator"],
          merchantIdentifier: json["merchantIdentifier"],
          ifscCode: json["ifscCode"],
          accountNumber: json["accountNumber"],
          merchantCategoryCode: json["merchantCategoryCode"],
          transactionCurrencyCode: json["transactionCurrencyCode"],
          countryCode: json["countryCode"],
          merchantName: json["merchantName"],
          merchantCity: json["merchantCity"],
          postalCode: json["postalCode"],
          crc: json["crc"],
          billNumber: json["billNumber"],
          mobileNumber: json["mobileNumber"],
          storeId: json["storeID"],
          loyaltyNumber: json["loyaltyNumber"],
          referenceId: json["referenceID"],
          terminalId: json["terminalID"],
          purpose: json["purpose"],
          alipayUrl1: json["alipayURL1"],
          alipayUrl2: json["alipayURL2"],
          alipayUrl3: json["alipayURL3"],
          tempTransactionId: json["tempTransactionID"],
          vpa: json["vpa"],
          outletId: json["outletID"],
          storeName: json["storeName"],
          storeLocation: json["storeLocation"],
        )
      : QrData();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "payloadFormatIndicator": payloadFormatIndicator,
        "merchantIdentifier": merchantIdentifier,
        "ifscCode": ifscCode,
        "accountNumber": accountNumber,
        "merchantCategoryCode": merchantCategoryCode,
        "transactionCurrencyCode": transactionCurrencyCode,
        "countryCode": countryCode,
        "merchantName": merchantName,
        "merchantCity": merchantCity,
        "postalCode": postalCode,
        "crc": crc,
        "billNumber": billNumber,
        "mobileNumber": mobileNumber,
        "storeID": storeId,
        "loyaltyNumber": loyaltyNumber,
        "referenceID": referenceId,
        "terminalID": terminalId,
        "purpose": purpose,
        "alipayURL1": alipayUrl1,
        "alipayURL2": alipayUrl2,
        "alipayURL3": alipayUrl3,
        "tempTransactionID": tempTransactionId,
        "vpa": vpa,
        "outletID": outletId,
        "storeName": storeName,
        "storeLocation": storeLocation,
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
