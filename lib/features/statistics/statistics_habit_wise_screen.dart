import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/widgets/headingH2_widget.dart';
import 'package:hard_challenge/widgets/streak_widget.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../model/habit_model.dart';
import '../../utils/colors.dart';
import '../../widgets/calendar_widget.dart';
import '../../widgets/info_tile_widget.dart';
import '../../widgets/weekly_analysis_chart.dart';
import '../../model/habit_model.dart' as status;


class StatisticsHabitWiseScreen extends StatefulWidget {
  final Habit habit;
  final DateTime selectedDateforSkip;

  StatisticsHabitWiseScreen({required this.habit, required this.selectedDateforSkip});

  @override
  State<StatisticsHabitWiseScreen> createState() => _StatisticsHabitWiseScreenState();
}

class _StatisticsHabitWiseScreenState extends State<StatisticsHabitWiseScreen> {
  @override
  Widget build(BuildContext context) {
    double completionPercentage = Provider.of<HabitProvider>(context)
        .getCompletionPercentageByCategory(widget.habit, widget.habit.category);

    log('completionPercentage $completionPercentage');

    // widget.habit.getCompletionPercentageByCategory(widget.habit.category);
    double skippedPercentage = Provider.of<HabitProvider>(context)
        .getSkippedPercentageByCategory(widget.habit, widget.habit.category) ;
    double missedPercentage = Provider.of<HabitProvider>(context)
        .getMissedPercentageByCategory(widget.habit, widget.habit.category) ;

    int totalDays = Provider.of<HabitProvider>(context)
        .countTotalDays(widget.habit) ;

    int currentStreak = Provider.of<HabitProvider>(context)
        .getCurrentStreak(widget.habit) ;

    int bestStreak = Provider.of<HabitProvider>(context)
        .getBestStreak(widget.habit) ;


    int countTotalDaysTillToday = Provider.of<HabitProvider>(context)
        .countTotalDaysTillToday(widget.habit) ;
    log('data for statistics ${widget.habit}');
    List<String> weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<int> daysList = [1,2,3,4,5,6,7];
    // List<int> daysList = widget.habit?.days;


    void _confirmDelete() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Once deleted, your data will be lost permanently."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    Provider.of<HabitProvider>(context, listen: false)
                        .deleteHabit(widget.habit.id);
                  });
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pop(context); // Go back after deletion
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    }



    return Scaffold(
      backgroundColor: const Color(0xFFF6E9E6), // Light peach background

      appBar: AppBar(
        backgroundColor: const Color(0xFFF6E9E6), // Light peach background
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // Three-dot menu icon
            onSelected: (value) {
              if (value == 'edit') {
                context.router.push(
                  PageRouteInfo<dynamic>(
                      'AddChallengeScreen',
                      path: '/add-challenge-screen',
                      args: AddChallengeScreenArgs(
                        habit: widget.habit, isFromEdit: true, isFromFilledHabbit: false,
                      )
                  ),
                );
              } else if (value == 'skip') {

                setState(() {

                  // Check if the task is already skipped
                  if (widget.habit.progressJson[widget.selectedDateforSkip]?.status == status.TaskStatus.skipped) {
                    // If it's skipped, mark it as 'reOpen' (task needs to be reopened)
                    Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(
                        widget.habit,
                        widget.selectedDateforSkip,
                        0.0, // Reset progress to 0
                        status.TaskStatus.reOpen,
                        null
                    );
                  } else {
                    // If it's not skipped, mark it as skipped
                    Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(
                        widget.habit,
                        widget.selectedDateforSkip,
                        0.0, // Mark progress as 0% (skipped)
                        status.TaskStatus.skipped, // Mark status as 'skipped'
                        null
                    );
                  }

                });

              }
              else if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Edit"),
                  ],
                ),
              ),
               PopupMenuItem(
                value: 'skip',
                child: Row(
                  children: [
                    const Icon(Icons.skip_next, color: Colors.black),
                    const SizedBox(width: 10),
                    (widget.habit.progressJson[widget.selectedDateforSkip]?.status == status.TaskStatus.skipped) ? const Text("Resume Session") : const Text("Skip Session")
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Delete Habit"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: widget.habit.iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text(widget.habit.habitEmoji , style: const TextStyle(fontSize: 20),)),
                  ),
                  const SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.habit.title, style: const TextStyle(fontSize: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.habit.repeatType == RepeatType.selectDays
                              ? (widget.habit.days != null && List<int>.from(widget.habit.days as Iterable).toSet().containsAll(daysList)
                              ? const Row(
                                children: [
                                  Text('Frequency: ', style: TextStyle(fontSize: 15, color: Colors.black),),
                                  Text('Daily', style: TextStyle(fontSize: 15, color: Colors.blue),),
                                ],
                              )
                              : Row(
                                children: [
                                  const Text('Frequency: ', style: TextStyle(fontSize: 15, color: Colors.black),),

                                  Text(
                                                              widget.habit.days != null
                                    ? widget.habit.days!.map((day) => weekDays[day - 1]).join(', ')
                                    : '',
                                                              style: const TextStyle(fontSize: 15,color: Colors.blue),
                                                            ),
                                ],
                              ))
                              : const SizedBox(),
                          //
                          // const SizedBox(width: 5,),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 2),
                          //   child: Text('.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          // ),
                          // if (widget.habit.taskType == TaskType.task)
                          //   const Text('Task', style: TextStyle(fontSize: 15)),
                          // if (widget.habit.taskType == TaskType.time)
                          //   Text(' ${widget.habit.timer}',
                          //       style: const TextStyle(fontSize: 15)),
                          // if (widget.habit.taskType == TaskType.count)
                          //   Text(' ${widget.habit.value}',
                          //       style: const TextStyle(fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
              // widget.habit.notes != null ?  Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     const Text('Notes', style: TextStyle(fontSize: 24, color: Colors.deepOrange)),
              //     Text(' ${widget.habit.notes}', style: const TextStyle(fontSize: 20)),
              //   ],
              // )
              //  : const SizedBox(),
              const SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Text('Category: ${widget.habit.category}', style: const TextStyle(fontSize: 18)),
              //     Text('Habit Type: ${widget.habit.habitType.name}', style: const TextStyle(fontSize: 18)),
              //   ],
              // ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [

                          /// Missed percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 23.0,
                            percent: (skippedPercentage + completionPercentage+ missedPercentage) / 100,
                            backgroundColor: Colors.grey[300]!,
                            progressColor: Colors.red,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),

                          /// Skipped percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 23.0,
                            percent: (skippedPercentage + completionPercentage) / 100,
                            backgroundColor: Colors.transparent,
                            progressColor: Colors.amberAccent,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),

                          /// completed percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 23.0,
                            percent: completionPercentage / 100 ,
                            backgroundColor: Colors.transparent,
                            progressColor: Colors.green,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              '${completionPercentage.toStringAsFixed(1)} %',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
              ),

              const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100], // Light grey background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DurationWidget(totalDays,countTotalDaysTillToday ),
              ],
            ),
          ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 4,left: 4),
                child: Container(
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.green, // Set the background color
                                borderRadius: BorderRadius.circular(12),
                              ),// Set the radius
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: InfoTile(
                                  color: ColorStrings.whiteColor,
                                  label: widget.habit.habitType == HabitType.build ? 'Success ' : 'Quit ',
                                  value: '${completionPercentage.toStringAsFixed(1)} %',
                                  icon: Icons.done,
                                ),
                              ),
                            ),
                            widget.habit.habitType == HabitType.build ?
                            Row(
                              children: [
                                const SizedBox(width: 10,),
                                Container(
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color:Colors.redAccent, // Set the background color
                                    borderRadius: BorderRadius.circular(12),
                                  ),// Set the radius
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: InfoTile(
                                      color: ColorStrings.whiteColor,
                                      label: 'Missed',
                                      value:  '${missedPercentage.toStringAsFixed(1)} %',
                                      icon: Icons.close,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                              ],
                            ) : const SizedBox(),
                            Container(
                              height: 85,
                              decoration: BoxDecoration(
                                color: Colors.amberAccent, // Set the background color
                                borderRadius: BorderRadius.circular(12),
                              ),// Set the radius
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: InfoTile(
                                  color: ColorStrings.whiteColor,
                                  label: 'Skipped',
                                  value: '${skippedPercentage.toStringAsFixed(1)} %',
                                  icon: Icons.last_page,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreakWidget(bestStreak: currentStreak, label: 'Current\nStreak', backgroundColor: const Color(0xff8d8a8a)),
                            StreakWidget(bestStreak: bestStreak, label: 'Best\nStreak', backgroundColor: const Color(0xff8d8a8a)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: ColorStrings.whiteColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFECF8FF).withOpacity(0.2), // Adjust the shadow color and opacity as needed
                        offset: const Offset(0, 4), // x: 0, y: 4
                        blurRadius: 4, // Blur radius
                        spreadRadius: 0, // Spread radius
                      ),
                    ],
                  ),
                  child: WeeklyAnalysisChart(habit: widget.habit,)),

              const SizedBox(height: 20,),

              GestureDetector(
                  onTap: (){
                    context.router.push(
                      PageRouteInfo<dynamic>(
                          'HabitNotesReasonDateWise',
                          path: '/habit-notes-reason-date-wise',
                          args: HabitNotesReasonDateWiseArgs(
                            habit: widget.habit,
                          )
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      height: 35,
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Note observation',
                            style: GoogleFonts.poppins(fontSize: 22,
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.w400,),),

                          const SizedBox(width: 10,),
                          const Icon(Icons.toc_rounded,color: Colors.purpleAccent, size: 28,
                          ),

                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20,),

              Container(
                  height: 440,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CalendarPage(habit: widget.habit,)),


                  // HeadingH2Widget('Reason for missed habbit')),
              const SizedBox(height: 20,),

              (widget.habit.notes != null && widget.habit.notes!.isNotEmpty) ?
              Container(
                width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: ColorStrings.whiteColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFECF8FF).withOpacity(0.2), // Adjust the shadow color and opacity as needed
                        offset: const Offset(0, 4), // x: 0, y: 4
                        blurRadius: 4, // Blur radius
                        spreadRadius: 0, // Spread radius
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: HeadingH2Widget('Notes')),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text(
                          "${widget.habit.notes}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),


                    ],
                  )

              ): SizedBox(),
              const SizedBox(height: 20,),



            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final format = (date.year == now.year) ? 'd MMM' : 'd MMM yyyy';
    return DateFormat(format).format(date);
  }

  Widget DurationWidget(int totalDays, int countTotalDaysTillToday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Duration",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${formatDate(widget.habit.startDate)} - ${formatDate(widget.habit.endDate!)}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              "For $totalDays Days",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: (totalDays / countTotalDaysTillToday) / 10,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

}
