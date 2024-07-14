import 'package:flutter/material.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:provider/provider.dart';

import '../../model/habit_model.dart';

class StatisticsOverall extends StatefulWidget {
  const StatisticsOverall({super.key});

  @override
  State<StatisticsOverall> createState() => _StatisticsOverallState();
}

class _StatisticsOverallState extends State<StatisticsOverall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child){
          List<Habit> allHabits = habitProvider.getAllHabit();
          return ListView.builder(
            itemCount: allHabits.length,
            itemBuilder: (context, index){
              Habit habit = allHabits[index];
              return ListTile(
                title: Text(habit.title),
              );
            }

          );
        }

      )
    );
  }
}
