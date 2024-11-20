import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hard_challenge/utils/colors.dart';
import 'package:intl/intl.dart';

/// Invokes the toast message using [Flushbar] plugin
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
          color: ColorStrings.whiteColor,
        ),
      ),
      // message: message,
      backgroundColor: ColorStrings.greenColor,
      duration: Duration(seconds: durationInSeconds),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);

String formatStartDateToUtc(DateTime startDate) {
  // Convert the start date to UTC
  DateTime currentDate = startDate.toUtc();

  // Set the time to 00:00:00.000
  currentDate = DateTime.utc(currentDate.year, currentDate.month, currentDate.day);

  // Format the date to the desired format
  String formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'").format(currentDate);

  return formattedDate;
}