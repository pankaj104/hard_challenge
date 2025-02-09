import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hard_challenge/features/addChallenge/add_challenge_screen.dart';
import 'package:hard_challenge/pages/habit_notes_reason_date_wise.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../model/habit_model.dart';
import '../../utils/colors.dart';
import '../../utils/image_resource.dart';
import '../../widgets/calendar_widget.dart';
import '../../widgets/headingH2_widget.dart';
import '../../widgets/icon_button_widget.dart';
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
    log('data for statistics ${widget.habit}');

    return Scaffold(
      appBar: AppBar(
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

              } else if (value == 'delete') {
                setState(() {
                  Provider.of<HabitProvider>(context, listen: false).deleteHabit(widget.habit.id);
                });
                Navigator.pop(context);              }
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
                    Icon(Icons.skip_next, color: Colors.black),
                    SizedBox(width: 10),
                    (widget.habit.progressJson[widget.selectedDateforSkip]?.status == status.TaskStatus.skipped) ? Text("Resume Session") : Text("Skip Session")
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

              Center(child: Text(' ${widget.habit.title}', style: const TextStyle(fontSize: 24))),
              widget.habit.notes != null ?  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notes', style: TextStyle(fontSize: 24, color: Colors.deepOrange)),
                  Text(' ${widget.habit.notes}', style: const TextStyle(fontSize: 20)),
                ],
              )
               : const SizedBox(),
              const SizedBox(height: 16),
              // Center(
              //   child: ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //
              //         // Check if the task is already skipped
              //         if (widget.habit.progressJson[widget.selectedDateforSkip]?.status == TaskStatus.skipped) {
              //           // If it's skipped, mark it as 'reOpen' (task needs to be reopened)
              //           Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(
              //             widget.habit,
              //             widget.selectedDateforSkip,
              //             0.0, // Reset progress to 0
              //             TaskStatus.reOpen,
              //             null
              //           );
              //         } else {
              //           // If it's not skipped, mark it as skipped
              //           Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(
              //             widget.habit,
              //             widget.selectedDateforSkip,
              //             0.0, // Mark progress as 0% (skipped)
              //             TaskStatus.skipped, // Mark status as 'skipped'
              //             null
              //           );
              //         }
              //
              //       });
              //     },
              //     child: widget.habit.progressJson[widget.selectedDateforSkip]?.status == TaskStatus.skipped
              //         ? const Text("Skipped")  // Text to show when skipped
              //         : Text("Skip Task of ${widget.selectedDateforSkip.day} Date"),  // Text to show normally
              //   ),
              //
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Category: ${widget.habit.category}', style: const TextStyle(fontSize: 18)),
                  Text('Habit Type: ${widget.habit.habitType.name}', style: const TextStyle(fontSize: 18)),
                ],
              ),
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
                            percent: widget.habit.habitType == HabitType.build ? Provider.of<HabitProvider>(context)
                                .getMissedPercentageByCategory(widget.habit, widget.habit.category) / 100 : 0.0,
                            backgroundColor: Colors.transparent,
                            progressColor: Colors.blue[700],
                            circularStrokeCap: CircularStrokeCap.round,
                          ),


                          /// Skipped percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 23.0,
                            percent: 0.0,
                            backgroundColor: Colors.grey[300]!,
                            progressColor: Colors.lightBlue[300],
                            circularStrokeCap: CircularStrokeCap.round,
                          ),

                          /// completed percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 23.0,
                            percent: completionPercentage / 100 ,
                            backgroundColor: Colors.transparent,
                            progressColor: Colors.blue[900],
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
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.green!, // Set the background color
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
                            color:Colors.redAccent!, // Set the background color
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
                          color: ColorStrings.whiteColor!,
                          label: 'Skipped',
                          value: '${skippedPercentage.toStringAsFixed(1)} %',
                          icon: Icons.last_page,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: ColorStrings.calenderBg,
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

              CalendarPage(habit: widget.habit,),

              SizedBox(height: 20,),
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
                  child: HeadingH2Widget('Reason for missed habbit')),
              SizedBox(height: 20,),



            ],
          ),
        ),
      ),
    );
  }


}
