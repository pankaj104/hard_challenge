import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:hive/hive.dart';
import '../model/habit_model.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];
  Box<Habit>? _habitBox;

  HabitProvider() {
    _openBox();
  }
  Future<void> _openBox() async {
    // Open the Hive box for storing Habit objects
    _habitBox = await Hive.openBox<Habit>('habitBox');
    loadHabits();
  }


  // Load habits from Hive box into the provider
  void loadHabits() {
    if (_habitBox != null) {
      _habits = _habitBox!.values.toList();
      log('load Habits data: $habits');
      notifyListeners();
    }
  }

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) async {
    await _habitBox?.add(habit);
    _habits.add(habit);
    notifyListeners();
    log('All Habit data: $habits');
  }

  void updateHabit(Habit updatedHabit) async {
    int index = _habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index >= 0 && index < _habits.length) {
      /// we can enable this if we want to update existing progress.

      // // Preserve existing progress data
      // Map<DateTime, ProgressWithStatus> existingProgress =
      //     _habits[index].progressJson;
      // // Merge progress data into the updated habit
      // updatedHabit.progressJson.addAll(existingProgress);

      // Save the updated habit in the Hive box
      await _habitBox?.putAt(index, updatedHabit);

      _habits[index] = updatedHabit;

      notifyListeners();
    }
  }


  void deleteHabit(String habitId) async {
    int index = _habits.indexWhere((habit) => habit.id == habitId);

    if (index != -1) {
      await _habitBox?.deleteAt(index);
      _habits.removeAt(index);
      notifyListeners();
    }
  }

  void addFeedbackToHabit(String habitId, DateTime date, String feedback) async {
    int index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index >= 0 && index < _habits.length) {
      Habit habit = _habits[index];

      // Preserve existing feedback data
      habit.notesForReason ??= {}; // Initialize if null
      habit.notesForReason![date] = feedback; // Add/Update feedback

      // Save the updated habit in the Hive box
      await _habitBox?.putAt(index, habit);

      _habits[index] = habit;

      notifyListeners();
    }
  }

  void deleteFeedbackFromHabit(String habitId, DateTime date) async {
    int index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index >= 0 && index < _habits.length) {
      Habit habit = _habits[index];

      // Remove the feedback for the specified date
      habit.notesForReason?.remove(date);

      // Save the updated habit in the Hive box
      await _habitBox?.putAt(index, habit);

      _habits[index] = habit;

      notifyListeners();
    }
  }

  // void _loadSortedNotes() {
  //   sortedEntries = [];
  //
  //   if (widget.habit.notesForReason != null) {
  //     sortedEntries.addAll(widget.habit.notesForReason!.entries);
  //   }
  //
  //   sortedEntries.sort((a, b) => a.key.compareTo(b.key)); // Sort by newest first
  // }

  String? getNoteForDate(String habitId, DateTime date) {
    int index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index >= 0 && index < _habits.length) {
      Habit habit = _habits[index];
      return habit.notesForReason?[date];
    }
    return null; // Return null if the habit or note doesn't exist
  }


  Habit getHabit(int index) {
    return _habits[index];
  }

  Future<void> clearHabits() async {
    if (_habitBox != null) {
      await _habitBox!.clear(); // Deletes all entries from the Hive box
      _habits.clear();          // Clears the in-memory list
      log('All habits cleared from database and memory');
      notifyListeners();        // Notify listeners to update UI
    } else {
      log('Error: HabitBox is not initialized');
    }
  }


  List<Habit> getAllHabit() {
    return _habits;
  }

  double getAverageProgressForDate(DateTime date) {
    log('getAverageProgressForDate $date');
    List<Habit> activeHabits = _habits.where((habit) {
      DateTime startDateOnly = DateTime(habit.startDate!.year, habit.startDate!.month, habit.startDate!.day);
      DateTime endDateOnly = DateTime(habit.endDate!.year, habit.endDate!.month, habit.endDate!.day);

      if (habit.habitType == HabitType.quit) {
        // For quit habits, include startDate and endDate (inclusive of endDate)
        return (date.isAfter(startDateOnly) || date.isAtSameMomentAs(startDateOnly)) &&
            (endDateOnly == null || date.isBefore(endDateOnly) || date.isAtSameMomentAs(endDateOnly));
      } else {
        // For other habits, include startDate and endDate (inclusive of endDate)
        log('date.isAtSameMomentAs(habit.endDate!) ${date.isAtSameMomentAs(endDateOnly)}');
        return (date.isAfter(startDateOnly) || date.isAtSameMomentAs(startDateOnly)) &&
            (endDateOnly == null || date.isBefore(endDateOnly) || date.isAtSameMomentAs(endDateOnly));
      }
    }).toList();

    // Calculate total progress for all active habits
    double totalProgress = activeHabits.fold(0.0, (sum, habit) {
      double progress = habit.progressJson[date]?.progress ?? 0.0;

      if (habit.habitType == HabitType.quit) {
        // For quit habits, count progress differently
        if (progress > 0 && progress <= 1) {
          return sum + (1 - progress); // Count 1 - progress
        } else if (progress == 0 || habit.progressJson[date] == null) {
          return sum + 1; // Count 1 for no progress or null
        }
      }

      // Default behavior for other habit types
      return sum + progress;
    });

    // Return average progress based on the count of active habits
    return activeHabits.isEmpty ? 0.0 : totalProgress / activeHabits.length;
  }



  // void loadHabits(List<Habit> habits) {
  //   _habits = habits;
  //   notifyListeners();
  // }

  void markTaskAsSkipped(Habit habit, DateTime date, TaskStatus status) async {
    habit.progressJson[date] = ProgressWithStatus(status: status, progress: 0.0);
    await _habitBox?.putAt(_habits.indexOf(habit), habit);
    notifyListeners(); // Notify listeners of data change
  }

  // void updateHabitProgress(Habit habit, DateTime date, double progressValue) {
  //   if (habit.progressJson.containsKey(date)) {
  //     habit.progressJson[date]!.progress = progressValue;
  //   } else {
  //     habit.progressJson[date] = ProgressWithStatus(status: TaskStatus.done, progress: progressValue);
  //   }
  //   notifyListeners();
  // }

  double getSkippedPercentageByCategory(Habit habit, String category) {
    int skippedCount = 0;
    // Filter the progressJson for entries in this category
    Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
      habit.progressJson.entries.where((entry) => habit.category == category),
    );

    // Count skipped days for the specific category
    categoryProgressJson.values.forEach((progress) {
      if (progress.status == TaskStatus.skipped) {
        skippedCount++;
      }
    });

    int totalDays = countTotalDays(habit);
    return totalDays > 0 ? (skippedCount / totalDays) * 100 : 0.0;
  }

  double getMissedPercentageByCategory(Habit habit, String category) {
    int missedCount = 0;
    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day); // Reset time to 00:00:00
    Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
      habit.progressJson.entries.where((entry) => habit.category == category),
    );

    List<DateTime> missedDates = [];

    if (habit.repeatType == RepeatType.selectDays) {
      DateTime loopDate = habit.startDate!;
      DateTime endDate = habit.endDate!;
      DateTime now = DateTime.now();
      now = DateTime(now.year, now.month, now.day); // Reset `now` to midnight
      log('habit.days: ${habit.days}');

      while (!loopDate.isAfter(endDate)) {
        int dayIndex = loopDate.weekday;

        // Skip today's date and any date after today
        if (loopDate.isBefore(now)) {
          // Check if the loopDate is part of the selected days
          if (habit.days!.contains(dayIndex)) {
            if (!categoryProgressJson.containsKey(loopDate) ||
                (categoryProgressJson[loopDate]!.status != TaskStatus.done &&
                    categoryProgressJson[loopDate]!.status != TaskStatus.skipped)) {
              missedDates.add(loopDate);
            }
          }
        }

        // Increment the loop date by one day
        loopDate = loopDate.add(const Duration(days: 1));
      }

      log('Missed dates list: $missedDates');
    }


    else if (habit.repeatType == RepeatType.selectedDate && habit.selectedDates != null) {
      for (var date in habit.selectedDates!.where((date) => date.isBefore(now))) {
        if (!categoryProgressJson.containsKey(date) ||
            (categoryProgressJson[date]!.status != TaskStatus.done &&
                categoryProgressJson[date]!.status != TaskStatus.skipped)) {
          missedDates.add(date);
        }
      }
    }
    else if (habit.repeatType == RepeatType.weekly) {
      DateTime now = DateTime.now();
      now = DateTime(now.year, now.month, now.day); // Reset time to midnight
      DateTime loopDate = habit.startDate!;
      while (loopDate.isBefore(now) || loopDate.isAtSameMomentAs(now)) {
        // Use loopDate.weekday directly
        if (habit.days!.contains(loopDate.weekday)) {
          if (!categoryProgressJson.containsKey(loopDate) ||
              (categoryProgressJson[loopDate]!.status != TaskStatus.done &&
                  categoryProgressJson[loopDate]!.status != TaskStatus.skipped)) {
            missedDates.add(loopDate);
          }
        }
        loopDate = loopDate.add(const Duration(days: 1));
      }
    }

    else if (habit.repeatType == RepeatType.monthly && habit.selectedDates != null) {
      for (var date in habit.selectedDates!.where((date) => date.isBefore(now))) {
        if (!categoryProgressJson.containsKey(date) ||
            (categoryProgressJson[date]!.status != TaskStatus.done &&
                categoryProgressJson[date]!.status != TaskStatus.skipped)) {
          missedDates.add(date);
        }
      }
    }
    missedCount = missedDates.length;
    int totalDays = countTotalDays(habit);
    log('Missed count: $missedCount and total days: $totalDays');
    return totalDays > 0 ? (missedCount / totalDays) * 100 : 0.0;
  }

  int countTotalDays(Habit habit) {
    int totalDays = 0;
    DateTime? startDate = setSelectedDate(habit.startDate) ;
    DateTime? endDate = setSelectedDate(habit.endDate!);

    log('start date $startDate end date: $endDate');

    if (habit.repeatType == RepeatType.selectDays && startDate != null && endDate != null) {
      DateTime loopDate = startDate;

      while (loopDate.isBefore(endDate) || loopDate.isAtSameMomentAs(endDate)) {
        int mappedWeekday = loopDate.weekday % 7;  // Sunday (7) maps to 0
        // If mappedWeekday is 0, change it back to 7 for Sunday
        if (mappedWeekday == 0) {
          mappedWeekday = 7;
        }

        log('loopDate $loopDate, mappedWeekday: $mappedWeekday, habit.days: ${habit.days}');

        if (habit.days!.contains(mappedWeekday)) {
          log('total days count $totalDays');
          totalDays++;
        }

        loopDate = loopDate.add(const Duration(days: 1));
      }



    } else if (habit.repeatType == RepeatType.selectedDate) {
      totalDays = habit.selectedDates?.length ?? 1;
    } else if (habit.repeatType == RepeatType.weekly && startDate != null && endDate != null) {
      totalDays = countTaskDays(startDate, endDate, habit.selectedTimesPerWeek ?? 1);
    } else if (habit.repeatType == RepeatType.monthly) {
      totalDays = habit.selectedDates?.length ?? 1;
    }
    return totalDays;
  }

  int countTotalDaysTillToday(Habit habit) {
    int totalDays = 0;
    DateTime? startDate = setSelectedDate(habit.startDate);
    DateTime endDate = DateTime.now(); // Use today's date instead of habit.endDate

    log('start date: $startDate, end date (today): $endDate');

    if (habit.repeatType == RepeatType.selectDays && startDate != null) {
      DateTime loopDate = startDate;

      while (loopDate.isBefore(endDate) || loopDate.isAtSameMomentAs(endDate)) {
        int mappedWeekday = loopDate.weekday % 7;
        if (mappedWeekday == 0) {
          mappedWeekday = 7;
        }

        log('loopDate: $loopDate, mappedWeekday: $mappedWeekday, habit.days: ${habit.days}');

        if (habit.days!.contains(mappedWeekday)) {
          log('total days count: $totalDays');
          totalDays++;
        }
        loopDate = loopDate.add(const Duration(days: 1));
      }
    } else if (habit.repeatType == RepeatType.selectedDate) {
      totalDays = habit.selectedDates?.where((date) => date.isBefore(endDate) || date.isAtSameMomentAs(endDate)).length ?? 1;
    } else if (habit.repeatType == RepeatType.weekly && startDate != null) {
      totalDays = countTaskDays(startDate, endDate, habit.selectedTimesPerWeek ?? 1);
    } else if (habit.repeatType == RepeatType.monthly) {
      totalDays = habit.selectedDates?.where((date) => date.isBefore(endDate) || date.isAtSameMomentAs(endDate)).length ?? 1;
    }

    return totalDays;
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

    return totalTaskDays;
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

  Future<List<Habit>> getHabitsForDate(DateTime date) async {
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

  void updateHabitProgress(Habit habit, DateTime date, double progressValue,TaskStatus status, Duration? timerHabitDuration) async {
    int index = _habits.indexWhere((h) => h == habit);
    if (index != -1) {
      // if (_habits[index].progressJson.containsKey(date)) {
      //   _habits[index].progressJson[date]!.progress = progressValue;
      // } else {
        _habits[index].progressJson[date] = ProgressWithStatus(status: status, progress: progressValue, duration: timerHabitDuration ?? Duration());
        await _habitBox?.putAt(index, _habits[index]); // Save the updated habit to Hive

    // }
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


  double getCompletionPercentageByCategory(Habit habit, String category) {
    int completedDays = 0;
    double completedProgress = 0.0;

    // Filter progressJson for entries in this category
    Map<DateTime, ProgressWithStatus> categoryProgressJson = Map.fromEntries(
      habit.progressJson.entries.where((entry) => habit.category == category),
    );

    if (habit.habitType == HabitType.quit) {
      // For "quit" habits, count days that are either unmarked or not "done"
      DateTime currentDate = habit.startDate;

      while (currentDate.isBefore(DateTime.now()) || currentDate.isAtSameMomentAs(DateTime.now())) {
        // Get the progress for the current date if it exists

        // String formattedDate = formatStartDateToUtc(currentDate);
        String formattedDate = currentDate.toString();
        ProgressWithStatus? progress = categoryProgressJson[DateTime.parse(formattedDate)];

        log('Formatted currentDate: $formattedDate    $currentDate');
        log('Checking categoryProgressJson: $categoryProgressJson');
        log('Progress on $formattedDate: $progress');

        // Count the day if there is no progress recorded or if the status is not "done"
        if (progress == null || progress.status != TaskStatus.done) {
          completedProgress += (1.0 - (progress?.progress ?? 0.0));
          completedDays++;
        }
        // Move to the next day
        currentDate = currentDate.add(Duration(days: 1));
      }
    } else {
      // For other habit types, count only days marked as "done"
      completedDays = categoryProgressJson.values
          .where((progress) => progress.status == TaskStatus.done)
          .length;


      completedProgress = categoryProgressJson.values
          .where((progress) => progress.progress != null)
          .map((progress) => progress.progress)
          .fold(0.0, (sum, progress) => sum + progress);
    }

    int totalDays = countTotalDays(habit);
    log('Total days for specific habit: $totalDays');
    log('Completed days for specific habit: $completedDays');
    log('completedProgress: $completedProgress');

    return totalDays > 0 ? (completedProgress / totalDays.toDouble()) * 100 : 0.0;
  }

  double getOverallCompletionPercentage(String categoryName) {
    if (_habits.isEmpty) return 0.0;

    double totalPercentage = 0.0;

    // Accumulate completion percentages across all habits in the category
    for (Habit habit in _habits) {
      totalPercentage += getCompletionPercentageByCategory(habit, categoryName);
    }

    log('Total percentage across habits: ${totalPercentage / _habits.length}');
    return totalPercentage / _habits.length;
  }


  double getOverallSkippedPercentage(String categoryName) {
    if (_habits.isEmpty) return 0.0;

    double totalPercentage = 0.0;

    for (Habit habit in _habits) {
      totalPercentage += getSkippedPercentageByCategory(habit, categoryName);
    }
    log('totalPercentage skipped percentage across habits: $totalPercentage');


    double averageSkippedPercentage = totalPercentage / _habits.length;
    log('averageSkippedPercentage skipped percentage across habits: $averageSkippedPercentage');
    return averageSkippedPercentage;
  }

  double getOverallMissedPercentage(String categoryName) {
    if (_habits.isEmpty) return 0.0;

    double totalPercentage = 0.0;

    for (Habit habit in _habits) {
      totalPercentage += getMissedPercentageByCategory(habit, categoryName);
    }

    double averageMissedPercentage = totalPercentage / _habits.length;
    log('Total missed percentage across habits: $averageMissedPercentage');
    return averageMissedPercentage;
  }

  double getOverallTaskCompletionPercentage(Habit habit) {
    int totalDays = countTotalDays(habit);
    if (totalDays == 0) return 0.0;

    double totalProgress = habit.progressJson.values
        .map((progress) => progress.progress) // Assuming progress.value holds the completion percentage (0-1)
        .fold(0.0, (sum, value) => sum + value);

    return (totalProgress / totalDays) * 100;
  }




}
