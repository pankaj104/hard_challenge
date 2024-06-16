import 'package:flutter/material.dart';
import 'package:hard_challenge/statistics_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_challenge_screen.dart';
import 'model/habit_model.dart';
import 'provider/habit_provider.dart';
import 'timer_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Habits'),
      ),
      body: Column(
        children: [
          // Calendar
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _selectedDate,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),  // Display habits for the selected date
          Expanded(
            child: Consumer<HabitProvider>(
              builder: (context, habitProvider, child) {
                List<Habit> habitsForSelectedDate = habitProvider.getHabitsForDate(_selectedDate);
                return ListView.builder(
                  itemCount: habitsForSelectedDate.length,
                  itemBuilder: (context, index) {
                    Habit habit = habitsForSelectedDate[index];
                    double progress = habit.progress[_selectedDate] ?? 0.0;
                    return SizedBox(
                      height: 60,
                      width: 300,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => StatisticsScreen(habit: habit),),);
                    },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(habit.title),
                               Text('${habit.category} - ${habit.notificationTime.format(context)}'),
                                SizedBox(
                                  height: 10,
                                    width: 250,
                                    child: LinearProgressIndicator(value: progress)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20,),
                          GestureDetector(
                              onTap: () => _handleHabitTap(context, habit),
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  color:Colors.blue,
                                  child: _buildTrailingWidget(context, habit, progress))),
                        ],
                      ),
                    );

                    //   ListTile(
                    //   title: Text(habit.title),
                    //   subtitle: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text('${habit.category} - ${habit.notificationTime.format(context)}'),
                    //       LinearProgressIndicator(value: progress),
                    //     ],
                    //   ),
                    //   trailing: _buildTrailingWidget(context, habit, progress),
                    //   onTap: () => _handleHabitTap(context, habit),
                    // );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddChallengeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTrailingWidget(BuildContext context, Habit habit, double progress) {
    switch (habit.taskType) {
      case TaskType.timer:
        return const Icon(Icons.timer);
      case TaskType.value:
        return Text('${habit.value}');
      case TaskType.normal:
      default:
        return Checkbox(
          value: progress == 1.0,
          onChanged: (bool? value) {
            setState(() {
              double newProgress = value == true ? 1.0 : 0.0;
              Provider.of<HabitProvider>(context, listen: false)
                  .updateHabitProgress(habit, _selectedDate, newProgress);
            });
          },
        );
    }
  }

  void _handleHabitTap(BuildContext context, Habit habit) {
    switch (habit.taskType) {
      case TaskType.timer:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TimerScreen(habit: habit, selectedDate: _selectedDate),
          ),
        );
        break;
      case TaskType.value:
        _completeValueTask(context, habit);
        break;
      case TaskType.normal:
        setState(() {
          double newProgress = (habit.progress[_selectedDate] ?? 0.0) == 1.0 ? 0.0 : 1.0;
          Provider.of<HabitProvider>(context, listen: false)
              .updateHabitProgress(habit, _selectedDate, newProgress);
        });

        break;
    }
  }

  void _completeValueTask(BuildContext context, Habit habit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _valueCompleteController = TextEditingController();
        return AlertDialog(
          title: Text('Complete Task: ${habit.title}'),
          content: TextField(
            controller: _valueCompleteController,
            decoration: const InputDecoration(hintText: 'Enter completed value'),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final completedValue = int.tryParse(_valueCompleteController.text) ?? 0;
                setState(() {
                  double newProgress = completedValue / (habit.value ?? 1);
                  Provider.of<HabitProvider>(context, listen: false)
                      .updateHabitProgress(habit, _selectedDate, newProgress);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Complete'),
            ),
          ],
        );
      },
    );
  }
}

// extension HabitProviderExtension on HabitProvider {
//   List<Habit> getHabitsForDate(DateTime date) {
//     return habits.where((habit) {
//       switch (habit.repeatType) {
//         case RepeatType.daily:
//           return true;
//         case RepeatType.selectDays:
//           return habit.days?.contains(date.weekday) ?? false;
//         case RepeatType.selectedDate:
//           return habit.selectedDates?.any((selectedDate) => isSameDate(selectedDate, date)) ?? false;
//         default:
//           return false;
//       }
//     }).toList();
//   }
//
//   void updateHabitProgress(Habit habit, DateTime date, double progress) {
//     int index = habits.indexOf(habit);
//     if (index != -1) {
//       habits[index].progress[date] = progress;
//       notifyListeners();
//     }
//   }
//
//   bool isSameDate(DateTime date1, DateTime date2) {
//     return date1.year == date2.year &&
//         date1.month == date2.month &&
//         date1.day == date2.day;
//   }
// }
