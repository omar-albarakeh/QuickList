import 'package:quicklist/storage.dart';
import 'package:flutter/material.dart';

class Data {
  List<Map<String, dynamic>> nameList = [];
  VoidCallback? onUpdate;

  Future<void> initialize() async {
    nameList = await Storage.LoadData();
    onUpdate?.call();
  }

  void AddName(String name, BuildContext context) async {
    name = name.trim();
    if (name.isEmpty) {
      _showMessage(context, "Name cannot be empty!", Colors.red);
      return;
    }

    bool nameExists = nameList.any((item) => item['name'].toString().toLowerCase() == name.toLowerCase());
    if (nameExists) {
      _showMessage(context, "This name already exists!", Colors.orange);
      return;
    }

    nameList.add({"name": name, "count": 0});

    try {
      await Storage.saveData(nameList);
      onUpdate?.call();
      _showMessage(context, "Name added successfully!", Colors.green);
    } catch (e) {
      _showMessage(context, "Error saving data!", Colors.red);
      print("Error saving data: $e");
    }
  }

  void _showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 4),
      ),
    );
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
      if(nameList[index]['count'] < 0){
        RestCounter(index);
      }
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
