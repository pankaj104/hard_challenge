
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

// All constant in project.

final List<String> categories = ['General', 'Work', 'Health', 'Other'];

final List<int> selectedDays = [1, 2, 3, 4, 5, 6, 7];
//Repeat type container items
final List<String> repeatItems = ['Selected Days', 'Weekly', 'Monthly', 'Selected Date' ];



final List<Color> predefinedColors = [
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.purple,
  Colors.red,
];

Flushbar showFlushBar(
    BuildContext context, {
      required String message,
      int durationInSeconds = 3,
    }) =>
    Flushbar<dynamic>(
      messageText: Text(
        message,
        // maxLines: 20,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      // message: message,
      backgroundColor: Colors.pink,
      duration: Duration(seconds: durationInSeconds),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);