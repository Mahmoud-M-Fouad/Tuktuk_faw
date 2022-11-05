
import 'package:shared_preferences/shared_preferences.dart';

class SharedClass{
  static late SharedPreferences sharedPreferences;

  static inti() async {
    sharedPreferences =  await SharedPreferences.getInstance();
  }
  static setInt({required String key,required int num})
  {
    return sharedPreferences.setInt(key, num);
  }
  static getInt({required String key})
  {
    return sharedPreferences.getInt(key);
  }


  static setString({required String key,required String str})
  {
    return sharedPreferences.setString(key, str);
  }
  static getString({required String key})
  {
    return sharedPreferences.getString(key);
  }


  static setBool({required String key,required bool b})
  {
    return sharedPreferences.setBool(key, b);
  }

  static getBool({required String key})
  {
    return sharedPreferences.getBool(key);
  }

}