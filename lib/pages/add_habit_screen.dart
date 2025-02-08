import 'package:flutter/material.dart';
import 'package:hard_challenge/features/addChallenge/add_challenge_screen.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/helpers.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Habit> items = [
      Habit(
        id: '1',
        title: 'Drink Water',
        category: 'Work',
        habitEmoji: '🥛',
        iconBgColor: Color(0xFFFF9800),
        notificationTime: ["12:58 PM"],
        taskType: TaskType.count,
        value: 10,
        habitType: HabitType.build,
        repeatType: RepeatType.selectDays,
        progressJson: {},
        startDate: setSelectedDate(DateTime.now()),
      ),
      Habit(
        id: '2',
        title: 'Meditation',
        category: 'Health',
        habitEmoji: '🧘',
        iconBgColor: Color(0xFFFF9800),
        notificationTime: ["12:58 PM"],
        taskType: TaskType.time,
        timer: Duration(minutes: 1),
        habitType: HabitType.build,
        repeatType: RepeatType.selectDays,
        progressJson: {},
        startDate: setSelectedDate(DateTime.now()),
      ),
      Habit(
        id: '3',
        title: 'No Smoking',
        category: 'Health',
        habitEmoji: '🚭',
        iconBgColor: Color(0xFFFF9800),
        notificationTime: ["12:58 PM"],
        taskType: TaskType.task,
        habitType: HabitType.quit,
        repeatType: RepeatType.selectDays,
        progressJson: {},
        startDate: setSelectedDate(DateTime.now()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Habit'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(item.habitEmoji, style: TextStyle(fontSize: 25),),
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.category),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddChallengeScreen(
                              isFromEdit: false,
                              habit: item,
                              isFromFilledHabbit: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddChallengeScreen(
                      isFromEdit: false,
                      isFromFilledHabbit: false,
                    ),
                  ),
                );
              },
              child: Text(
                "Create Your Own",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


