// main.dart
import 'package:flutter/material.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:provider/provider.dart';

import 'main_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'Custom Challenge App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
      ),
    );
  }
}
