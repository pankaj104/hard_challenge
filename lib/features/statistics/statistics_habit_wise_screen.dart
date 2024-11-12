import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../model/habit_model.dart';
import '../../utils/image_resource.dart';
import '../../widgets/calendar_widget.dart';
import '../../widgets/headingH2_widget.dart';
import '../../widgets/icon_button_widget.dart';
import '../../widgets/info_tile_widget.dart';
import '../../widgets/weekly_analysis_chart.dart';

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
    double completionPercentage = widget.habit.getCompletionPercentageByCategory(widget.habit.category);
    double skippedPercentage = widget.habit.getSkippedPercentageByCategory(widget.habit.category);
    double missedPercentage = widget.habit.getMissedPercentageByCategory(widget.habit.category);
    log('data for statistics ${widget.habit}');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButtonWidget(icon: ImageResource.backIcon,
                      onPressed: (){
                        Navigator.pop(context);
                      } ),

                  Expanded(
                    child: Center(
                      child: HeadingH2Widget("Statistics"),
                    ),
                  ),
                  SizedBox(
                    width: 42.w,
                  ),
                ],
              ),


              Center(child: Text(' ${widget.habit.title}', style: const TextStyle(fontSize: 24))),
              widget.habit.notes != null ?  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Notes', style: const TextStyle(fontSize: 24, color: Colors.deepOrange)),
                  Text(' ${widget.habit.notes}', style: const TextStyle(fontSize: 20)),
                ],
              )
               : SizedBox(),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {

                      // Check if the task is already skipped
                      if (widget.habit.progressJson[widget.selectedDateforSkip]?.status == TaskStatus.skipped) {
                        // If skipped, set it back to normal
                        Provider.of<HabitProvider>(context, listen: false).markTaskAsSkipped(widget.habit,widget.selectedDateforSkip, TaskStatus.reOpen);
                      } else {
                        // If not skipped, mark it as skipped
                        Provider.of<HabitProvider>(context, listen: false).markTaskAsSkipped(widget.habit,widget.selectedDateforSkip, TaskStatus.skipped);
                      }
                    });
                  },
                  child: widget.habit.progressJson[widget.selectedDateforSkip]?.status == TaskStatus.skipped
                      ? Text("Skipped")  // Text to show when skipped
                      : Text("Skip Task of ${widget.selectedDateforSkip.day} Date"),  // Text to show normally
                ),

              ),
              Text('Category: ${widget.habit.category}', style: const TextStyle(fontSize: 18)),
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
                            lineWidth: 20.0,
                            percent:  widget.habit.getMissedPercentageByCategory(widget.habit.category)/100,
                            backgroundColor: Colors.transparent,
                            progressColor: Colors.blue[700],
                            circularStrokeCap: CircularStrokeCap.round,
                          ),

                          /// Skipped percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 20.0,
                            percent: completionPercentage / 100 + skippedPercentage / 100,
                            backgroundColor: Colors.grey[300]!,
                            progressColor: Colors.lightBlue[300],
                            circularStrokeCap: CircularStrokeCap.round,
                          ),

                          /// completed percentage
                          CircularPercentIndicator(
                            radius: 100.0,
                            lineWidth: 20.0,
                            percent: completionPercentage / 100 ,
                            backgroundColor: Colors.transparent,
                            progressColor: Colors.blue[900],
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              '${completionPercentage.toStringAsFixed(1)} %',
                              style: TextStyle(
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

              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InfoTile(
                    color: Colors.blue[900]!,
                    label: 'Completed',
                    value: '${completionPercentage.toStringAsFixed(1)} %',
                    icon: Icons.check,
                  ),
                  InfoTile(
                    color: Colors.blue[700]!,
                    label: 'Missed',
                    value:  '${missedPercentage.toStringAsFixed(1)} %',
                    icon: Icons.close,
                  ),
                  InfoTile(
                    color: Colors.lightBlue[300]!,
                    label: 'Skipped',
                    value: '${skippedPercentage.toStringAsFixed(1)} %',
                    icon: Icons.double_arrow,
                  ),
                ],
              ),
              WeeklyAnalysisChart(habit: widget.habit,),

              CalendarPage(habit: widget.habit,)



            ],
          ),
        ),
      ),
    );
  }


}
