import 'package:flutter/material.dart';

enum TaskType {
  task,
  count,
  time,
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
  reOpen
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
  List<String> notificationTime;
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
}
