import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'QuickList.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //test
  runApp(const QuickList());
}