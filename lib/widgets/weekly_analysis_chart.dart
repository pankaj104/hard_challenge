import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../model/habit_model.dart';
import '../utils/colors.dart';
import '../utils/image_resource.dart';
import 'custom_tooltip.dart';

class WeeklyAnalysisChart extends StatefulWidget {
  final Habit habit;
  const WeeklyAnalysisChart({super.key, required this.habit});

  @override
  _WeeklyAnalysisChartState createState() => _WeeklyAnalysisChartState();
}

class _WeeklyAnalysisChartState extends State<WeeklyAnalysisChart> {
  DateTime _currentStartOfWeek = DateTime.now();
  int _touchedIndex = -1;


  @override
  void initState() {
    super.initState();
    _currentStartOfWeek = _getStartOfWeek(DateTime.now());
    log('currentStartOfWeek: $_currentStartOfWeek');
  }


  DateTime _getStartOfWeek(DateTime date) {
    // If the day is Sunday (weekday == 7), it should remain unchanged
    int daysToSubtract = (date.weekday % 7);
    return date.subtract(Duration(days: daysToSubtract));
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final DateFormat formatter = DateFormat('d MMM');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  void _previousWeek() {
    setState(() {
      _currentStartOfWeek = _currentStartOfWeek.subtract(Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentStartOfWeek = _currentStartOfWeek.add(Duration(days: 7));
    });
    log('habit data ${widget.habit}');
  }


  List<BarChartGroupData> _createBarGroups() {
    return List.generate(7, (index) => _makeGroupData(index, _currentStartOfWeek.add(Duration(days: index))));
  }


  double getProgressForDate(DateTime date) {
    // Normalize the date to only consider the date part
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    // Iterate through the progress map to find the progress for the normalized date
    for (var entry in widget.habit.progressJson.entries) {
      DateTime progressDate = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (progressDate == normalizedDate) {
        return entry.value.progress * 100;
      }
    }
    return 0.0; // Return null if no progress found for the given date
  }

  // BarChartGroupData _makeGroupData(int x, DateTime date) {
  //   return BarChartGroupData(
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         toY: getProgressForDate(date)!,
  //         color: widget.habit.habitType == HabitType.build ? _touchedIndex == x ? Colors.blueAccent : Colors.blue : _touchedIndex == x ? Colors.blue : Colors.red,
  //         width: 16,
  //       ),
  //     ],
  //   );
  // }

  BarChartGroupData _makeGroupData(int x, DateTime date) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: getProgressForDate(date),
          color: widget.habit.habitType == HabitType.build ? _touchedIndex == x ? Colors.blueAccent : Colors.blue : _touchedIndex == x ? Colors.blue : Colors.red,
          width: 12,
          borderRadius:  const BorderRadius.only(
            topLeft: Radius.circular(8), // Rounded top-left corner
            topRight: Radius.circular(8), // Rounded top-right corner
            bottomLeft: Radius.zero, // Flat bottom-left corner
            bottomRight: Radius.zero, // Flat bottom-right corner
          ), // Rounded bars
        ),
      ],
      showingTooltipIndicators: [0], // Show tooltip for the first rod
    );
  }

  // FlTitlesData _buildTitlesData() {
  //   return FlTitlesData(
  //     bottomTitles: AxisTitles(
  //       sideTitles: SideTitles(
  //         showTitles: true,
  //         getTitlesWidget: (double value, TitleMeta meta) {
  //           const style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
  //           String text;
  //           switch (value.toInt()) {
  //             case 0:
  //               text = 'Sun';
  //               break;
  //             case 1:
  //               text = 'Mon';
  //               break;
  //             case 2:
  //               text = 'Tue';
  //               break;
  //             case 3:
  //               text = 'Wed';
  //               break;
  //             case 4:
  //               text = 'Thu';
  //               break;
  //             case 5:
  //               text = 'Fri';
  //               break;
  //             case 6:
  //               text = 'Sat';
  //               break;
  //             default:
  //               text = '';
  //           }
  //           return SideTitleWidget(child: Text(text, style: style), axisSide: meta.axisSide);
  //         },
  //       ),
  //     ),
  //     leftTitles: AxisTitles(
  //       sideTitles: SideTitles(
  //         showTitles: true,
  //         interval: 20,
  //         getTitlesWidget: (double value, TitleMeta meta) {
  //           return FittedBox(
  //             fit: BoxFit.scaleDown,
  //             child: Text('${value.toInt()}%', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //     topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //     rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  //   );
  // }
  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
            String text;
            switch (value.toInt()) {
              case 0: text = 'Sun'; break;
              case 1: text = 'Mon'; break;
              case 2: text = 'Tue'; break;
              case 3: text = 'Wed'; break;
              case 4: text = 'Thu'; break;
              case 5: text = 'Fri'; break;
              case 6: text = 'Sat'; break;
              default: text = '';
            }
            return Padding(
              padding: EdgeInsets.only(left: 8, top: 2,right: 4),
              child: SideTitleWidget(child: Text(text, style: style), axisSide: meta.axisSide),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => Padding(
            padding: const EdgeInsets.only(left: 2.0,right: 6.0),
            child: Column(
              children: [
                Text('${value.toInt()}%', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }


  @override
  Widget build(BuildContext context) {
    final endOfWeek = _currentStartOfWeek.add(Duration(days: 6));

    return Container(
      height: 320,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 13),
            child: Align(
              alignment: Alignment.center,
              child: Text("Analysis", style: TextStyle(color: ColorStrings.blackColor,
                  fontWeight: FontWeight.w600,fontSize: 17),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _previousWeek,
                  child: SvgPicture.asset(
                    ImageResource.calenderLeft,
                    // onPressed: _previousWeek,
                  ),
                ),
                Text(
                  _formatDateRange(_currentStartOfWeek, endOfWeek),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                InkWell(
                  onTap: _nextWeek,
                  child: SvgPicture.asset(
                    ImageResource.calenderRight,
                    // onPressed: _nextWeek,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  barGroups: _createBarGroups(),
                  titlesData: _buildTitlesData(),
                  borderData: FlBorderData(show: false),
                  // gridData: FlGridData(
                  //   show: true,
                  //   horizontalInterval: 20,
                  //   getDrawingHorizontalLine: (value) => FlLine(
                  //     color: Colors.amber[300]!,
                  //     strokeWidth: 1,
                  //   ),
                  // ),
                  gridData: FlGridData(
                      show: true,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        // print("PercentValue: $value");
                        if (value == 0 || value == 100){
                          return FlLine(
                            color: Colors.black, // Bold line color for 0% and 100%
                            strokeWidth: 2, // Thicker lines for emphasis
                          );
                        }
                        return FlLine(
                          color: ColorStrings.yAxisRod.withOpacity(0.2), // Subtle grid lines
                          strokeWidth: 1,
                        );
                      }
                  ).copyWith(
                      drawVerticalLine: false
                  ),
                  barTouchData:
                  BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideVertically: true,
                      // tooltipBgColor: Colors.blueAccent,
                      tooltipRoundedRadius: 100,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        //here i am passing this CustomTooltip
                        BarTooltipItem(
                          '${rod.toY}%',
                          TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (event is FlTapUpEvent) {
                          _touchedIndex = barTouchResponse?.spot?.touchedBarGroupIndex ?? -1;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_touchedIndex != -1)
            Column(
              children: [
                Text(
                  'Selected: ${_touchedIndex + 1} day of the week with ${_createBarGroups()[_touchedIndex].barRods[0].toY}%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                CircularProgressIndicator(
                  value: _createBarGroups()[_touchedIndex].barRods[0].toY / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.amber,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
        ],
      ),
    );
  }
}