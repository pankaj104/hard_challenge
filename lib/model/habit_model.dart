import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'habit_model.g.dart'; // Add this import for generated code

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

@HiveType(typeId: 0)
class ProgressWithStatus {
  @HiveField(0)
  TaskStatus status;

  @HiveField(1)
  double progress;

  @HiveField(2)
  Duration? duration;

  ProgressWithStatus({
    required this.status,
    required this.progress,
    this.duration,
  });

  factory ProgressWithStatus.fromMap(Map<String, dynamic> map) {
    return ProgressWithStatus(
      status: TaskStatus.values[map['status']],
      progress: map['progress'],
      duration: map['duration'] != null ? Duration(seconds: map['duration']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.index,
      'progress': progress,
      'duration': duration?.inSeconds,
    };
  }

  @override
  String toString() {
    return 'Progress(status: $status, progress: $progress)';
  }
}

@HiveType(typeId: 1)
class Habit {
  @HiveField(0)
  String title;

  @HiveField(1)
  String category;

  @HiveField(2)
  IconData habitIcon;

  @HiveField(3)
  Color iconBgColor;

  @HiveField(4)
  List<String> notificationTime;

  @HiveField(5)
  TaskType taskType;

  @HiveField(6)
  RepeatType repeatType;

  @HiveField(7)
  HabitType habitType;

  @HiveField(8)
  Duration? timer;

  @HiveField(9)
  int? value;

  @HiveField(10)
  Map<DateTime, ProgressWithStatus> progressJson;

  @HiveField(11)
  List<int>? days;

  @HiveField(12)
  List<DateTime>? selectedDates;

  @HiveField(13)
  int? selectedTimesPerWeek;

  @HiveField(14)
  int? selectedTimesPerMonth;

  @HiveField(15)
  DateTime startDate;

  @HiveField(16)
  DateTime? endDate;

  @HiveField(17)
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
    required this.startDate,
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
