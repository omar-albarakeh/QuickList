import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
   List<Map<String ,dynamic>> _nameList =[];

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

  Future<String> _AddName(String name){

  }

 Widget _showDialog(){
     showDialog(
         context: context,
         builder:(context){
           return AlertDialog(
             title: Text("Add Name "),
             content: TextField(
               decoration: InputDecoration(
                 labelText: "Enter User Name"
               ),
               controller: _nameController,
             ) ,
             actions: [
               TextButton(
                   onPressed: (){
                     _nameController.clear();
                     Navigator.pop(context);
                   },
                   child: Text("cancel")
               ),
               TextButton(
                   onPressed: (){
                     String name=_nameController.text.trim();
                     if( name.isNotEmpty)
                       {
                         _AddName(name);
                       }
                     Navigator.pop(context);
                   },
                   child: Text("Add")
               ),
             ],
           )
         }
    );
 }
}
