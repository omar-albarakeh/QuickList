import 'package:flutter/material.dart';
import 'package:quicklist/Data.dart';

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
    await _datamanager.initialize();
    setState(() {
      _filteredNameList = List.from(_datamanager.nameList);
    });
  }
  void _updateUI() {
    setState(() {
      _filteredNameList = List.from(_datamanager.nameList);
    });
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
              child: const Text("Cancel", style: TextStyle(color: Colors.orange)),
            ),
            TextButton(
              onPressed: () {
                String name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  _datamanager.addName(name,context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
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
                _isSearching ? Icons.close : Icons.search, color: Colors.white,
                size: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: _filteredNameList.isEmpty
            ? Center(
          child: Text(
            "No Names Added",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        )
            : ListView.builder(
          itemCount: _filteredNameList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text("${index + 1}- ",
                style: TextStyle(fontSize: 19),),
              title: Text(
                " ${_filteredNameList[index]['name']}",
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                "Count: ${_filteredNameList[index]['count']}",
                style: TextStyle(fontSize: 15),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _datamanager.addCounter(index),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.keyboard_double_arrow_up_sharp,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _datamanager.subtractCounter(index,context),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.keyboard_double_arrow_down_sharp,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _datamanager.resetCounter(index ,context),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20,
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

}
