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
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _nameList.isEmpty
              ? const Center(
                  child: Text(
                    "No Names Added",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _nameList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Text("${index + 1}",
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(
                          "${_nameList[index]['name']}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text("Count: ${_nameList[index]['count']}",
                            style: const TextStyle(fontSize: 16)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildIconButton(Icons.keyboard_arrow_up,
                                Colors.green, () => _updateCount(index)),
                            const SizedBox(width: 8),
                            _buildIconButton(Icons.keyboard_arrow_down,
                                Colors.red, () => _downGradeCount(index)),
                            const SizedBox(width: 8),
                            _buildIconButton(Icons.refresh, Colors.blue,
                                () => _resetCount(index)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.5), blurRadius: 5),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 24),
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
    });
  }

  void _downGradeCount(int index) {
    setState(() {
      _nameList[index]['count'] =
          (_nameList[index]['count'] > 0) ? _nameList[index]['count'] - 1 : 0;
    });
  }

  void _resetCount(int index) {
    setState(() {
      _nameList[index]['count'] = 0;
    });
  }

  Future<void> _showDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange[50],
          title: const Text("Add Name"),
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
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.orange)),
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
