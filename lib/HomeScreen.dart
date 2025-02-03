import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();

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
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              right: 20,
              child: FloatingActionButton(
                onPressed: () => _showDialog(),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _showDialog(){
     showDialog(
         context: context,
         builder:(context){
           return AlertDialog(
             title: Text("Enter user name "),
             content: ,
             actions: [
               
             ],
           )
         }
    );
 }
}
