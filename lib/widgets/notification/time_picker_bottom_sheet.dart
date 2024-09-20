import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimePickerBottomSheet {
  static void showTimePicker(BuildContext context, Function(String) onTimeSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedTime = DateTime.now();

        return Container(
          height: 300,
          child: Column(
            children: [
              // Custom AppBar with Close and Check Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      'Add Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        // Format the selected time to AM/PM format
                        String formattedTime = "${selectedTime.hour % 12 == 0 ? 12 : selectedTime.hour % 12}"
                            ":${selectedTime.minute.toString().padLeft(2, '0')} "
                            "${selectedTime.hour >= 12 ? 'PM' : 'AM'}";
                        onTimeSelected(formattedTime);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Cupertino Date Picker in Time Mode
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedTime,
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedTime = newDateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
