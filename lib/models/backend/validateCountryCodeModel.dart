class ValidateCountryCodeModel {
  dynamic status;
  dynamic message;
  ValidateCountryCode? data;
  ErrorModel? errorData;

  ValidateCountryCodeModel(
      {this.status, this.message, this.data, this.errorData}) {
    status = status ?? 0;
    message = message ?? '';
    data = data ?? ValidateCountryCode();
    errorData = errorData ?? ErrorModel();
  }

  factory ValidateCountryCodeModel.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? ValidateCountryCodeModel(
              status: json['status'],
              message: json['message'],
              data: json['data'] == null
                  ? null
                  : ValidateCountryCode.fromJson(json['data']),
              errorData: json['error'] == null
                  ? null
                  : ErrorModel.fromJson(json['error']))
          : ValidateCountryCodeModel();
}

class ValidateCountryCode {
  dynamic referenceNo;
  dynamic desc;

  ValidateCountryCode({
    this.referenceNo,
    this.desc,
  }) {
    referenceNo = referenceNo ?? '';
    desc = desc ?? '';
  }

  factory ValidateCountryCode.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? ValidateCountryCode(
              referenceNo: json['referenceNo'],
              desc: json['desc'],
            )
          : ValidateCountryCode();
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
