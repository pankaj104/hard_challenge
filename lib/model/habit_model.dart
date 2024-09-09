import 'dart:developer';

import 'package:flutter/material.dart';

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



  int countTotalDays() {
    int totalDays = 0;

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

    return totalDays;
  }

  double getCompletionPercentageByCategory(String category) {
    int completedDays = 0;
    // Filter the progressJson based on the category
    Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
      progressJson.entries.where((entry) => this.category == category),
    );
    completedDays = categoryProgressJson.values
        .where((p) => p.status == TaskStatus.done)
        .length;
    return countTotalDays() > 0 ? (completedDays / countTotalDays()) * 100 : 0.0;
  }

  double getSkippedPercentageByCategory(String category) {
    int skippedCount = 0;
    // Filter the progressJson based on the category
    Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
      progressJson.entries.where((entry) => this.category == category),
    );
    // Count skipped days for the specific category
    categoryProgressJson.values.forEach((progress) {
      if (progress.status == TaskStatus.skipped) {
        log('skippedcount $skippedCount');
        skippedCount++;
      }
    });
    return countTotalDays() > 0 ? (skippedCount / countTotalDays()) * 100 : 0.0;
  }


  double getMissedPercentageByCategory(String category) {
    int missedCount = 0;
    DateTime now = DateTime.now();
    // Filter the progressJson based on the category
    Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
      progressJson.entries.where((entry) => this.category == category),
    );

    List<DateTime> missedDates = [];

    // Determine missed dates based on repeat type
    if (repeatType == RepeatType.selectDays) {
      DateTime? loopDate = startDate;

      while (loopDate!.isBefore(now) || loopDate.isAtSameMomentAs(now)) {
        if (days!.contains(loopDate.weekday % 7)) {
          if (!categoryProgressJson.containsKey(loopDate) ||
              (categoryProgressJson[loopDate]!.status != TaskStatus.done &&
                  categoryProgressJson[loopDate]!.status != TaskStatus.skipped)) {
            missedDates.add(loopDate);
          }
        }
        loopDate = loopDate.add(const Duration(days: 1));
      }
    } else if (repeatType == RepeatType.selectedDate) {
      if (selectedDates != null) {
        for (var date in selectedDates!.where((date) => date.isBefore(now))) {
          if (!categoryProgressJson.containsKey(date) ||
              (categoryProgressJson[date]!.status != TaskStatus.done &&
                  categoryProgressJson[date]!.status != TaskStatus.skipped)) {
            missedDates.add(date);
          }
        }
      }
    } else if (repeatType == RepeatType.weekly) {
      DateTime? loopDate = startDate;
      while (loopDate!.isBefore(now) || loopDate.isAtSameMomentAs(now)) {
        if (days!.contains(loopDate.weekday % 7)) {
          if (!categoryProgressJson.containsKey(loopDate) ||
              (categoryProgressJson[loopDate]!.status != TaskStatus.done &&
                  categoryProgressJson[loopDate]!.status != TaskStatus.skipped)) {
            missedDates.add(loopDate);
          }
        }
        loopDate = loopDate.add(const Duration(days: 1));
      }
    } else if (repeatType == RepeatType.monthly) {
      if (selectedDates != null) {
        for (var date in selectedDates!.where((date) => date.isBefore(now))) {
          if (!categoryProgressJson.containsKey(date) ||
              (categoryProgressJson[date]!.status != TaskStatus.done &&
                  categoryProgressJson[date]!.status != TaskStatus.skipped)) {
            missedDates.add(date);
          }
        }
      }
    }
    missedCount = missedDates.length;

    // Calculate and return the missed percentage
    int totalDays = countTotalDays(); // Ensure this function is correctly defined
    log('Missed count: $missedCount and total days: $totalDays');
    return totalDays > 0 ? (missedCount / totalDays) * 100 : 0.0;
  }



}
