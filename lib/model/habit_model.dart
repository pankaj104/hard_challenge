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
  none,
  done,
  missed,
  skipped,
  goingOn,
  reOpen,
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
  String id; // Unique identifier for the habit

  @HiveField(1)
  String title;

  @HiveField(2)
  String category;

  @HiveField(3)
  String habitEmoji;

  @HiveField(4)
  Color iconBgColor;

  @HiveField(5)
  List<String> notificationTime;

  @HiveField(6)
  TaskType taskType;

  @HiveField(7)
  RepeatType repeatType;

  @HiveField(8)
  HabitType habitType;

  @HiveField(9)
  Duration? timer;

  @HiveField(10)
  int? value;

  @HiveField(11)
  Map<DateTime, ProgressWithStatus> progressJson;

  @HiveField(12)
  List<int>? days;

  @HiveField(13)
  List<DateTime>? selectedDates;

  @HiveField(14)
  int? selectedTimesPerWeek;

  @HiveField(15)
  int? selectedTimesPerMonth;

  @HiveField(16)
  DateTime startDate;

  @HiveField(17)
  DateTime? endDate;

  @HiveField(18)
  String? notes;

  @HiveField(19)
  Map<DateTime, String>? notesForReason; // Optional date-specific feedback

  @HiveField(20)
  String? goalCountLabel;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.habitEmoji,
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
    this.notesForReason,
    this.goalCountLabel,
  });

  @override
  String toString() {
    return 'Habit(id: $id title: $title, category: $category,  habitIcon: $habitEmoji, IconBgColor: $iconBgColor notificationTime: $notificationTime, '
        'taskType: $taskType, habitType: $habitType, repeatType: $repeatType, timer: $timer, value: $value, '
        'progress: $progressJson, days: $days, startDate: $startDate, endDate: $endDate, selectedDates: $selectedDates, '
        'selectedTimesPerWeek: $selectedTimesPerWeek, selectedTimesPerMonth: $selectedTimesPerMonth, notes: $notes, notesForReason: $notesForReason goalCountLabel : $goalCountLabel)';
  }
}
