import 'dart:convert';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart';
import 'package:swinpay/global/app_util.dart';

class RSACipher {
  /// String Public Key
  String publickey =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm6Bz2BcJKurfF6fNvhO5Jnu5l3QFBNPvvQ1dZUkp1gGI4+zlG19l/i1m6HMgtCI7NZpI6esgJAQHctd0u+6BJwY1G0sy2pAMITiRyT7BoJAHg5CrPR9fIwS7KUeMYwOV46vni4QnP8AUB1j+U9bpjFKs11HfE0ZrseECB8T5yrPtFqUX6ebobx6w6PVGf/7hmPcRDitJ8cjvsZRBPzTiB6iN1gARbTWnZbt6LEM9kAYpwU2BcXw89mw+7PhX99TzUq92zApc5/eO1sFBQ0FJVabZ629FXMjkFsm2jopW7eFjUHMSHFSRACNuCpVw8LZtwqWGKE4TVBajF0My+W+ThwIDAQAB";

  String encrypt(String plaintext, String publicKey) {
    /// After a lot of research on how to convert the public key [String] to [RSA PUBLIC KEY]
    /// We would have to use PEM Cert Type and the convert it from a PEM to an RSA PUBLIC KEY through basic_utils
    var pem =
        '-----BEGIN RSA PUBLIC KEY-----\n$publickey\n-----END RSA PUBLIC KEY-----';
    var public = CryptoUtils.rsaPublicKeyFromPem(pem);

    /// Initalizing Cipher
    var cipher = PKCS1Encoding(RSAEngine());
    cipher.init(true, PublicKeyParameter<RSAPublicKey>(public));
    Uint8List output =
        cipher.process(Uint8List.fromList(utf8.encode(plaintext)));
    var base64EncodedText = base64Encode(output);
    return base64EncodedText;
  }

  String encryptUsingPublicKey(String text) {
    print('111111111111');
    AppUtil.printData(encrypt(text, publickey), isError: true);
    return encrypt(text, publickey);
  }
}
