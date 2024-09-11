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


