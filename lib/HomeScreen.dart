import 'package:flutter/material.dart';
import 'package:quicklist/Data_Manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredNameList = [];
  bool _isSearching = false;

  final Data _datamanager = Data();

  @override
  void initState() {
    super.initState();
    _initialize();
    _datamanager.onUpdate = _updateUI;
    _searchController.addListener(_filterNames);
  }

  Future<void> _initialize() async {
    _datamanager.initialize();
    if (mounted) {
      setState(() {
        _filteredNameList = List.from(_datamanager.nameList);
      });
    }
  }

  void _updateUI() {
    if (mounted) {
      setState(() {
        _filteredNameList = List.from(_datamanager.nameList);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterNames() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNameList = _datamanager.nameList
          .where((item) => item['name'].toLowerCase().startsWith(query))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredNameList = List.from(_datamanager.nameList);
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
            decoration: InputDecoration(
              labelText: "Enter User Name",
              labelStyle: const TextStyle(color: Colors.orange),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.orange, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            controller: _nameController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                String name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _datamanager.addName(name, context);
                }
                _nameController.clear();
                Navigator.pop(context);
              },
              child: const Text("Add", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        )
            : const Text(
          "Quick List",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
        ),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: Icon(
                _isSearching ? Icons.close : Icons.search, color: Colors.white, size: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: _filteredNameList.isEmpty
            ? const Center(
          child: Text(
            "No Names Added",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        )
            : ListView.builder(
          itemCount: _filteredNameList.length,
          itemBuilder: (context, index) {
            final nameItem = _filteredNameList[index];
            return Dismissible(
              key: Key(nameItem["name"]),
              direction: DismissDirection.horizontal,
              background: _buildDismissibleBackground(Alignment.centerLeft),
              secondaryBackground: _buildDismissibleBackground(Alignment.centerRight),
              onDismissed: (direction) {
                setState(() {
                  _datamanager.removeName(index,context);
                  _filteredNameList.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${nameItem["name"]} deleted")),
                );
              },
              child: ListTile(
                leading: Text("${index + 1}- ", style: const TextStyle(fontSize: 19)),
                title: Text(" ${nameItem["name"]}", style: const TextStyle(fontSize: 15)),
                subtitle: Text("Count: ${nameItem["count"]}", style: const TextStyle(fontSize: 15)),
                trailing: _buildCounterButtons(index),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: _showDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDismissibleBackground(Alignment alignment) {
    return Container(
      color: Colors.red,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  Widget _buildCounterButtons(int index) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _counterButton(() => _datamanager.incrementCounter(index), Icons.keyboard_double_arrow_up_sharp, Colors.green),
          const SizedBox(width: 10,),
          _counterButton(() => _datamanager.decrementCounter(index, context), Icons.keyboard_double_arrow_down_sharp, Colors.red),
          const SizedBox(width: 10,),
          _counterButton(() => _datamanager.resetCounter(index, context), Icons.refresh, Colors.orange),
        ],
      ),
    );
  }

  Widget _counterButton(VoidCallback onTap, IconData icon, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
