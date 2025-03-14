import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hard_challenge/utils/colors.dart';
import 'package:intl/intl.dart';

/// Invokes the toast message using [Flushbar] plugin
Flushbar showFlushBarHelper(
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
          color: ColorStrings.whiteColor,
        ),
      ),
      // message: message,
      backgroundColor:const Color(0xFF644646), // Dark Grey with a slight blue tint
      duration: Duration(seconds: durationInSeconds),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);


DateTime setSelectedDate(DateTime date) {
  // Set _selectedDate to only the date part
  return DateTime(date.year, date.month, date.day);
}
int convertToIconData(String iconDataString) {
  // Extract the part after 'IconData(' and before ')'
  final regex = RegExp(r'IconData\((U\+[0-9A-Fa-f]+)\)');
  final match = regex.firstMatch(iconDataString);

  if (match != null) {
    // Get the Unicode part (e.g., U+0F810)
    final unicode = match.group(1)!;

    // Remove the 'U+' and convert the remaining part to an integer
    return int.parse(unicode.replaceAll('U+', ''), radix: 16);
  }

  // Return a default value if no match found (error handling)
  throw FormatException('Invalid IconData format');
}


