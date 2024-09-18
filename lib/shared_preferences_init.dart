import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._privateConstructor();

  static final SharedPrefs _instance = SharedPrefs._privateConstructor();

  factory SharedPrefs() {
    return _instance;
  }

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('SharedPrefs has not been initialized');
    }
    return _prefs!;
  }
}
/******************************************** */
// Setting a value for shared preference
//
// void saveData(String key, String value) {
//   SharedPrefs().prefs.setString(key, value);
// }
/******************************************** */


/******************************************** */
// gettting the value of the shared preference
//
// String? loadData(String key) {
//   return SharedPrefs().prefs.getString(key);
// }
/******************************************** */


/******************************************* */
// delete a data form shared preference variable
//
// String? loadData(String key) {
//   return SharedPrefs().prefs.remove(key);
// }
/******************************************** */


/* ######################################################################### */

/************************************************* */
/* 1.  install encrypt 5.0.3 and flutter_dotenv 5.1.0 */
/* 2. create .env and setup location of .env in pubspec */
/* 3. await dotenv.load(fileName: ".env") in main(); */
/************************************************ */


// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class SharedPrefs {
//   SharedPrefs._privateConstructor();

//   static final SharedPrefs _instance = SharedPrefs._privateConstructor();

//   factory SharedPrefs() {
//     return _instance;
//   }

//   static SharedPreferences? _prefs;

//   // Load encryption key from environment variables
//   final encrypt.Key _key = encrypt.Key.fromUtf8(dotenv.env['ENCRYPTION_KEY'] ?? '32-char-utf8-key-1234567890abcdefgh');
//   final encrypt.IV _iv = encrypt.IV.fromLength(16); // Initialization Vector

//   late final encrypt.Encrypter _encrypter;

//   // Initialize the encrypter
//   void _initializeEncrypter() {
//     _encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
//   }

//   Future<void> init() async {
//     _prefs ??= await SharedPreferences.getInstance();
//     _initializeEncrypter(); // Initialize _encrypter after _key is set
//   }

//   SharedPreferences get prefs {
//     if (_prefs == null) {
//       throw Exception('SharedPrefs has not been initialized');
//     }
//     return _prefs!;
//   }

//   // Save encrypted string to SharedPreferences
//   Future<void> setString(String key, String value) async {
//     final encryptedValue = _encrypter.encrypt(value, iv: _iv).base64;
//     await prefs.setString(key, encryptedValue);
//   }

//   // Retrieve and decrypt string from SharedPreferences
//   Future<String?> getString(String key) async {
//     final encryptedValue = prefs.getString(key);
//     if (encryptedValue != null) {
//       final decryptedValue = _encrypter.decrypt64(encryptedValue, iv: _iv);
//       return decryptedValue;
//     }
//     return null;
//   }

//   // Save integer
//   Future<void> setInt(String key, int value) async {
//     await prefs.setInt(key, value);
//   }

//   // Retrieve integer
//   Future<int?> getInt(String key) async {
//     return prefs.getInt(key);
//   }

//   // Save double
//   Future<void> setDouble(String key, double value) async {
//     await prefs.setDouble(key, value);
//   }

//   // Retrieve double
//   Future<double?> getDouble(String key) async {
//     return prefs.getDouble(key);
//   }

//   // Save boolean
//   Future<void> setBool(String key, bool value) async {
//     await prefs.setBool(key, value);
//   }

//   // Retrieve boolean
//   Future<bool?> getBool(String key) async {
//     return prefs.getBool(key);
//   }

//   // Remove a key-value pair
//   Future<void> remove(String key) async {
//     await prefs.remove(key);
//   }
// }
