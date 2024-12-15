// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) =>
    CountryModel.fromJson(json.decode(str));

class CountryModel {
  dynamic status;
  String? message;
  CountryListData? data;
  ErrorModel? errorData;

  CountryModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? CountryListData();
    errorData = errorData ?? ErrorModel();
  }

  factory CountryModel.fromJson(Map<String, dynamic>? json) => json != null
      ? CountryModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null
              ? null
              : CountryListData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : CountryModel();
}

class CountryListData {
  String? referenceNo;
  List<CountryList>? countryList;

  CountryListData({
    this.referenceNo,
    this.countryList,
  }) {
    referenceNo = referenceNo ?? '';
    countryList = countryList ?? <CountryList>[];
  }

  factory CountryListData.fromJson(Map<String, dynamic>? json) => json != null
      ? CountryListData(
          referenceNo: json["referenceNo"],
          countryList: json["countryList"] == null
              ? []
              : List<CountryList>.from(
                  json["countryList"]!.map((x) => CountryList.fromJson(x))),
        )
      : CountryListData();
}

class CountryList {
  String? name;
  int? code;
  int? id;
  String? path;

  CountryList({
    this.name,
    this.code,
    this.id,
    this.path,
  }) {
    name = name ?? '';
    code = code ?? 0;
    id = id ?? 0;
    path = path ?? '';
  }

  factory CountryList.fromJson(Map<String, dynamic>? json) => json != null
      ? CountryList(
          name: json["name"],
          code: json["code"],
          id: json["id"],
          path: json["path"],
        )
      : CountryList();
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
