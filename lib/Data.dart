import 'package:quicklist/storage.dart';
import 'package:flutter/material.dart';

class Data {
  List<Map<String, dynamic>> nameList = [];
  VoidCallback? onUpdate;

  Future<void> initialize() async {
    nameList = await Storage.LoadData();
    onUpdate?.call();
  }

  void AddName(String name) async {
    name = name.trim();
    if (name.isEmpty) return;

    bool nameExists = nameList.any((item) => item['name'].toString().toLowerCase() == name.toLowerCase());
    if (nameExists) return;

    nameList.add({"name": name, "count": 0});

    try {
      await Storage.saveData(nameList);
      onUpdate?.call();
    } catch (e) {
      print("Error saving data: $e");
    }
  }


  void AddCounter(int index) {
    if (index >= 0 && index < nameList.length) {
      nameList[index]['count'] += 1;
      Storage.saveData(nameList);
      onUpdate?.call();
    }
  }

  void SubtractCounter(int index) {
    if (index >= 0 && index < nameList.length) {
      nameList[index]['count'] -= 1;
      Storage.saveData(nameList);
      onUpdate?.call();
    }
  }

  void RestCounter(int index) {
    if (index >= 0 && index < nameList.length) {
      nameList[index]['count'] = 0;
      Storage.saveData(nameList);
      onUpdate?.call();
    }
  }
}
