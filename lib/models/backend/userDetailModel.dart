class UserDetailModel {
  dynamic status;
  dynamic message;
  UserDetail? data;
  ErrorModel? errorData;

  UserDetailModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? UserDetail();
    errorData = errorData ?? ErrorModel();
  }

  factory UserDetailModel.fromJson(Map<String, dynamic>? json) => json != null
      ? UserDetailModel(
          status: json['status'],
          message: json['message'],
          data: json['data'] == null ? null : UserDetail.fromJson(json['data']),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : UserDetailModel();
}

class UserDetail {
  dynamic referenceNo;
  dynamic userType;
  dynamic merchantMobileNumber;
  dynamic terminalNumber;
  bool? registrationStatus;
  bool? merchantRegistartionEnable;
  bool? defaultMpin;
  String? userMobile;

  UserDetail(
      {this.referenceNo,
      this.userType,
      this.merchantMobileNumber,
      this.terminalNumber,
      this.registrationStatus,
      this.merchantRegistartionEnable,
      this.defaultMpin,
      this.userMobile}) {
    referenceNo = referenceNo ?? '';
    userType = userType ?? 0;
    merchantMobileNumber = merchantMobileNumber ?? '';
    terminalNumber = terminalNumber ?? '';
    userMobile = userMobile ?? '';
  }

  factory UserDetail.fromJson(Map<String, dynamic>? json) => json != null
      ? UserDetail(
          referenceNo: json['referenceNo'],
          userType: json['userType'],
          merchantMobileNumber: json['merchantMobileNumber'],
          terminalNumber: json['terminalNumber'],
          registrationStatus: json['registrationStatus'],
          merchantRegistartionEnable: json['merchantRegistartionEnable'],
          defaultMpin: json['defaultMPIN'],
          userMobile: json['userMobile'])
      : UserDetail();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "userType": userType,
        "merchantMobileNumber": merchantMobileNumber,
        "terminalNumber": terminalNumber,
        "registrationStatus": registrationStatus,
        "merchantRegistartionEnable": merchantRegistartionEnable,
        "defaultMPIN": defaultMpin,
        "userMobile": userMobile
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
