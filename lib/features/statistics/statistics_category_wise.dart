import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/utils/app_utils.dart';
import 'package:hard_challenge/widgets/all_habit_display_with_progress_widget.dart';
import 'package:hard_challenge/widgets/headingH2_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../model/habit_model.dart';
import '../../utils/colors.dart';
import '../../widgets/calendar_category_wise_widget.dart';
import '../../widgets/info_tile_widget.dart';

class StatisticsCategoryWise extends StatefulWidget {
  final List<Habit> habit;

  const StatisticsCategoryWise({super.key, required this.habit});

  @override
  State<StatisticsCategoryWise> createState() => _StatisticsCategoryWiseState();
}

class _StatisticsCategoryWiseState extends State<StatisticsCategoryWise> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  List<String> categories = AppUtils.categories;
  List<String> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    categories = AppUtils.categories;

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
        title: const Text('Category wise Statistics'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              List<Habit> allHabits = habitProvider.getAllHabit();
              filteredCategories = allHabits
                  .map((habit) => habit.category) // Extract categories
                  .toSet() // Remove duplicates
                  .toList(); // Convert back to a list

              // Handle empty categories case
              if (filteredCategories.isEmpty) {
                return const Center(child: Text('No categories found'));
              }

              // Ensure _currentPage is within bounds
              _currentPage = _currentPage.clamp(0, filteredCategories.length - 1);

              // Get category-based statistics
              String currentCategory = filteredCategories[_currentPage];
              double overallCompletionPercentage = habitProvider.getOverallCompletionPercentage(currentCategory) / 100;
              double overallMissedPercentage = habitProvider.getOverallMissedPercentage(currentCategory) / 100;
              double overallSkippedPercentage = habitProvider.getOverallSkippedPercentage(currentCategory) / 100;

              log('currentCategory $currentCategory overallCompletionPercentage: $overallCompletionPercentage');



              return Column(
                children: [
                  Container(
                    height: 100,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: filteredCategories.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildCard(index);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
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
                              percent: overallMissedPercentage + overallCompletionPercentage + overallSkippedPercentage,
                              backgroundColor: Colors.grey[300]!,
                              progressColor: Colors.red,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            CircularPercentIndicator(
                              radius: 100.0,
                              lineWidth: 20.0,
                              percent: overallCompletionPercentage + overallSkippedPercentage,
                              backgroundColor: Colors.transparent,
                              progressColor: Colors.amberAccent,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            CircularPercentIndicator(
                              radius: 100.0,
                              lineWidth: 20.0,
                              percent: overallCompletionPercentage,
                              backgroundColor: Colors.transparent,
                              progressColor: Colors.green,
                              circularStrokeCap: CircularStrokeCap.round,
                              center: Text(
                                '${(overallCompletionPercentage * 100).toStringAsFixed(1)} %',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoTile(
                          color: Colors.green,
                          label: 'Completed',
                          value: '${(overallCompletionPercentage * 100).toStringAsFixed(1)} %',
                          icon: Icons.done,
                        ),
                        _buildInfoTile(
                          color: Colors.redAccent,
                          label: 'Missed',
                          value: '${(overallMissedPercentage * 100).toStringAsFixed(1)} %',
                          icon: Icons.close,
                        ),
                        _buildInfoTile(
                          color: Colors.amberAccent,
                          label: 'Skipped',
                          value: '${(overallSkippedPercentage * 100).toStringAsFixed(1)} %',
                          icon: Icons.last_page,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
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
                      child: CalendarCategoryWisePage(
                        key: ValueKey(currentCategory), // Forces rebuild when category changes
                        habit: allHabits,
                        selectedCategory: currentCategory,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.centerLeft,
                      child: HeadingH2Widget('Habits in $currentCategory Category')),
                  SizedBox(height: 20,),
                  HabitTile (isForCategoryWiseStatistics: true, currentCategory: currentCategory ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the category selection card
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
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.primaries[index % Colors.primaries.length],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            filteredCategories.isNotEmpty ? filteredCategories[index] : 'No Category',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the info tile for completion, missed, and skipped
  Widget _buildInfoTile({required Color color, required String label, required String value, required IconData icon}) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: InfoTile(
          color: ColorStrings.whiteColor,
          label: label,
          value: value,
          icon: icon,
        ),
      ),
    );
  }



}
