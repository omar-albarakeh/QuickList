import 'package:flutter/material.dart';
import 'package:quicklist/HomeScreen.dart';


class QuickList extends StatelessWidget {
  const QuickList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}