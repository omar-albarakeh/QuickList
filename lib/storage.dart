import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage{
  
  static Future<void> saveData1(List<Map<String,dynamic>> nameList) async{
    final prefs =await SharedPreferences.getInstance();
    await prefs.setString("nameList", jsonEncode(nameList));
  }
}