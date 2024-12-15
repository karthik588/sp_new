class GetStaticQrModel {
  dynamic status;
  String? message;
  GetStaticQrData? data;
  ErrorModel? errorData;

  GetStaticQrModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? GetStaticQrData();
    errorData = errorData ?? ErrorModel();
  }

  factory GetStaticQrModel.fromJson(Map<String, dynamic>? json) => json != null
      ? GetStaticQrModel(
          status: json['status'],
          message: json['message'],
          data: json['data'] == null
              ? null
              : GetStaticQrData.fromJson(json['data']),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : GetStaticQrModel();
}

class GetStaticQrData {
  dynamic referenceNo;
  String? qrStringData;
  dynamic terminalId;
  String? terminalName;
  String? url;

  GetStaticQrData({
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

  factory GetStaticQrData.fromJson(Map<String, dynamic>? json) => json != null
      ? GetStaticQrData(
          referenceNo: json['referenceNo'],
          qrStringData: json['qrStringData'],
          terminalId: json['terminalId'],
          terminalName: json['terminalname'],
          url: json['url'],
        )
      : GetStaticQrData();
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
