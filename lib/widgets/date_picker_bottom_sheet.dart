import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'custom_calendar_widget.dart';

class CustomDatePickerBottomSheet {
  static void showDatePicker(
      BuildContext context, DateTime initialDate, Function(String, DateTime) onDateSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        DateTime selectedDate = initialDate;
        DateTime focusedDate = initialDate;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Custom AppBar with Close Icon
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
                        // Remove done icon, now empty space for balance
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // TableCalendar widget

                  CustomCalendarWidget(onDateSelected: (selectedDay , focusedDay ) {

                    selectedDate = selectedDay; // Update the selected date
                    String formattedDate = DateFormat('d MMM y').format(selectedDate);
                    onDateSelected(formattedDate, selectedDate);
                  }, focusedDate: focusedDate, selectedDate: selectedDate,),

                  // Expanded(
                  //   child: TableCalendar(
                  //     firstDay: DateTime.utc(2000, 1, 1),
                  //     lastDay: DateTime.utc(2100, 12, 31),
                  //     focusedDay: focusedDate,
                  //     selectedDayPredicate: (day) {
                  //       return isSameDay(selectedDate, day);
                  //     },
                  //     onDaySelected: (selectedDay, focusedDay) {
                  //       selectedDate = selectedDay; // Update the selected date
                  //       String formattedDate = DateFormat('d MMM y').format(selectedDate);
                  //       onDateSelected(formattedDate, selectedDate);
                  //       Navigator.of(context).pop(); // Close the modal after selection
                  //     },
                  //     calendarFormat: CalendarFormat.month,
                  //     headerStyle: const HeaderStyle(
                  //       formatButtonVisible: false,  // Hide the format button
                  //       titleCentered: true,        // Center the month title
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
