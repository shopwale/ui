
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _readAll() async {
    var map = <String, String>{};
    try {
      map = await _storage.readAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {}
    return map;
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll(
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      // _readAll();
    } catch (e) {}
  }

  Future<String> readSecureData(String key) async {
    String value = "";
    try {
      value = (await _storage.read(
            key: key,
            iOptions: _getIOSOptions(),
            aOptions: _getAndroidOptions(),
          )) ??
          "";
    } catch (e) {}
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(
        key: key,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {}
  }

  Future<void> writeSecureData(String key, dynamic value) async {
    try {
      await _storage.write(
        key: key,
        value: value.toString(),
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
    } catch (e) {}
  }

  IOSOptions _getIOSOptions() => const IOSOptions(
      // accessibility: IOSAccessibility.first_unlock,
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding,
      );
}

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// var _storage = const FlutterSecureStorage(
//   aOptions: AndroidOptions(
//     // encryptedSharedPreferences: true,
//     preferencesKeyPrefix: "local_genie_vendor",
//   ),
// );

// Future<bool> storeValue(String key, dynamic value) async {
//   try {
//     print("saved $key: $value");
//     await _storage.write(key: key, value: value.toString());
//     return true;
//   } catch (e) {
//     return false;
//   }
// }

// Future<bool> getValue(String key) async {
//   try {
//     await _storage.read(key: key);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }

// Future<bool> deleteValue(String key) async {
//   try {
//     await _storage.delete(key: key);
//     return true;
//   } catch (e) {
//     return false;
//   }
// }
