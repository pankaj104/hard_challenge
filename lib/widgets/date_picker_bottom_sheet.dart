import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePickerBottomSheet {
  static void showDatePicker(
      BuildContext context, DateTime initialDate, Function(String, DateTime) onDateSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = initialDate;

        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Custom AppBar with Close and Check Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      'Select Date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        String formattedDate = DateFormat('d MMM y').format(selectedDate);
                        onDateSelected(formattedDate, selectedDate); // Pass the selected date back
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Cupertino Date Picker in Date Mode
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: selectedDate, // Use the previously selected date as initial date
                  onDateTimeChanged: (DateTime newDateTime) {
                    selectedDate = newDateTime;
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
