import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> saveData(List<Map<String, dynamic>> nameList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("nameList", jsonEncode(nameList));
  }

  static Future<List<Map<String, dynamic>>> LoadData() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString("nameList");
    if (storedData != null) {
      return List<Map<String, dynamic>>.from(json.decode(storedData));
    }
    return [];
  }
}
