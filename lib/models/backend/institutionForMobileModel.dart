class InstitutionForMobileModel {
  dynamic status;
  dynamic message;
  InstitutionForMobile? data;
  ErrorModel? errorData;

  InstitutionForMobileModel(
      {this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? InstitutionForMobile();
    errorData = errorData ?? ErrorModel();
  }

  factory InstitutionForMobileModel.fromJson(
          Map<String, dynamic>? json) =>
      json != null
          ? InstitutionForMobileModel(
              status: json['status'],
              message: json['message'],
              data: json['data'] == null
                  ? null
                  : InstitutionForMobile.fromJson(json['data']),
              errorData: json['error'] == null
                  ? null
                  : ErrorModel.fromJson(json['error']))
          : InstitutionForMobileModel();
}

class InstitutionForMobile {
  dynamic referenceNo;
  dynamic institutionId;
  dynamic institutionName;
  dynamic profilePic;
  MobileTheme? theme;

  InstitutionForMobile({
    this.referenceNo,
    this.institutionId,
    this.institutionName,
    this.profilePic,
    this.theme,
  }) {
    referenceNo = referenceNo ?? '';
    institutionId = institutionId ?? 0;
    institutionName = institutionName ?? '';
    profilePic = profilePic ?? '';
    theme = theme ?? MobileTheme();
  }

  factory InstitutionForMobile.fromJson(Map<String, dynamic>? json) =>
      json != null
          ? InstitutionForMobile(
              referenceNo: json['referenceNo'],
              institutionId: json['institutionId'],
              institutionName: json['institutionName'],
              profilePic: json['profilePic'],
              theme: json['theme'] == null
                  ? null
                  : MobileTheme.fromJson(json['theme']),
            )
          : InstitutionForMobile();
}

class MobileTheme {
  dynamic primaryColor;
  dynamic secondaryColor;

  MobileTheme({
    this.primaryColor,
    this.secondaryColor,
  }) {
    primaryColor = primaryColor ?? '';
    secondaryColor = secondaryColor ?? '';
  }

  factory MobileTheme.fromJson(Map<String, dynamic>? json) => json != null
      ? MobileTheme(
          primaryColor: json['primaryColor'],
          secondaryColor: json['seconderyColor'],
        )
      : MobileTheme();
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
