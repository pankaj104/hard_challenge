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
  selectDays,
  weekly,
  monthly,
  selectedDate,
}

enum TaskStatus {
  done,
  missed,
  skipped,
}

class ProgressWithStatus {
  TaskStatus status;
  double progress;

  ProgressWithStatus({required this.status, required this.progress});

  @override
  String toString() {
    return 'Progress(status: $status, progress: $progress)';
  }
}

class Habit {
  String title;
  String category;
  IconData habitIcon;
  Color iconBgColor;
  TimeOfDay notificationTime;
  TaskType taskType;
  RepeatType repeatType;
  Duration? timer;
  int? value;
  Map<DateTime, ProgressWithStatus> progressJson;
  List<int>? days;
  List<DateTime>? selectedDates;
  int? selectedTimesPerWeek;
  int? selectedTimesPerMonth;
  DateTime? startDate;
  DateTime? endDate;
  String? notes;

  Habit({
    required this.title,
    required this.category,
    required this.habitIcon,
    required this.iconBgColor,
    required this.notificationTime,
    required this.taskType,
    required this.repeatType,
    this.timer,
    this.value,
    required this.progressJson,
    this.days,
    this.selectedDates,
    this.selectedTimesPerWeek,
    this.selectedTimesPerMonth,
    this.startDate,
    this.endDate,
    this.notes,
  });

  @override
  String toString() {
    return 'Habit(title: $title, category: $category,  habitIcon: $habitIcon, IconBgColor: $iconBgColor notificationTime: $notificationTime, '
        'taskType: $taskType, repeatType: $repeatType, timer: $timer, value: $value, '
        'progress: $progressJson, days: $days, startDate: $startDate, endDate: $endDate, selectedDates: $selectedDates, '
        'selectedTimesPerWeek: $selectedTimesPerWeek, selectedTimesPerMonth: $selectedTimesPerMonth, notes: $notes)';
  }

  double getCompletionPercentage() {
    int totalDays = 0;
    int completedDays = progressJson.values.where((p) => p.status == TaskStatus.done).length;

    if (repeatType == RepeatType.selectDays) {
      DateTime? loopDate = startDate;

      while (loopDate!.isBefore(endDate!) || loopDate.isAtSameMomentAs(endDate!)) {
        if (days!.contains(loopDate.weekday % 7)) {
          totalDays++;
        }
        loopDate = loopDate.add(Duration(days: 1));
      }
    } else if (repeatType == RepeatType.selectedDate) {
      totalDays = selectedDates?.length ?? 1;
    } else if (repeatType == RepeatType.weekly) {
      totalDays = countTaskDays(startDate!, endDate!, selectedTimesPerWeek!);
    } else if (repeatType == RepeatType.monthly) {
      totalDays = selectedDates?.length ?? 1;
    }

    return totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;
  }

  int countTaskDays(DateTime startDate, DateTime endDate, int taskDays) {
    if (startDate.isAfter(endDate)) {
      throw ArgumentError('Start date must be before end date');
    }

    int totalDays = endDate.difference(startDate).inDays + 1;
    int fullWeeks = totalDays ~/ 7;
    int totalTaskDays = fullWeeks * taskDays;

    int remainingDays = totalDays % 7;
    if (remainingDays > 0) {
      totalTaskDays += (remainingDays >= taskDays) ? taskDays : remainingDays;
    }
    log("selectedTimesPerWeek:  $selectedTimesPerWeek");

    return totalTaskDays;
  }

  void markTaskAsDone(DateTime date) {
    progressJson[date] = ProgressWithStatus(status: TaskStatus.done, progress: 1.0);
  }

  void markTaskAsMissed(DateTime date) {
    progressJson[date] = ProgressWithStatus(status: TaskStatus.missed, progress: 0.0);
  }

  void markTaskAsSkipped(DateTime date) {
    progressJson[date] = ProgressWithStatus(status: TaskStatus.skipped, progress: 0.0);
  }

  void updateProgress(DateTime date, double progressValue) {
    if (progressJson.containsKey(date)) {
      progressJson[date]!.progress = progressValue;
    } else {
      progressJson[date] = ProgressWithStatus(status: TaskStatus.done, progress: progressValue);
    }
  }
  

  double getSkippedPercentage() {
    int totalDays = 0;
    int skippedCount = 0;


    progressJson.values.forEach((progress) {
      if (progress.status == TaskStatus.skipped) {
        skippedCount++;
      }
    });

    if (repeatType == RepeatType.selectDays) {
      DateTime? loopDate = startDate;

      while (loopDate!.isBefore(endDate!) || loopDate.isAtSameMomentAs(endDate!)) {
        if (days!.contains(loopDate.weekday % 7)) {
          totalDays++;
        }
        loopDate = loopDate.add(const Duration(days: 1));
      }
    } else if (repeatType == RepeatType.selectedDate) {
      totalDays = selectedDates?.length ?? 1;
    } else if (repeatType == RepeatType.weekly) {
      totalDays = countTaskDays(startDate!, endDate!, selectedTimesPerWeek!);
    } else if (repeatType == RepeatType.monthly) {
      totalDays = selectedDates?.length ?? 1;
    }

    return  totalDays > 0 ? (skippedCount / totalDays) * 100 : 0.0;
  }


}
