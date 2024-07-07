import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/habit_model.dart';
import '../../utils/image_resource.dart';
import '../../widgets/calendar_widget.dart';
import '../../widgets/headingH2_widget.dart';
import '../../widgets/icon_button_widget.dart';
import '../../widgets/info_tile_widget.dart';
import '../../widgets/weekly_analysis_chart.dart';

class StatisticsScreen extends StatefulWidget {
  final Habit habit;

  StatisticsScreen({required this.habit});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    double completionPercentage = widget.habit.getCompletionPercentage();

    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;

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
                      child: HeadingH2Widget("Statistcs"),
                    ),
                  ),
                  SizedBox(
                    width: 42.w,
                  ),
                ],
              ),


              Center(child: Text(' ${widget.habit.title}', style: const TextStyle(fontSize: 24))),
              const SizedBox(height: 16),
              Text('Category: ${widget.habit.category}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
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
                    percent: 1.0,
                    backgroundColor: Colors.grey[300]!,
                    progressColor: Colors.lightBlue[300],
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 20.0,
                    percent: 0.90,
                    backgroundColor: Colors.transparent,
                    progressColor: Colors.blue[700],
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 20.0,
                    percent: completionPercentage / 100,
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
                    value: '25%',
                    icon: Icons.close,
                  ),
                  InfoTile(
                    color: Colors.lightBlue[300]!,
                    label: 'Skipped',
                    value: '10%',
                    icon: Icons.double_arrow,
                  ),
                ],
              ),

              WeeklyAnalysisChart(habit: widget.habit,),

              CalendarPage()



            ],
          ),
        ),
      ),
    );
  }
}
