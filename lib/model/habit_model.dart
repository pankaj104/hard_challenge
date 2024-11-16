// habit_model.dart
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

enum HabitType {
  build,
  quit
}

enum TaskStatus {
  done,
  missed,
  skipped,
  reOpen,
  goingOn
}

class ProgressWithStatus {
  TaskStatus status;
  double progress;
  Duration? duration;

  ProgressWithStatus({
    required this.status,
    required this.progress,
    this.duration,
  });

  // Add fromMap method
  factory ProgressWithStatus.fromMap(Map<String, dynamic> map) {
    return ProgressWithStatus(
      status: TaskStatus.values[map['status']], // Assumes status is saved as an int index
      progress: map['progress'],
      duration: map['duration'] != null ? Duration(seconds: map['duration']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.index, // Save the enum as an index
      'progress': progress,
      'duration': duration?.inSeconds, // Save duration as seconds
    };
  }

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
  HabitType habitType;
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
    required this.habitType,
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
        'taskType: $taskType, habitType: $habitType, repeatType: $repeatType, timer: $timer, value: $value, '
        'progress: $progressJson, days: $days, startDate: $startDate, endDate: $endDate, selectedDates: $selectedDates, '
        'selectedTimesPerWeek: $selectedTimesPerWeek, selectedTimesPerMonth: $selectedTimesPerMonth, notes: $notes)';
  }
}
