import 'package:flutter/material.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/utils/app_utils.dart';
import 'package:hard_challenge/widgets/weekly_analysis_chart_overall_habit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../model/habit_model.dart';
import '../../utils/colors.dart';
import '../../widgets/calendar_category_wise_widget.dart';
import '../../widgets/info_tile_widget.dart';
import '../../widgets/weekly_analysis_chart_category_wise.dart';

class StatisticsCategoryWise extends StatefulWidget {
  final List<Habit> habit;

  const StatisticsCategoryWise({super.key, required this.habit});

  @override
  State<StatisticsCategoryWise> createState() => _StatisticsCategoryWiseState();
}

class _StatisticsCategoryWiseState extends State<StatisticsCategoryWise> {

  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Category wise Statistics'),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
          child: SingleChildScrollView(
            child: Consumer<HabitProvider>(
                builder: (context, habitProvider, child){
                  List<Habit> allHabits = habitProvider.getAllHabit();
                  double overallcompletionPercentage =  habitProvider.getOverallCompletionPercentage(categories[_currentPage]) / 100;
                  double overallMissedPercentage =  habitProvider.getOverallMissedPercentage(categories[_currentPage]) /100;
                  double overallSkippedPercentage =  habitProvider.getOverallSkippedPercentage(categories[_currentPage]) /100 ;
                  return allHabits.isNotEmpty ?
                  Column(
                    children: [
                      Container(
                        height: 200,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return _buildCard(index);
                          },
                        ),
                      ),
                      Container(
                        color: Colors.white, // Background color for the text area
                        child: Center(
                          child: Text(
                            'Category: ${categories[_currentPage]}',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      ElevatedButton(onPressed: (){
                        habitProvider.getOverallCompletionPercentage(categories[_currentPage]);
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
                      const SizedBox(height: 20,),
                      Padding(
                        padding: EdgeInsets.only(bottom: 24,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 85,
                                decoration: BoxDecoration(
                                color: Colors.green!, // Set the background color
                                borderRadius: BorderRadius.circular(12),
                                ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18),
                                child: InfoTile(
                                  color: ColorStrings.whiteColor,
                                  label: 'Completed',
                                  value: '${(overallcompletionPercentage * 100).toStringAsFixed(1)} %',
                                  icon: Icons.done,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                                height: 85,
                                decoration: BoxDecoration(
                                  color:Colors.redAccent!, // Set the background color
                                borderRadius: BorderRadius.circular(12),
                                ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: InfoTile(
                                  color: ColorStrings.whiteColor,
                                  label: 'Missed',
                                  value:  '${(overallMissedPercentage * 100).toStringAsFixed(1)} %',
                                  icon: Icons.close,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(
                              height: 85,
                              decoration: BoxDecoration(
                                color: Colors.amberAccent, // Set the background color
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: InfoTile(
                                  color: ColorStrings.whiteColor,
                                  label: 'Skipped',
                                  value: '${(overallSkippedPercentage * 100).toStringAsFixed(1)} %',
                                  icon: Icons.last_page,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///  WeeklyAnalysisChartCategoryWise

                      // WeeklyAnalysisChartCategoryWise(habit: allHabits, selectedCategory: categories[_currentPage], ),

                      CalendarCategoryWisePage(habit: allHabits, selectedCategory: categories[_currentPage],)



                    ],





                  ):

                        Center(child: Text('No habit found'));



                }

            ),
          ),
        )
    );
  }
  Widget _buildCard(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 200,
            width: Curves.easeOut.transform(value) * 200,
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.primaries[index % Colors.primaries.length], // Different color for each card
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            categories[_currentPage],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}



