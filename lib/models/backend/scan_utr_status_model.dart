class ScanUtrStatusModel {
  dynamic status;
  String? message;
  ScanUtrStatusData? data;
  ErrorModel? errorData;

  ScanUtrStatusModel({
    this.status,
    this.message,
    this.data,
    this.errorData
  }) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? ScanUtrStatusData();
    errorData=errorData??ErrorModel();
  }

  factory ScanUtrStatusModel.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? ScanUtrStatusModel(
              status: json['status'],
              message: json['message'],
              data: json['data'] == null
                  ? null
                  : ScanUtrStatusData.fromJson(json['data']),
              errorData: json['error'] == null
                  ? null
                  : ErrorModel.fromJson(json['error']))
          : ScanUtrStatusModel();
}

class ScanUtrStatusData {
  dynamic referenceNo;
  dynamic description;
  dynamic amount;
  dynamic transactionId;
  DateTime? date;
  dynamic transactionStatus;
  dynamic transactionStatusMsg;
  dynamic bankRefNumber;
  ScanUtrStatusAdditionalData? additionalData;
  dynamic returnUrl;
  dynamic time;
  dynamic merchantAddress;
  dynamic statusMessage;
  dynamic statusCode;
  dynamic merchantLogo;
  dynamic merchantName;

  ScanUtrStatusData({
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
    amount = amount ?? 0;
    transactionId = transactionId ?? '';
    transactionStatus = transactionStatus ?? 0;
    transactionStatusMsg = transactionStatusMsg ?? '';
    bankRefNumber = bankRefNumber ?? '';
    additionalData = additionalData ?? ScanUtrStatusAdditionalData();
    returnUrl = returnUrl ?? '';
    time = time ?? 0;
    merchantAddress = merchantAddress ?? '';
    statusMessage = statusMessage ?? '';
    statusCode = statusCode ?? -1;
    merchantLogo = merchantLogo ?? '';
    merchantName = merchantName ?? '';
  }

  factory ScanUtrStatusData.fromJson(Map<String, dynamic>? json) => json != null
      ? ScanUtrStatusData(
          referenceNo: json['referenceNo'],
          description: json['description'],
          amount: json['amount'],
          transactionId: json['transactionId'],
          date: json['date'] == null
              ? null
              : DateTime.tryParse('${json['date']}'),
          transactionStatus: json['transactionStatus'],
          transactionStatusMsg: json['transactionStatusMsg'],
          bankRefNumber: json['bankRefNumber'],
          additionalData: json['additionlData'] == null
              ? null
              : ScanUtrStatusAdditionalData.fromJson(json['additionlData']),
          returnUrl: json['returnURL'],
          time: json['time'],
          merchantAddress: json['merchantAddress'],
          statusMessage: json['statusMessage'],
          statusCode: json['statusCode'],
          merchantLogo: json['merchantLogo'],
          merchantName: json['merchantName'],
        )
      : ScanUtrStatusData();
}

class ScanUtrStatusAdditionalData {
  dynamic terminalId;
  dynamic vpa;
  DateTime? dateTime;
  dynamic txnId;
  dynamic invoiceNumber;

  ScanUtrStatusAdditionalData({
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

  factory ScanUtrStatusAdditionalData.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? ScanUtrStatusAdditionalData(
              terminalId: json['terminalID'],
              vpa: json['vpa'],
              dateTime: json['dateTime'] == null
                  ? null
                  : DateTime.tryParse('${json['dateTime']}'),
              txnId: json['txnID'],
              invoiceNumber: json['invoiceNumber'],
            )
          : ScanUtrStatusAdditionalData();
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
