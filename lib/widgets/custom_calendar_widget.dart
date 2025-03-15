import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarWidget extends StatefulWidget {
  final Function(DateTime, DateTime) onDateSelected; // Pass two DateTime objects
  final DateTime focusedDate;
  final DateTime selectedDate;

  const CustomCalendarWidget({
    required this.onDateSelected,
    required this.focusedDate,
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCalendarWidgetState createState() => _CustomCalendarWidgetState();
}

class _CustomCalendarWidgetState extends State<CustomCalendarWidget> {
  late DateTime focusedDate;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    focusedDate = widget.focusedDate;
    selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          availableGestures: AvailableGestures.none,//this single code will solve
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: focusedDate,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDate, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              selectedDate = setSelectedDate(selectedDay); // Update the selected date
              this.focusedDate = focusedDay;
            });

            // Call the onDateSelected callback with both the selected and focused dates
            widget.onDateSelected(selectedDay, focusedDay);
            Navigator.of(context).pop(); // Close the modal after selection
          },
          calendarFormat: CalendarFormat.month,
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Colors.grey, // Custom color for weekdays (Mon - Fri)
              fontWeight: FontWeight.normal, // Custom font weight
              fontSize: 16, // Custom font size
            ),
            weekendStyle: TextStyle(
              color: Colors.grey, // Custom color for weekends (Sat, Sun)
              fontWeight: FontWeight.normal, // Custom font weight
              fontSize: 16, // Custom font size
            ),
          ),
          calendarStyle: const CalendarStyle(
            tablePadding: EdgeInsets.only(left: 10, right: 10),
            rowDecoration: BoxDecoration(
            ),
          ),

          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false, // Hide the format button
            headerPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            headerMargin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey, // Background color for header
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow for the header
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 18.0,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),


          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.blue, // Background color for selected date
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: Colors.white, // Text color for selected date
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            todayBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            },
            defaultBuilder: (context, date, _) {
              return Container(
                margin: const EdgeInsets.all(5.0),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                alignment: Alignment.center,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            },

            // headerTitleBuilder: (context, focusedDay) {
            //   String formattedDate = DateFormat('MMMM yyyy').format(focusedDay);
            //
            //   return Container(
            //     height: 20,
            //     margin: EdgeInsets.zero,
            //     // decoration: BoxDecoration(
            //     //   color: Colors.blueAccent,
            //     //   borderRadius: BorderRadius.circular(12.0),
            //     // ),
            //
            //     child: Center(
            //       child: Text(
            //         formattedDate,
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 18.0,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   );
            // },
          ),
        ),
      ),
    );
  }
}
