import 'dart:developer';

import 'package:flutter/material.dart';
import '../model/habit_model.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
    log('All Habit data: $habits');
  }

  void updateHabit(int index, Habit updatedHabit) {
    if (index >= 0 && index < _habits.length) {
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }

  void deleteHabit(int index) {
    if (index >= 0 && index < _habits.length) {
      _habits.removeAt(index);
      notifyListeners();
    }
  }

  Habit getHabit(int index) {
    return _habits[index];
  }

  List<Habit> getAllHabit() {
    return _habits;
  }

  double getAverageProgressForDate(DateTime date) {
    // Calculate total progress for all habits, using 0.0 for habits without data for this date
    double totalProgress = _habits.fold(0.0, (sum, habit) {
      double progress = habit.progressJson[date]?.progress ?? 0.0;
      return sum + progress;
    });

    // Return average progress based on all habits
    return _habits.isEmpty ? 0.0 : totalProgress / _habits.length;
  }


  void loadHabits(List<Habit> habits) {
    _habits = habits;
    notifyListeners();
  }

  Map<DateTime, List<Habit>> getHabitsForSelectedDates() {
    Map<DateTime, List<Habit>> habitsByDate = {};
    for (var habit in _habits) {
      if (habit.repeatType == RepeatType.selectedDate && habit.selectedDates != null) {
        for (var date in habit.selectedDates!) {
          if (!habitsByDate.containsKey(date)) {
            habitsByDate[date] = [];
          }
          habitsByDate[date]!.add(habit);
        }
      }
    }
    return habitsByDate;
  }

  List<Habit> getHabitsForDate(DateTime date) {
    return _habits.where((habit) {
      // Check if the habit is within the date range
      if (habit.startDate != null && habit.endDate != null) {
        if (date.isBefore(habit.startDate!) || date.isAfter(habit.endDate!)) {
          return false;
        }
      } else if (habit.startDate != null) {
        if (date.isBefore(habit.startDate!)) {
          return false;
        }
      } else if (habit.endDate != null) {
        if (date.isAfter(habit.endDate!)) {
          return false;
        }
      }

      switch (habit.repeatType) {
        case RepeatType.selectDays:
        // Show habit if it repeats on specific days of the week
          return habit.days?.contains(date.weekday) ?? false;

        case RepeatType.weekly:
          if (habit.selectedTimesPerWeek != null) {
            // Define the start of the week according to the date, considering Sunday as the start
            DateTime startOfWeek;
            if (date.weekday == DateTime.sunday) {
              startOfWeek = date;
            } else {
              startOfWeek = date.subtract(Duration(days: date.weekday)); // Start from Sunday for this locale
            }
            DateTime endOfWeek = startOfWeek.add(const Duration(days: 6)); // End of week is 6 days after start

            log('Start of week: $startOfWeek');
            log('End of week: $endOfWeek');

            // Count completions in the current week
            int completedTimes = habit.progressJson.keys
                .where((completedDate) =>
            completedDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                completedDate.isBefore(endOfWeek.add(const Duration(days: 1))))
                .length;

            log('Completed times this week: $completedTimes');

            // Show the habit if it is not completed the required number of times
            if (completedTimes < habit.selectedTimesPerWeek!) {
              return true;
            }

            // Additionally, show the habit on the days it was completed
            return habit.progressJson.keys.any((completedDate) => isSameDate(completedDate, date));
          }
          return false;

        case RepeatType.selectedDate:
        // Show habit if it repeats on specific selected dates
          return habit.selectedDates?.any((selectedDate) => isSameDate(selectedDate, date)) ?? false;

        default:
          return false;
      }
    }).toList();
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    final startOfWeek1 = date1.subtract(Duration(days: date1.weekday - 1));
    final startOfWeek2 = date2.subtract(Duration(days: date2.weekday - 1));

    return isSameDate(startOfWeek1, startOfWeek2);
  }

  void updateHabitProgress(Habit habit, DateTime date, double progressValue) {
    int index = _habits.indexWhere((h) => h == habit);
    if (index != -1) {
      if (_habits[index].progressJson.containsKey(date)) {
        _habits[index].progressJson[date]!.progress = progressValue;
      } else {
        _habits[index].progressJson[date] = ProgressWithStatus(status: TaskStatus.done, progress: progressValue);
      }
      notifyListeners();
    }
  }

  void markTaskStatus(Habit habit, DateTime date, TaskStatus status) {
    int index = _habits.indexWhere((h) => h == habit);
    if (index != -1) {
      if (_habits[index].progressJson.containsKey(date)) {
        _habits[index].progressJson[date]!.status = status;
      } else {
        _habits[index].progressJson[date] = ProgressWithStatus(status: status, progress: 0.0);
      }
      notifyListeners();
    }
  }
  double getOverallCompletionPercentage(String categoryName) {
    if (_habits.isEmpty) return 0.0;

    double totalPercentage = 0.0;

    for (Habit habit in _habits) {
      totalPercentage += habit.getCompletionPercentageByCategory(categoryName);
    }
        log('total percentage ${totalPercentage / _habits.length}');
    return totalPercentage / _habits.length;
  }


  double getOverallSkippedPercentage(String categoryName) {
    if (_habits.isEmpty) return 0.0;

    double totalPercentage = 0.0;

    for (Habit habit in _habits) {
      totalPercentage += habit.getSkippedPercentageByCategory(categoryName);
    }
    log('total percentage ${totalPercentage / _habits.length}');
    return totalPercentage / _habits.length;
  }

  double getOverallMissedPercentage(String categoryName) {
    if (_habits.isEmpty) return 0.0;

    double totalPercentage = 0.0;

    for (Habit habit in _habits) {
      totalPercentage += habit.getMissedPercentageByCategory(categoryName);
    }
    log('total percentage ${totalPercentage / _habits.length}');
    return totalPercentage / _habits.length;
  }


}
