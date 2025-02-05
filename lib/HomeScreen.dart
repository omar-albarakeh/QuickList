import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> _nameList = [];
  late SharedPreferences _prefs;

void _saveData()async{
  await  _prefs.setString( 'nameList', jsonEncode(_nameList));
}

void _loadData() async{
  _prefs =await SharedPreferences.getInstance();
  String? storedData = _prefs.getString("nameList");
  if(storedData != null){
    setState(() {
      _nameList = List<Map<String, dynamic>>.from(json.decode(storedData));
    });
  }
}
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Quick List",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: _nameList.isEmpty
            ? Center(
          child: Text("No Names Added",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _nameList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
               radius:15,
                child:
               Text("${index + 1} "),
              ),
              title: Text(" ${_nameList[index]['name']}",style: TextStyle(fontSize: 20),),
              subtitle: Text("Count: ${_nameList[index]['count']}",style: TextStyle(fontSize: 15),),
              trailing: SizedBox(
                width: 130,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _updateCount(index),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.keyboard_double_arrow_up_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () => _DownGradeCount(index),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.keyboard_double_arrow_down_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: () => _RestCount(index),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add, color: Colors.white,),
      ),
    );
  }

  void _AddName(String name) {
    if (name.isNotEmpty && !_nameList.any((item) => item['name'] == name)) {
      setState(() {
        _nameList.add({'name': name, 'count': 0});
      });
      _saveData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name already added")),
      );
    }
  }

  void _updateCount(index) {
    setState(() {
      _nameList[index]['count'] += 1;
      if (_nameList[index]['count'] < 0) {
        _nameList[index]['count'] = 0;
      }
    });
    _saveData();
  }

  void _DownGradeCount(index) {
    setState(() {
      _nameList[index]['count'] -= 1;
    });
    if (_nameList[index]['count'] < 0) {
      _nameList[index]['count'] = 0;
    }
    _saveData();
  }

  void _RestCount(index){
  setState(() {
    _nameList[index]['count']=0;
  });
  _saveData();
  }
  Future<void> _showDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange[50],
          title: const Text(
            "Add Name",
          ),
          content: TextField(
            decoration: const InputDecoration(
              labelText: "Enter User Name",
              labelStyle: TextStyle(color: Colors.orange),
            ),
            controller: _nameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                Navigator.pop(context);
              },
              child: const Text(
                  "Cancel", style: TextStyle(color: Colors.orange)),
            ),
            TextButton(
              onPressed: () {
                String name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _AddName(name);
                }
                _nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add", style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }
}