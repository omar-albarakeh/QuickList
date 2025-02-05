import 'package:quicklist/storage.dart';

class Data{

  List<Map<String,dynamic>> nameList=[];

  Future<void> initialize() async {
    nameList =await Storage.LoadData();
  }
  //add name
  //addCounter
  //SubtractCounter
  //RestsetCounter
}