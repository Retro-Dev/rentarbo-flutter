import 'dart:convert';
import 'dart:io';
import 'dart:convert';

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class CryptoAES {
  final SECRET_KEY = "6fa979f20126cb08aa645a8f495f6d85";
  final SEC_IV = "I8zyA4lVhMCaJ5Kg";
  final PADDING = "PKCS7";

  static  String encryptAESCryptoJS(String plainText) {
    try {
      final key = encrypt.Key.fromUtf8(CryptoAES().SECRET_KEY);
      final iv = encrypt.IV.fromUtf8(CryptoAES().SEC_IV);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: CryptoAES().PADDING));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64.toString();
    } catch (error) {
      throw error;
    }
  }

  static String decryptAESCryptoJS(String encrypted) {
    try {
      final key = encrypt.Key.fromUtf8(CryptoAES().SECRET_KEY);
      final iv = encrypt.IV.fromUtf8(CryptoAES().SEC_IV);
      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: CryptoAES().PADDING));
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }
}
