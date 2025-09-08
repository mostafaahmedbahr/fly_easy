import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
   static late SharedPreferences _sharedPref;

 static Future init()async{
    _sharedPref=await SharedPreferences.getInstance();
  }

  static Future putData({required String key,required dynamic value})async{
    if(value is bool)  return await _sharedPref.setBool(key, value);
    if(value is int)    return await _sharedPref.setInt(key, value);
    if(value is String)    return await _sharedPref.setString(key, value);
    return await _sharedPref.setDouble(key, value);
  }

 static  dynamic getData({required key}){
   return  _sharedPref.get(key);
  }

  static Future clearCache()async {
   await _sharedPref.clear();
  }
  static Future removeValue({required String key})async{
   return await _sharedPref.remove(key);
  }

}
