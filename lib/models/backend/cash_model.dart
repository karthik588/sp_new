class CashModel {
  dynamic status;
  String? message;
  CashData? data;
  ErrorModel? errorData;

  CashModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? CashData();
    errorData = errorData ?? ErrorModel();
  }

  factory CashModel.fromJson(Map<String, dynamic>? json) => json != null
      ? CashModel(
          status: json['status'],
          message: json['message'],
          data: json['data'] == null ? null : CashData.fromJson(json['data']),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : CashModel();
}

class CashData {
  dynamic referenceNo;
  dynamic qrStringData;
  dynamic terminalId;
  String? terminalName;
  dynamic url;

  CashData({
    this.referenceNo,
    this.qrStringData,
    this.terminalId,
    this.terminalName,
    this.url,
  }) {
    referenceNo = referenceNo ?? '';
    qrStringData = qrStringData ?? '';
    terminalId = terminalId ?? '';
    terminalName = terminalName ?? '';
    url = url ?? '';
  }

  factory CashData.fromJson(Map<String, dynamic>? json) => json != null
      ? CashData(
          referenceNo: json['referenceNo'],
          qrStringData: json['qrStringData'],
          terminalId: json['terminalId'],
          terminalName: json['terminalname'],
          url: json['url'],
        )
      : CashData();
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
