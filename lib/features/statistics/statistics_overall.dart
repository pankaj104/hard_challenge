import 'package:flutter/material.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/widgets/weekly_analysis_chart_overall_habit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../model/habit_model.dart';
import '../../widgets/info_tile_widget.dart';

class StatisticsOverall extends StatefulWidget {
  final List<Habit> habit;

  const StatisticsOverall({super.key, required this.habit});

  @override
  State<StatisticsOverall> createState() => _StatisticsOverallState();
}

class _StatisticsOverallState extends State<StatisticsOverall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overall Statistics'),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child){
          List<Habit> allHabits = habitProvider.getAllHabit();
         double overallcompletionPercentage =  habitProvider.getOverallCompletionPercentage() / 100;
         double overallMissedPercentage =  habitProvider.getOverallMissedPercentage() /100;
         double overallSkippedPercentage =  habitProvider.getOverallSkippedPercentage() /100 ;
              return Column(
                children: [
                  ElevatedButton(onPressed: (){
                    habitProvider.getOverallCompletionPercentage();
                  }, child: Text(allHabits[0].title)),

                  SizedBox(height: 20,),

                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 20.0,
                                percent: 1- (overallcompletionPercentage + overallSkippedPercentage),
                                backgroundColor: Colors.transparent,
                                progressColor: Colors.blue[700],
                                circularStrokeCap: CircularStrokeCap.round,
                              ),
                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 20.0,
                                percent: overallcompletionPercentage + overallSkippedPercentage,
                                backgroundColor: Colors.grey[300]!,
                                progressColor: Colors.lightBlue[300],
                                circularStrokeCap: CircularStrokeCap.round,
                              ),

                              CircularPercentIndicator(
                                radius: 100.0,
                                lineWidth: 20.0,
                                percent: overallcompletionPercentage,
                                backgroundColor: Colors.transparent,
                                progressColor: Colors.blue[900],
                                circularStrokeCap: CircularStrokeCap.round,
                                center: Text(
                                  '${(overallcompletionPercentage * 100).toStringAsFixed(1)} %',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoTile(
                        color: Colors.blue[900]!,
                        label: 'Completed',
                        value: '${(overallcompletionPercentage * 100).toStringAsFixed(1)} %',
                        icon: Icons.check,
                      ),
                      InfoTile(
                        color: Colors.blue[700]!,
                        label: 'Missed',
                        value:  '${(overallMissedPercentage * 100).toStringAsFixed(1)} %',
                        icon: Icons.close,
                      ),
                      InfoTile(
                        color: Colors.lightBlue[300]!,
                        label: 'Skipped',
                        value: '${(overallSkippedPercentage * 100).toStringAsFixed(1)} %',
                        icon: Icons.double_arrow,
                      ),
                    ],
                  ),

                  WeeklyAnalysisChartOverallHabit(habit: allHabits,),



                ],





              );



        }

      )
    );
  }
}
