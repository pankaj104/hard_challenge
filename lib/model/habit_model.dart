import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TaskType {
  normal,
  timer,
  value,
}

enum RepeatType {
  daily,
  selectDays,
  selectedDate,
}

class Habit {
  String title;
  String category;
  TimeOfDay notificationTime;
  TaskType taskType;
  RepeatType repeatType;
  Duration? timer;
  int? value;
  Map<DateTime, double> progress;
  List<int>? days;
  List<DateTime>? selectedDates;
  DateTime? startDate;
  DateTime? endDate;

  Habit({
    required this.title,
    required this.category,
    required this.notificationTime,
    required this.taskType,
    required this.repeatType,
    this.timer,
    this.value,
    required this.progress,
    this.days,
    this.selectedDates,
    this.startDate,
    this.endDate,
  });

  @override
  String toString() {
    return 'Habit(title: $title, category: $category, notificationTime: $notificationTime, taskType: $taskType, repeatType: $repeatType, timer: $timer, value: $value, progress: $progress, days: $days, startDate: $startDate, endDate: $endDate, selectedDates: $selectedDates)';
  }

  double getCompletionPercentage() {
    int totalDays = 0;
    int completedDays = progress.values.where((progress) => progress == 1.0).length;

    if (repeatType == RepeatType.daily) {

      totalDays = endDate!.difference(startDate!).inDays;     // totalDays = progress.length;

    } else if (repeatType == RepeatType.selectDays) {
      // Calculate for habits with selected days

      DateTime? loopDate = startDate!;

      while (loopDate!.isBefore(endDate!) || loopDate.isAtSameMomentAs(endDate!)) {
        // Check if the current day matches any selected day
        if (days!.contains(loopDate.weekday % 7)) { // % 7 to handle Sunday being 7 in DateTime
          totalDays++;
        }
        // Move to the next day
        loopDate = loopDate.add(Duration(days: 1));
      }




      // totalDays = days?.length ?? 1;
    } else if (repeatType == RepeatType.selectedDate) {
      // Calculate for habits with specific dates
      totalDays = selectedDates?.length ?? 1;
    }

    return totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;
  }



}

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'category': category,
//       'notificationTime': _timeOfDayToString(notificationTime),
//       'taskType': taskType.index,
//       'repeatType': repeatType.index,
//       'timer': timer?.inMinutes,
//       'value': value,
//       'progress': progress.map((date, completed) => MapEntry(date.toIso8601String(), completed)),
//       'days': days,
//       'selectedDates': selectedDates?.map((date) => date.toIso8601String()).toList(),
//       'startDate': startDate?.toIso8601String(),
//       'endDate': endDate?.toIso8601String(),
//     };
//   }
//
//   static Habit fromMap(Map<String, dynamic> map) {
//     return Habit(
//       title: map['title'],
//       category: map['category'],
//       notificationTime: _parseTimeOfDay(map['notificationTime']),
//       taskType: TaskType.values[map['taskType']],
//       repeatType: RepeatType.values[map['repeatType']],
//       timer: map['timer'] != null ? Duration(minutes: map['timer']) : null,
//       value: map['value'],
//       progress: (map['progress'] as Map<String, dynamic>).map((date, completed) => MapEntry(DateTime.parse(date), completed)),
//       days: map['days']?.cast<int>(),
//       selectedDates: map['selectedDates']?.map((date) => DateTime.parse(date)).cast<DateTime>().toList(),
//       startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
//       endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
//     );
//   }
//
//   static String _timeOfDayToString(TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     final format = DateFormat.Hm();  // 24-hour format
//     return format.format(dt);
//   }
//
//   static TimeOfDay _parseTimeOfDay(String time) {
//     final format = DateFormat.Hm(); // 24-hour format
//     final dt = format.parse(time);
//     return TimeOfDay(hour: dt.hour, minute: dt.minute);
//   }
// }


