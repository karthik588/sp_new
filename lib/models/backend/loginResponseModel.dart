// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  int? status;
  String? message;
  LoginData? data;
  ErrorModel? errorData;

  LoginResponseModel({this.status, this.message, this.data, this.errorData}) {
    status = status ?? -1;
    message = message ?? '';
    data = data ?? LoginData();
    errorData = errorData ?? ErrorModel();
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic>? json) => json !=
          null
      ? LoginResponseModel(
          status: json["status"],
          message: json["message"],
          data: json["data"] == null ? null : LoginData.fromJson(json["data"]),
          errorData:
              json['error'] == null ? null : ErrorModel.fromJson(json['error']))
      : LoginResponseModel();

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class LoginData {
  String? referenceNo;
  String? sessionToken;
  int? userType;
  int? merchantType;
  dynamic theme;
  UserProfile? userProfile;
  String? token;

  LoginData({
    this.referenceNo,
    this.sessionToken,
    this.userType,
    this.merchantType,
    this.theme,
    this.userProfile,
    this.token,
  }) {
    referenceNo = referenceNo ?? '';
    sessionToken = sessionToken ?? '';
    userType = userType ?? 0;
    merchantType = merchantType ?? 0;
    theme = theme ?? '';
    userProfile = userProfile ?? UserProfile();
    token = token ?? '';
  }

  factory LoginData.fromJson(Map<String, dynamic>? json) => json != null
      ? LoginData(
          referenceNo: json["referenceNo"],
          sessionToken: json["sessionToken"],
          userType: json["userType"],
          merchantType: json["merchantType"],
          theme: json["theme"],
          userProfile: json["userProfile"] == null
              ? null
              : UserProfile.fromJson(json["userProfile"]),
          token: json["token"],
        )
      : LoginData();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "sessionToken": sessionToken,
        "userType": userType,
        "merchantType": merchantType,
        "theme": theme,
        "userProfile": userProfile?.toJson(),
        "token": token,
      };
}

class UserProfile {
  dynamic referenceNo;
  bool? firstLogin;
  String? name;
  dynamic email;
  bool? isEmailVerified;
  String? merchantId;
  dynamic applicationId;
  int? merchantVerificationStatus;
  dynamic unseenNotification;
  String? profileUrl;
  String? uniqueId;
  String? geoLatitude;
  String? geolongitude;
  bool? permission;

  UserProfile({
    this.referenceNo,
    this.firstLogin,
    this.name,
    this.email,
    this.isEmailVerified,
    this.merchantId,
    this.applicationId,
    this.merchantVerificationStatus,
    this.unseenNotification,
    this.profileUrl,
    this.uniqueId,
    this.geoLatitude,
    this.geolongitude,
    this.permission,
  }) {
    referenceNo = referenceNo ?? 0;
    firstLogin = firstLogin ?? false;
    name = name ?? '';
    email = email ?? '';
    isEmailVerified = isEmailVerified ?? false;
    merchantId = merchantId ?? '';
    applicationId = applicationId ?? '';
    merchantVerificationStatus = merchantVerificationStatus ?? 0;
    unseenNotification = unseenNotification ?? '';
    profileUrl = profileUrl ?? '';
    uniqueId = uniqueId ?? '';
    geoLatitude = geoLatitude ?? '';
    geolongitude = geolongitude ?? '';
    permission = permission ?? false;
  }

  factory UserProfile.fromJson(Map<String, dynamic>? json) => json != null
      ? UserProfile(
          referenceNo: json["referenceNo"],
          firstLogin: json["firstLogin"],
          name: json["name"],
          email: json["email"],
          isEmailVerified: json["isEmailVerified"],
          merchantId: json["merchantId"],
          applicationId: json["applicationId"],
          merchantVerificationStatus: json["merchantVerificationStatus"],
          unseenNotification: json["unseenNotification"],
          profileUrl: json["profileURL"],
          uniqueId: json["uniqueId"],
          geoLatitude: json["geoLatitude"],
          geolongitude: json["geolongitude"],
          permission: json["permission"],
        )
      : UserProfile();

  Map<String, dynamic> toJson() => {
        "referenceNo": referenceNo,
        "firstLogin": firstLogin,
        "name": name,
        "email": email,
        "isEmailVerified": isEmailVerified,
        "merchantId": merchantId,
        "applicationId": applicationId,
        "merchantVerificationStatus": merchantVerificationStatus,
        "unseenNotification": unseenNotification,
        "profileURL": profileUrl,
        "uniqueId": uniqueId,
        "geoLatitude": geoLatitude,
        "geolongitude": geolongitude,
        "permission": permission,
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
