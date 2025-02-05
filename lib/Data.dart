import 'package:quicklist/storage.dart';

class Data{

  List<Map<String,dynamic>> nameList=[];

  Future<void> initialize() async {
    nameList =await Storage.LoadData();
  }
  //add name
void AddName(String name){
    if(name.isNotEmpty && !nameList.any((item)=> item['name'] == name)){
      nameList.add({"name" : name , "Count" : 0});
      Storage.saveData(nameList);
    }
}
  //addCounter
void AddCounter(index){
    nameList[index]['count'] +=1;
    Storage.saveData(nameList);
}
  //SubtractCounter
void SubtractCounter(index){
    nameList[index]['count'] -=1;
    Storage.saveData(nameList);
}
  //RestsetCounter
}