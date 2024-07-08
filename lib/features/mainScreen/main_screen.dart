import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/features/statistics/statistics_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../addChallenge/add_challenge_screen.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../timer/timer_screen.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 35.h,
                width: 35.w,
                child: SvgPicture.asset(ImageResource.calenderIcon),
              ),
              // SizedBox(width: 30.w,),
              Container(
                child: Column(
                  children: [
                    Text("Today", style: GoogleFonts.poppins(fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),),
                    Text(DateTime.now().toString().split(" ")[0],
                      style: GoogleFonts.poppins(fontSize: 18,
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                    ),
                    ),],
                ),
              ),
              Container(
                height: 35.h,
                width: 35.w,
                child: SvgPicture.asset(ImageResource.calenderIcon),
              ),
            ],
          ),
          // Calendar
          Container(
            clipBehavior: Clip.hardEdge,
            margin:  EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.withOpacity(0.09),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: TableCalendar(
              rowHeight:55,
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _selectedDate,
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 24,),
                formatButtonVisible: false,
              titleCentered: true,),
              availableGestures: AvailableGestures.all,
              calendarFormat: CalendarFormat.week,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                weekendStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.w300,fontSize: 15),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  print("selectedDay: $selectedDay");
                });
              },
            ),
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
                    return Padding(
                      padding:  EdgeInsets.only(top: 10.h,bottom: 5.h),
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        margin:  EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(22.w),
                          // border: Border.all(width: 2,color: Colors.white),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0.0, 4.0),
                              color: Colors.grey,
                              blurRadius: 4.0,
                              spreadRadius: 0.0
                          ),],
                        ),
                        height: 65.h,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child:
                              LinearProgressIndicator(
                                //Here you pass the percentage
                                value: progress,
                                color: Colors.blue.withAlpha(100),
                                backgroundColor: Colors.white,
                              ),
                            ),
                             Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.only(left: 5.w, right: 15.w),
                                    child: Container(
                                      height: 50.h,
                                      width: 48.w,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(20.0)
                                        borderRadius: BorderRadius.circular(16.w),
                                        border: Border.all(width: 1.2.w,color: Colors.blue),
                                        image: const DecorationImage(
                                          image: AssetImage(ImageResource.dumbleIcon),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StatisticsScreen(habit: habit),),);
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(top: 5.h, left: 10.w),
                                          child: Text(habit.title, style: const TextStyle(fontWeight: FontWeight.w400,color: Colors.black, fontSize: 21),),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(left: 10.w),
                                          child: Text('${habit.category} - ${habit.notificationTime.format(context)}',
                                            style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 19),),
                                        ),
                                        // SizedBox(
                                        //   height: 10,
                                        //     width: 250,
                                        //     child: LinearProgressIndicator(value: progress)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 42.w,),
                                  GestureDetector(
                                      onTap: () => _handleHabitTap(context, habit),
                                      child: Padding(
                                        padding:  EdgeInsets.only(left: 22.w,),
                                        child: Container(
                                            height: 28.h,
                                            width: 28.w,
                                            color:Colors.blue,
                                            child: _buildTrailingWidget(context, habit, progress)),
                                      )),
                                ],
                              )
                               ,
                            )
                          ],
                        ),
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
