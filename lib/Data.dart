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

    bool nameExists = nameList.any((item) =>
    item['name']
        .toString()
        .toLowerCase() == name.toLowerCase());
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
  void SubtractCounter(int index, BuildContext context) {
    if (index >= 0 && index < nameList.length) {
      if(nameList[index]['count'] == 0){
        _showMessage(context, "Counter is already Zero !!", Colors.orange);
        return ;
      }
      nameList[index]['count'] -= 1;
      Storage.saveData(nameList);
      onUpdate?.call();
    }
  }

  void RestCounter(int index, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Counter"),
          content: const Text(
              "Are you sure you want to reset the counter to 0?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                nameList[index]['count'] = 0;
                Storage.saveData(nameList);
                onUpdate?.call();
                Navigator.pop(context);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}


