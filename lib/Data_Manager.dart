import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  List<Map<String, dynamic>> nameList = [];
  VoidCallback? onUpdate;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initialize() {
    _listenToDataChanges();
  }

  void _listenToDataChanges() {
    _firestore.collection('Users').snapshots().listen((snapshot) {
      nameList = snapshot.docs.map((doc) =>
      {
        'id': doc.id,
        'name': doc['name'],
        'count': doc['count'] ?? 0,
      }).toList();
      onUpdate?.call();
    });
  }

  Future<void> addName(String name, BuildContext context) async {
    name = name.trim();
    if (name.isEmpty) {
      _showMessage(context, "Name cannot be empty!", Colors.red);
      return;
    }

    if (nameList.any((item) =>
    item['name'].toString().toLowerCase() == name.toLowerCase())) {
      _showMessage(context, "This name already exists!", Colors.orange);
      return;
    }

    await _firestore.collection('Users').add({"name": name, "count": 0});
    _showMessage(context, "Name added successfully!", Colors.green);
  }

  Future<void> updateCounter(String docId, int newCount) async {
    if (newCount < 0) return;
    await _firestore.collection('Users').doc(docId).update({"count": newCount});
  }

  void incrementCounter(int index) =>
      updateCounter(nameList[index]['id'], nameList[index]['count'] + 1);

  void decrementCounter(int index, BuildContext context) {
    if (nameList[index]['count'] == 0) {
      _showMessage(context, "Counter is already zero!", Colors.orange);
      return;
    }
    updateCounter(nameList[index]['id'], nameList[index]['count'] - 1);
  }

  void resetCounter(int index, BuildContext context) {
    if (nameList[index]['count'] == 0) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Counter"),
          content: const Text("Are you sure you want to reset the counter?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                await updateCounter(nameList[index]['id'], 0);
                Navigator.pop(context);
              },
              child: const Text("Reset", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message, Color color) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> removeName(int index, BuildContext context) async {
    try {
      String docId = nameList[index]['id'];
      await _firestore.collection('Users').doc(docId).delete();
      _showMessage(context, "Name deleted successfully!", Colors.red);
    } catch (e) {
      _showMessage(context, "Failed to delete name!", Colors.red);
    }
  }
}