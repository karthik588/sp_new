import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/services.dart';
//import 'package:mac_address/mac_address.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:swinpay/global/app_util.dart';

class DeviceInfo {
  Future<String> getDeviceId() async {
    String deviceId = "";
    deviceId =
        "${await _getDeviceIdentifier()};${await _getSerialNumber()};${await _getDeviceIMEIOrSerial()};${await _getMacAddress()}";

    AppUtil.printData(deviceId.toString(), isError: true);
    return deviceId;
  }

  Future<String> _getDeviceIdentifier() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    dynamic deviceId;
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    return deviceId != null && deviceId.isNotEmpty ? deviceId : 'NA';
  }

  Future<String> _getSerialNumber() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? serial;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var sdk = int.tryParse('${androidInfo.version.sdkInt}') ?? 0;
      if (sdk >= 26) {
        serial = 'DEFSERNEMSPMerchant';
      } else {
        serial = androidInfo.id;
      }
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      serial = iosInfo.identifierForVendor;
    }

    return serial != null && serial.isNotEmpty ? serial : 'NA';
  }

  Future<String> _getDeviceIMEIOrSerial() async {
    String deviceId = await _getDeviceImei();
    if (deviceId.isEmpty) {
      deviceId = await _getSerialNumber();
    }
    return deviceId;
  }

  Future<String> _getMacAddress() async {
    String? macAddress;
    try {
      final info = NetworkInfo();
      macAddress = await info.getWifiBSSID();
    } on PlatformException {
      macAddress = '';
    }
    return macAddress != null && macAddress.isNotEmpty ? macAddress : 'NA';
  }

  Future<String> _getDeviceImei() async {
    String? imei;
    try {
      imei = await DeviceInformation.deviceIMEINumber;
    } catch (_) {
      AppUtil.printData('error in _getDeviceImei $_');
    }

    return imei ?? '';
  }

  Future<String> getMacAddress() async {
    try {
      //return await GetMac.macAddress;
      return "NA";
    } on PlatformException catch (e) {
      print("Error getting MAC address: $e");
      return "NA"; // Return a default value in case of an error
    }
  }
}
