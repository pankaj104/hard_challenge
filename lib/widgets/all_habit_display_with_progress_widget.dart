import 'package:flutter/material.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitTile extends StatelessWidget {
  final DateTime? selectedDateforSkip;

  const HabitTile({Key? key, this.selectedDateforSkip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        List<Habit> allHabits = habitProvider.getAllHabit();
        return allHabits.isNotEmpty
            ? SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          // Adjust height
          child: ListView.builder(
            shrinkWrap: true, // Ensures it takes only necessary space
            itemCount: allHabits.length,
            itemBuilder: (context, index) {
              Habit habit = allHabits[index];
              double overallcompletionPercentage =  habitProvider.getOverallTaskCompletionPercentage(habit) / 100;

              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: habit.iconBgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          habit.habitEmoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              habit.category,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                '${(overallcompletionPercentage * 100).toStringAsFixed(1)} %',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
            : const Center(child: Text('No Habit found'));
      },
    );
  }
}
