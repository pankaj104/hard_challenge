import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/colors.dart';
import '../utils/image_resource.dart';

class CalendarPage extends StatefulWidget {
  final Habit habit;

  const CalendarPage({super.key, required this.habit});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
    void initState(){
    super.initState();
    habitDoneDateStore(widget.habit);
    habitSkippedDateStore(widget.habit);
    habitMissedDateStore(widget.habit);
}

  List<DateTime> habitDoneDateStore(Habit habit){
    List<DateTime> habitDoneDateList = [];
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.done){
        habitDoneDateList.add(date);
      }
    });
    return habitDoneDateList;
  }

  List<DateTime> habitOngoingOnDateStore(Habit habit){
    List<DateTime> habitOnGoingOnDateList = [];
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.goingOn){
        habitOnGoingOnDateList.add(date);
      }
    });
    return habitOnGoingOnDateList;
  }


  List<DateTime> habitSkippedDateStore(Habit habit){
    List<DateTime> habitSkippedDateList= [];
    habit.progressJson.forEach((date, progress) {
      if(progress.status == TaskStatus.skipped){
        habitSkippedDateList.add(date);
      }
    });
    // log('habitSkippedDateList $habitSkippedDateList');
    return habitSkippedDateList;
  }

  List<DateTime> habitMissedDateStore(Habit habit) {
    List<DateTime> habitMissedDateList = [];
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day); // Reset time to midnight

    DateTime habitStartDate = habit.startDate ?? now;
    DateTime startDate = habitStartDate;
    DateTime endDate = habit.endDate ?? now;
    for (DateTime date = startDate;
    date.isBefore(endDate.add(const Duration(days: 1)));
    date = date.add(const Duration(days: 1))) {
      // Skip today's date and future dates
      if (date.isAfter(now) || date.isAtSameMomentAs(now)) {
        continue;
      }

      bool isValidDate = false;
      switch (habit.repeatType) {
        case RepeatType.selectDays:
          if (habit.days != null && habit.days!.contains(date.weekday)) {
            isValidDate = true;
          }
          break;

        case RepeatType.selectedDate:
          if (habit.selectedDates != null && habit.selectedDates!.contains(date)) {
            isValidDate = true;
          }
          break;

        case RepeatType.weekly:
          if (habit.days != null && habit.days!.contains(date.weekday % 7)) {
            isValidDate = true;
          }
          break;

        case RepeatType.monthly:
          if (habit.selectedDates != null &&
              habit.selectedDates!.any((d) => d.month == date.month && d.day == date.day)) {
            isValidDate = true;
          }
          break;

        default:
          break;
      }

      // If the date is valid and missed, add it to the list
      if (isValidDate &&
          (!habit.progressJson.containsKey(date) ||
              (habit.progressJson[date]!.status != TaskStatus.done &&
                  habit.progressJson[date]!.status != TaskStatus.skipped))) {
        habitMissedDateList.add(date);
      }
    }

    return habitMissedDateList;
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          headerVisible: true,
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          // calendarStyle:
          // CalendarStyle(
          //
          //   // selectedDecoration: BoxDecoration(
          //   //   color: Colors.blue,
          //   //   shape: BoxShape.circle,
          //   //   // borderRadius: BorderRadius.circular(9.6),
          //   // ),
          // ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            // Customize weekdays row
            weekdayStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
          ),
          headerStyle:  HeaderStyle(
            titleTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 16),
            leftChevronIcon: SvgPicture.asset(
              ImageResource.calenderLeft,
            ),
            rightChevronIcon: SvgPicture.asset(
              ImageResource.calenderRight,
            ),
            formatButtonVisible: false,
            titleCentered: true,
          ),
          // Customize day cell builders
          calendarBuilders: CalendarBuilders(
            outsideBuilder: (context, date, events) {
              return GestureDetector(
                onTap: () {
                  // Move to the selected month
                  // widget.calendarController.setSelectedDay(date, animate: true);
                },
                child: Center(
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: ColorStrings.silverColor.withOpacity(0.1), // Background color for days outside the current month
                      borderRadius: BorderRadius.circular(36),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                      //     spreadRadius: 0.4, // Light spread for subtle effect
                      //     blurRadius: 1, // Smooth blur for softer shadow
                      //     offset: const Offset(0, 2), // Shadow slightly below the element
                      //   ),
                      // ],
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400), // White text color for outside days
                      ),
                    ),
                  ),
                ),
              );
            },
            defaultBuilder: (context, date, events) {
              Widget buildContainer({required Color color, required Widget child}) {
                return GestureDetector(
                  onTap: (widget.habit.startDate.isBefore(setSelectedDate(date)) || isSameDay(widget.habit.startDate, setSelectedDate(date))) &&
                      (widget.habit.endDate!.isAfter(setSelectedDate(date)) || isSameDay(widget.habit.endDate, setSelectedDate(date)))
                      ? () {
                    showNoteDialog(context, setSelectedDate(date));
                  }
                      : null, // Disable tap if outside the range
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25), // Subtle grey shadow
                                spreadRadius: 0.4,
                                blurRadius: 1,
                                offset: const Offset(0, 2), // Shadow slightly below
                              ),
                            ],
                          ),
                          child: Center(child: child),
                        ),
                        // Show orange dot if a note exists for the date
                        if (widget.habit.notesForReason?.keys.any((d) => isSameDay(d, date)) ?? false)
                          customDotDesign(),
                      ],
                    ),
                  ),
                );
              }
              if (habitOngoingOnDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                ProgressWithStatus? progressStatus = widget.habit
                    .progressJson[setSelectedDate(date)];
                double progressValue = progressStatus?.progress ?? 0.0;
                return GestureDetector(
                  onTap: (){
                    showNoteDialog(context, setSelectedDate(date));
                  },
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                            strokeWidth: 4,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25), // Subtle grey shadow
                                spreadRadius: 0.4,
                                blurRadius: 1,
                                offset: const Offset(0, 2), // Shadow slightly below
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${(progressValue*100).toInt()}%',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13), // White text color for outside days
                            ),
                          ),
                        ),
                        // Show orange dot if a note exists for the date
                        if (widget.habit.notesForReason?.keys.any((d) => isSameDay(d, date)) ?? false)
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orange, // Badge color when notes exist
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                              )),
                      ],
                    ),
                  ),
                );
              }

              if (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: widget.habit.habitType == HabitType.quit ? Colors.green : Colors.red,
                  child: Icon(
                    widget.habit.habitType == HabitType.quit ? Icons.done : Icons.close,
                    color: ColorStrings.whiteColor,
                    size: 18,
                  ),
                );
              }

              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: widget.habit.habitType == HabitType.quit ? Colors.red : Colors.green,
                  child: Icon(
                    widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done,
                    color: ColorStrings.whiteColor,
                    size: 18,
                  ),
                );
              }

              if (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: Colors.amberAccent,
                  child: const Icon(Icons.last_page, color: ColorStrings.whiteColor),
                );
              }
              
              return buildContainer(
                color: ColorStrings.whiteColor,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                ),
              );
            },
            todayBuilder: (context, date, events) {
              Widget buildContainer({required Color color, required Widget child}) {
                return GestureDetector(
                  onTap: (widget.habit.startDate.isBefore(setSelectedDate(date)) || isSameDay(widget.habit.startDate, setSelectedDate(date))) &&
                      (widget.habit.endDate!.isAfter(setSelectedDate(date)) || isSameDay(widget.habit.endDate, setSelectedDate(date)))
                      ? () {
                    showNoteDialog(context, setSelectedDate(date));
                  }
                      : null, // Disable tap if outside the range
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25), // Subtle grey shadow
                                spreadRadius: 0.4,
                                blurRadius: 1,
                                offset: const Offset(0, 2), // Shadow slightly below
                              ),
                            ],
                          ),
                          child: Center(child: child),
                        ),
                        // Show orange dot if a note exists for the date
                        if (widget.habit.notesForReason?.keys.any((d) => isSameDay(d, date)) ?? false)
                          customDotDesign(),
                      ],
                    ),
                  ),
                );
              }

              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: widget.habit.habitType == HabitType.quit ? Colors.red : Colors.green,
                  child: Icon(
                    widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done,
                    color: ColorStrings.whiteColor,
                    size: 18,
                  ),
                );
              }

              if (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: Colors.amberAccent,
                  child: const Icon(Icons.last_page, color: ColorStrings.whiteColor),
                );
              }

              if (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: widget.habit.habitType == HabitType.quit ? Colors.green : Colors.red,
                  child: Icon(
                    widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done,
                    color: ColorStrings.whiteColor,
                    size: 18,
                  ),
                );
              }

              if (habitOngoingOnDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                ProgressWithStatus? progressStatus = widget.habit
                    .progressJson[setSelectedDate(date)];
                double progressValue = progressStatus?.progress ?? 0.0;
                return GestureDetector(
                  onTap: (){
                    showNoteDialog(context, setSelectedDate(date));
                  },
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                            strokeWidth: 4,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25), // Subtle grey shadow
                                spreadRadius: 0.4,
                                blurRadius: 1,
                                offset: const Offset(0, 2), // Shadow slightly below
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${(progressValue*100).toInt()}%',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13), // White text color for outside days
                            ),
                          ),
                        ),
                        // Show orange dot if a note exists for the date
                        if (widget.habit.notesForReason?.keys.any((d) => isSameDay(d, date)) ?? false)
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orange, // Badge color when notes exist
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                              )),
                      ],
                    ),
                  ),
                );
              }


              return buildContainer(
                color: ColorStrings.whiteColor,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                ),
              );
            },
            selectedBuilder: (context, date, events) {
              Widget buildContainer({required Color color, required Widget child}) {
                return GestureDetector(
                  onTap: (widget.habit.startDate.isBefore(setSelectedDate(date)) || isSameDay(widget.habit.startDate, setSelectedDate(date))) &&
                      (widget.habit.endDate!.isAfter(setSelectedDate(date)) || isSameDay(widget.habit.endDate, setSelectedDate(date)))
                      ? () {
                    showNoteDialog(context, setSelectedDate(date));
                  }
                      : null, // Disable tap if outside the range
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25), // Subtle grey shadow with transparency
                                spreadRadius: 0.4,
                                blurRadius: 1,
                                offset: const Offset(0, 2), // Shadow slightly below the element
                              ),
                            ],
                          ),
                          child: Center(child: child),
                        ),
                        // Show orange dot if a note exists for the date
                        if (widget.habit.notesForReason?.keys.any((d) => isSameDay(d, date)) ?? false)
                          customDotDesign(),
                      ],
                    ),
                  ),
                );
              }

              if (habitDoneDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: widget.habit.habitType == HabitType.quit ? Colors.red : Colors.green,
                  child: Icon(
                    widget.habit.habitType == HabitType.quit ? Icons.close : Icons.done,
                    color: ColorStrings.whiteColor,
                    size: 18,
                  ),
                );
              }

              if (habitSkippedDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: Colors.amberAccent,
                  child: const Icon(Icons.last_page, color: ColorStrings.whiteColor),
                );
              }

              if (habitMissedDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                return buildContainer(
                  color: ColorStrings.whiteColor,
                  child: Text(
                    '${date.day}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                );
              }

              if (habitOngoingOnDateStore(widget.habit).any((element) => isSameDay(element, setSelectedDate(date)))) {
                ProgressWithStatus? progressStatus = widget.habit
                    .progressJson[setSelectedDate(date)];
                double progressValue = progressStatus?.progress ?? 0.0;
                return GestureDetector(
                  onTap: (){
                    showNoteDialog(context, setSelectedDate(date));
                  },
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            value: progressValue,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                            strokeWidth: 4,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25), // Subtle grey shadow
                                spreadRadius: 0.4,
                                blurRadius: 1,
                                offset: const Offset(0, 2), // Shadow slightly below
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${(progressValue*100).toInt()}%',
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 13), // White text color for outside days
                            ),
                          ),
                        ),
                        // Show orange dot if a note exists for the date
                        if (widget.habit.notesForReason?.keys.any((d) => isSameDay(d, date)) ?? false)
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: Colors.orange, // Badge color when notes exist
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                              )),
                      ],
                    ),
                  ),
                );
              }


              return buildContainer(
                color: ColorStrings.cyanColor,
                child: Text(
                  '${date.day}',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                ),
              );
            },
          ),
        ),

    );
  }

  void showNoteDialog(BuildContext context, DateTime notesForThisDate) {
    HabitProvider habitProvider = Provider.of<HabitProvider>(context, listen: false);
    String existingNote = habitProvider.getNoteForDate(widget.habit.id, setSelectedDate(notesForThisDate)) ?? '';

    TextEditingController _noteController = TextEditingController(text: existingNote);
    ValueNotifier<bool> isTextEmpty = ValueNotifier(existingNote.isEmpty);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Enter your Note reason here',
                  border: InputBorder.none,
                ),
                maxLines: 3,
                onChanged: (text) {
                  isTextEmpty.value = text.trim().isEmpty;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isTextEmpty,
                      builder: (context, isEmpty, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: isEmpty
                              ? null
                              : () {
                            String note = _noteController.text.trim();
                            habitProvider.addFeedbackToHabit(widget.habit.id, setSelectedDate(notesForThisDate), note);
                            Navigator.pop(context);
                            log("Saved Note: $note for date: ${setSelectedDate(notesForThisDate)}");
                          },
                          child: Text(existingNote.isEmpty ? 'Save' : 'Update', style: const TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget customDotDesign()
  {
    return Positioned(
        bottom: -2,
        right: -2,
        child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
        color: Colors.orange, // Badge color when notes exist
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
    ),
    ));
    }
}