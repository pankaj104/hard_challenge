import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/habit_model.dart';

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
    for (var entry in widget.habit.progress.entries) {
      DateTime progressDate = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (progressDate == normalizedDate) {
        return entry.value * 100;
      }
    }
    return 0.0; // Return null if no progress found for the given date
  }

  BarChartGroupData _makeGroupData(int x, DateTime date) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: getProgressForDate(date)!,
          color: _touchedIndex == x ? Colors.blueAccent : Colors.blue,
          width: 16,
        ),
      ],
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            const style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);
            String text;
            switch (value.toInt()) {
              case 0:
                text = 'Sun';
                break;
              case 1:
                text = 'Mon';
                break;
              case 2:
                text = 'Tue';
                break;
              case 3:
                text = 'Wed';
                break;
              case 4:
                text = 'Thu';
                break;
              case 5:
                text = 'Fri';
                break;
              case 6:
                text = 'Sat';
                break;
              default:
                text = '';
            }
            return SideTitleWidget(child: Text(text, style: style), axisSide: meta.axisSide);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          getTitlesWidget: (double value, TitleMeta meta) {
            return Text('${value.toInt()}%', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12));
          },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _previousWeek,
              ),
              Text(
                _formatDateRange(_currentStartOfWeek, endOfWeek),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextWeek,
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceBetween,
                  barGroups: _createBarGroups(),
                  titlesData: _buildTitlesData(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: Colors.blueAccent,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
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
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
        ],
      ),
    );
  }
}