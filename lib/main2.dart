import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NameTracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NameTrackerScreen(),
    );
  }
}

class NameTrackerScreen extends StatefulWidget {
  @override
  _NameTrackerScreenState createState() => _NameTrackerScreenState();
}

class _NameTrackerScreenState extends State<NameTrackerScreen> {
  List<Map<String, dynamic>> _nameList = [];
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    final savedData = _prefs?.getString('nameList');
    if (savedData != null) {
      setState(() {
        _nameList = List<Map<String, dynamic>>.from(json.decode(savedData));
      });
    }
  }

  void _saveData() {
    _prefs?.setString('nameList', json.encode(_nameList));
  }

  void _addName(String name) {
    if (name.isNotEmpty && !_nameList.any((item) => item['name'] == name)) {
      setState(() {
        _nameList.add({'name': name, 'count': 0});
      });
      _saveData();
    }
  }

  void _updateCount(int index, int delta) {
    setState(() {
      _nameList[index]['count'] += delta;
      if (_nameList[index]['count'] < 0) {
        _nameList[index]['count'] = 0;
      }
    });
    _saveData();
  }

  void _resetCount(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Count'),
        content: Text('Are you sure you want to reset the count for "${_nameList[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _nameList[index]['count'] = 0;
              });
              _saveData();
              Navigator.of(context).pop();
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _removeName(int index) {
    setState(() {
      _nameList.removeAt(index);
    });
    _saveData();
  }

  void _showAddNameDialog() {
    final _nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Name'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(hintText: 'Enter a name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addName(_nameController.text.trim());
              Navigator.of(context).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NameTracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NameSearchDelegate(
                  nameList: _nameList,
                  onUpdate: (updatedList) {
                    setState(() {
                      _nameList = updatedList;
                    });
                    _saveData();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: _nameList.isEmpty
          ? Center(child: Text('No names added yet!'))
          : ListView.builder(
        itemCount: _nameList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(_nameList[index]['name']),
            onDismissed: (direction) => _removeName(index),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(_nameList[index]['name']),
                subtitle: Text('Count: ${_nameList[index]['count']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _updateCount(index, 1),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => _updateCount(index, -1),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () => _resetCount(index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNameDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class NameSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> nameList;
  final Function(List<Map<String, dynamic>>) onUpdate;

  NameSearchDelegate({required this.nameList, required this.onUpdate});

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = nameList
        .where((item) => item['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final originalIndex = nameList.indexWhere((item) => item['name'] == suggestions[index]['name']);
            return ListTile(
              title: RichText(
                text: TextSpan(
                  text: suggestions[index]['name'].substring(0, query.length),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: suggestions[index]['name'].substring(query.length),
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              subtitle: Text('Count: ${suggestions[index]['count']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      nameList[originalIndex]['count']++;
                      onUpdate(nameList);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      nameList[originalIndex]['count']--;
                      if (nameList[originalIndex]['count'] < 0) {
                        nameList[originalIndex]['count'] = 0;
                      }
                      onUpdate(nameList);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      nameList[originalIndex]['count'] = 0;
                      onUpdate(nameList);
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
