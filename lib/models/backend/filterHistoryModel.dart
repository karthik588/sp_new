import 'dart:convert';

FilterTransactionHistoryodel filterTransactionHistoryodelFromJson(String str) =>
    FilterTransactionHistoryodel.fromJson(json.decode(str));

String filterTransactionHistoryodelToJson(FilterTransactionHistoryodel data) =>
    json.encode(data.toJson());

class FilterTransactionHistoryodel {
  int? status;
  String? message;
  FilterData? data;
  ErrorModel? errorData;

  FilterTransactionHistoryodel(
      {this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? FilterData();
    errorData = errorData ?? ErrorModel();
  }

  factory FilterTransactionHistoryodel.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? FilterTransactionHistoryodel(
              status: json["status"],
              message: json["message"],
              data: json["data"] == null
                  ? null
                  : FilterData.fromJson(json["data"]),
              errorData: json['error'] == null
                  ? null
                  : ErrorModel.fromJson(json['error']))
          : FilterTransactionHistoryodel();

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class FilterData {
  String? referenceNo;
  dynamic total;
  dynamic txnCount;
  String? transactionInfo;
  List<TransactionsubList>? transactionsubList;
  List<TransactionListElement>? transactionList;
  dynamic settlementList;
  dynamic currentUpiPg;
  dynamic currentPg;

  FilterData({
    this.referenceNo,
    this.total,
    this.txnCount,
    this.transactionInfo,
    this.transactionsubList,
    this.transactionList,
    this.settlementList,
    this.currentUpiPg,
    this.currentPg,
  }) {
    referenceNo = referenceNo ?? '';
    total = total ?? 0;
    txnCount = txnCount ?? 0;
    transactionInfo = transactionInfo ?? '';
    transactionsubList = transactionsubList ?? <TransactionsubList>[];
    transactionList = transactionList ?? <TransactionListElement>[];
    settlementList = settlementList ?? '';
    currentUpiPg = currentUpiPg ?? 0;
    currentPg = currentPg ?? 0;
  }

  factory FilterData.fromJson(Map<String, dynamic>? json) => json != null
      ? FilterData(
          referenceNo: json["referenceNo"],
          total: json["total"],
          txnCount: json["txnCount"],
          transactionInfo: json["transactionInfo"],
          transactionsubList: json["transactionsubList"] == null
              ? []
              : List<TransactionsubList>.from(json["transactionsubList"]!
                  .map((x) => TransactionsubList.fromJson(x))),
          transactionList: json["transactionList"] == null
              ? []
              : List<TransactionListElement>.from(json["transactionList"]!
                  .map((x) => TransactionListElement.fromJson(x))),
          settlementList: json["settlementList"],
          currentUpiPg: json["currentUPIPg"],
          currentPg: json["currentPg"],
        )
      : FilterData();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "total": total,
        "txnCount": txnCount,
        "transactionInfo": transactionInfo,
        "transactionsubList": transactionsubList == null
            ? []
            : List<dynamic>.from(transactionsubList!.map((x) => x.toJson())),
        "transactionList": transactionList == null
            ? []
            : List<dynamic>.from(transactionList!.map((x) => x.toJson())),
        "settlementList": settlementList,
        "currentUPIPg": currentUpiPg,
        "currentPg": currentPg,
      };
}

class TransactionListElement {
  String? customerName;
  dynamic description;
  dynamic amount;
  String? transactionId;
  DateTime? date;
  dynamic transactionStatus;
  String? orgTxnId;
  String? terminal;
  String? pspName;
  String? bankref;
  dynamic refundStatus;
  String? txnmode;

  TransactionListElement({
    this.customerName,
    this.description,
    this.amount,
    this.transactionId,
    this.date,
    this.transactionStatus,
    this.orgTxnId,
    this.terminal,
    this.pspName,
    this.bankref,
    this.refundStatus,
    this.txnmode,
  }) {
    customerName = customerName ?? '';
    description = description ?? '';
    amount = amount ?? 0;
    transactionId = transactionId ?? '--';
    transactionStatus = transactionStatus ?? 0;
    orgTxnId = orgTxnId ?? '--';
    terminal = terminal ?? '';
    pspName = pspName ?? '';
    bankref = bankref ?? '--';
    refundStatus = refundStatus ?? 0;
    txnmode = txnmode ?? '';
  }

  factory TransactionListElement.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? TransactionListElement(
              customerName: json["customerName"],
              description: json["description"],
              amount: json["amount"],
              transactionId: json["transactionId"],
              date: json["date"] == null ? null : DateTime.parse(json["date"]),
              transactionStatus: json["transactionStatus"],
              orgTxnId: json["orgTxnID"],
              terminal: json["terminal"],
              pspName: json["pspName"],
              bankref: json["bankref"],
              refundStatus: json["refundStatus"],
              txnmode: json["txnmode"],
            )
          : TransactionListElement();

  Map<String, dynamic> toJson() => {
        "customerName": customerName,
        "description": description,
        "amount": amount,
        "transactionId": transactionId,
        "date": date?.toIso8601String(),
        "transactionStatus": transactionStatus,
        "orgTxnID": orgTxnId,
        "terminal": terminal,
        "pspName": pspName,
        "bankref": bankref,
        "refundStatus": refundStatus,
        "txnmode": txnmode,
      };
}

class TransactionsubList {
  dynamic txnCount;
  String? day;
  dynamic subtotal;
  List<TransactionListElement>? txnSubList;

  TransactionsubList({
    this.txnCount,
    this.day,
    this.subtotal,
    this.txnSubList,
  }) {
    txnCount = txnCount ?? 0;
    day = day ?? '';
    subtotal = subtotal ?? 0;
    txnSubList = txnSubList ?? <TransactionListElement>[];
  }

  factory TransactionsubList.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? TransactionsubList(
              txnCount: json["txnCount"],
              day: json["day"],
              subtotal: json["subtotal"],
              txnSubList: json["txnSubList"] == null
                  ? []
                  : List<TransactionListElement>.from(json["txnSubList"]!
                      .map((x) => TransactionListElement.fromJson(x))),
            )
          : TransactionsubList();

  Map<String, dynamic> toJson() => {
        "txnCount": txnCount,
        "day": day,
        "subtotal": subtotal,
        "txnSubList": txnSubList == null
            ? []
            : List<dynamic>.from(txnSubList!.map((x) => x.toJson())),
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
