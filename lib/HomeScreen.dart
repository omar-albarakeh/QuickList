import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> _nameList = [];

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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: _nameList.isEmpty
            ? Center(
                child: Text("No Names Added"),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _nameList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text("${index + 1} ."),
                    title: Text(" ${_nameList[index]['name']}"),
                    subtitle: Text("Count: ${_nameList[index]['count']}"),
                    trailing: SizedBox(
                      width: 50,
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
                                Icons.add,
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
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _AddName(String name) {
    if (name.isNotEmpty && !_nameList.any((item) => item['name'] == name)) {
      setState(() {
        _nameList.add({'name': name, 'count': 0});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name already added")),
      );
    }
  }

  void _updateCount(int index) {
    setState(() {
      _nameList[index]['count'] += 1;
      if (_nameList[index]['count'] < 0) {
        _nameList[index]['count'] = 0;
      }
    });
  }

  Future<void> _showDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Name"),
          content: TextField(
            decoration: const InputDecoration(labelText: "Enter User Name"),
            controller: _nameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String name = _nameController.text;
                if (name.isNotEmpty) {
                  _AddName(name);
                }
                _nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
