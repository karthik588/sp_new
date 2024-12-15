import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:get_storage/get_storage.dart';
import 'package:swinpay/global/app_util.dart';
import 'package:swinpay/localDb/local_db.dart';

class AESEncryptor {
  static const String M_KEY = "dS6AR8FR9wG9mZ9l";
  static const String M_INIT_VECTOR = "7Q2LqiBlXnPOkwnK";
  static const String PADDING = "AES/CBC/PKCS7Padding";
  static const int IV_LENGTH = 16;

  static Future<String> getEncryptionKeyAndIv() async {
    await GetStorage.init();
    LocalDB localDB = LocalDB();
    var dataK = LocalDB().getSecretKey();
    return dataK ?? '';
  }

  static Future<String?> encrypt(String value) async {
    AppUtil.printData(getEncryptionKeyAndIv().toString(), isError: true);
    try {
      String key = await getEncryptionKeyAndIv();
      String ivString = key.substring(0, IV_LENGTH);
      String keyString = key.substring(IV_LENGTH);

      final keyBytes = utf8.encode(keyString);
      final iv = IV.fromUtf8(ivString);

      final encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(value, iv: iv);

      return encrypted.base64.trim();
    } catch (ex) {
      AppUtil.printData(ex.toString());
    }
    return null;
  }

  static Future<String?> decrypt(String encrypted) async {
    try {
      String key = await getEncryptionKeyAndIv();
      String ivString = key.substring(0, IV_LENGTH);
      String keyString = key.substring(IV_LENGTH);

      final keyBytes = utf8.encode(keyString);
      final iv = IV.fromUtf8(ivString);

      final encrypter = Encrypter(AES(Key(keyBytes), mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);

      return decrypted;
    } catch (ex) {
      AppUtil.printData(ex.toString());
    }
    return null;
  }
}
