import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hard_challenge/utils/colors.dart';

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