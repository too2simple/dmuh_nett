import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String loginSharedPreferences = 'login_key';
  static String phoneSharedPreferences = 'phone_key';
  static String stateTimerSharedPreferences = 'timer_key';
  static String currentTimeSharedPreferences = 'currentTime_key';

// Write DATA
  static Future<bool> saveLogin(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(loginSharedPreferences, value);
  }

// Read Data
  static Future<String?> getLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(loginSharedPreferences);
  }

// Write DATA
  static Future<bool> savePhoneNumber(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(phoneSharedPreferences, value);
  }

// Read Data
  static Future<String?> getPhoneNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(phoneSharedPreferences);
  }

// Write DATA
  static Future<bool> saveStateTimer(int? value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(stateTimerSharedPreferences, value!);
  }

  // Read Data
  static Future<int?> getStateTimer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(stateTimerSharedPreferences);
  }

  // Write DATA
  static Future<bool> saveCurrentTime(String? value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        currentTimeSharedPreferences, value!);
  }

  // Read Data
  static Future<String?> getCurrentTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(currentTimeSharedPreferences);
  }
}
