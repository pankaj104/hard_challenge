import 'package:flutter/material.dart';
import '../../model/habit_model.dart';

class StatisticsScreen extends StatelessWidget {
  final Habit habit;

  StatisticsScreen({required this.habit});

  @override
  Widget build(BuildContext context) {
    double completionPercentage = habit.getCompletionPercentage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Habit: ${habit.title}', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('Category: ${habit.category}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text('Completion: ${completionPercentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: completionPercentage / 100),
          ],
        ),
      ),
    );
  }
}
