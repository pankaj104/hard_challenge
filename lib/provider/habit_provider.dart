import 'package:flutter/material.dart';
import '../model/habit_model.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
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
        case RepeatType.daily:
          return true;
        case RepeatType.selectedDays:
          return habit.days?.contains(date.weekday) ?? false;
        case RepeatType.selectedDate:
          return habit.selectedDates?.any((selectedDate) => isSameDate(selectedDate, date)) ?? false;
        default:
          return false;
      }
    }).toList();
  }

  void updateHabitProgress(Habit habit, DateTime date, double progress) {
    int index = _habits.indexWhere((h) => h == habit);
    if (index != -1) {
      _habits[index].progress[date] = progress;
      notifyListeners();
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
