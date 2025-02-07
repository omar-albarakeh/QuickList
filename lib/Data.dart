import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  List<Map<String, dynamic>> nameList = [];
  VoidCallback? onUpdate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initialize() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      final snapshot = await _firestore.collection('Users').get();
      nameList = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'count': doc['count'],
        };
      }).toList();
      onUpdate?.call();
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void addName(String name, BuildContext context) async {
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

    final newUser = {"name": name, "count": 0};
    await _firestore.collection('Users').add(newUser);
    await _loadData();

    _showMessage(context, "Name added successfully!", Colors.green);
  }


  void addCounter(int index) async {
    if (index >= 0 && index < nameList.length) {
      try {
        final docId = nameList[index]['id'];
        final newCount = nameList[index]['count'] + 1;

        await _firestore.collection('Users').doc(docId).update({"count": newCount});

        await _loadData();
      } catch (e) {
        print("Error updating counter: $e");
      }
    }
  }

  void subtractCounter(int index, BuildContext context) async {
    if (index >= 0 && index < nameList.length) {
      if (nameList[index]['count'] == 0) {
        _showMessage(context, "Counter is already Zero !!", Colors.orange);
        return;
      }

      try {
        final docId = nameList[index]['id'];
        final newCount = nameList[index]['count'] - 1;

        await _firestore.collection('Users').doc(docId).update({"count": newCount});

        await _loadData();
      } catch (e) {
        print("Error decrementing counter: $e");
      }
    }
  }

  void resetCounter(int index, BuildContext context) async {
    if (index >= 0 && index < nameList.length && nameList[index]['count'] > 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Reset Counter"),
            content: const Text("Are you sure you want to reset the counter to 0?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    final docId = nameList[index]['id'];

                    await _firestore.collection('Users').doc(docId).update({"count": 0});

                    await _loadData();
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error resetting counter: $e");
                  }
                },
                child: const Text("Yes", style: TextStyle(color: Colors.green)),
              ),
            ],
          );
        },
      );
    }
  }


  void _showMessage(BuildContext context, String message, Color color) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: Duration(seconds: 4),
      ),
    );
  }
}