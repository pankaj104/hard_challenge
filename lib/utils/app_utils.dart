
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// All constant in project.
import 'package:hive/hive.dart';

import 'package:hive/hive.dart';

class AppUtils {
  static final List<String> _defaultCategories = ['General', 'Sport', 'Health', 'Spiritual'];

  static List<String> get categories {
    var box = Hive.box<String>('categoriesBox');

    // Get stored categories from Hive
    List<String> storedCategories = box.values.toList();

    // Create a final list where default categories come first
    List<String> allCategories = [..._defaultCategories];

    // Append only non-default categories at the end
    for (String category in storedCategories) {
      if (!_defaultCategories.contains(category) && !allCategories.contains(category)) {
        allCategories.add(category);
      }
    }

    return allCategories;
  }

  static void addCategory(String newCategory) {
    var box = Hive.box<String>('categoriesBox');

    if (!box.values.contains(newCategory)) {
      box.add(newCategory); // Ensures new category is added at the last position
    }
  }

  static void removeCategory(String category) {
    var box = Hive.box<String>('categoriesBox');

    // Prevent deleting default categories
    if (!_defaultCategories.contains(category)) {
      int index = box.values.toList().indexOf(category);
      if (index != -1) {
        box.deleteAt(index);
      }
    }
  }
}


// final List<String> categories = ['General','Sport', 'Health', 'Spiritual'];

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