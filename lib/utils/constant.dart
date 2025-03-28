import 'dart:math';
import 'dart:ui';

import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:uuid/uuid.dart';



class ConstantData {
  List<String> quotes = [
    "If you are going to achieve excellence in big things, you develop the habit in little matters.",
    "Success is the sum of small efforts repeated day in and day out.",
    "The journey of a thousand miles begins with one step.",
    "Discipline is the bridge between goals and accomplishment.",
    "Success is the result of preparation, hard work, and learning from failure.",
    "The only way to do great work is to love what you do.",
    "Do something today that your future self will thank you for.",
    "What we do today matters.",
    "A year from now you may wish you had started today.",
    "Small daily improvements over time lead to stunning results.",
    "Success doesn’t come from what you do occasionally, it comes from what you do consistently.",
    "Don’t watch the clock; do what it does. Keep going.",
    "Don’t limit your challenges. Challenge your limits.",
    "If you want to go fast, go alone. If you want to go far, go together.",
    "Motivation is what gets you started. Habit is what keeps you going.",
    "The only time success comes before work is in the dictionary.",
    "Your habits shape your future.",
    "Strive for progress, not perfection.",
    "Success is not the key to happiness. Happiness is the key to success.",
    "Believe you can and you're halfway there.",
    "Act as if what you do makes a difference. It does.",
    "Start where you are. Use what you have. Do what you can.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "The harder you work for something, the greater you'll feel when you achieve it.",
    "Great things never come from comfort zones.",
    "Success is the sum of small efforts, repeated day in and day out.",
    "It always seems impossible until it’s done.",
    "If you want something you’ve never had, you must be willing to do something you’ve never done.",
    "The best time to plant a tree was 20 years ago. The second best time is now.",
    "Success is not how high you have climbed, but how you make a positive difference to the world.",
    "You don’t have to be great to start, but you have to start to be great.",
    "Don't count the days, make the days count.",
    "Success doesn’t happen overnight.",
    "Success is the progressive realization of a worthy goal.",
    "Good things come to those who hustle.",
    "You are never too old to set another goal or to dream a new dream.",
    "Focus on being productive instead of busy.",
    "Success is not the absence of failure; it’s the persistence through failure.",
    "The key to success is to start before you’re ready.",
    "What you get by achieving your goals is not as important as what you become by achieving your goals.",
    "A goal without a plan is just a wish.",
    "Small changes can make a big difference.",
    "Hard work beats talent when talent doesn’t work hard.",
    "The future depends on what we do in the present.",
    "Believe in yourself and all that you are.",
    "It’s never too late to be what you might have been.",
    "Don’t stop when you’re tired. Stop when you’re done.",
    "The secret to getting ahead is getting started.",
    "Don’t wait for opportunity. Create it.",
    "Every day is a chance to get better.",
    "Fall in love with the process, not the outcome.",
    "Success is what happens after you’ve survived all your mistakes.",
    "Little by little, one travels far."
  ];
  String getRandomQuote() {
    Random random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}
final Uuid uuid = Uuid();

final List<Habit> preRecorededHabitList = [

  Habit(
    id: uuid.v4(),
    title: 'Run',
    category: 'Sport',
    habitEmoji: '🏃',
    iconBgColor: const Color(0xFFFF5722),
    notificationTime: ["6:30 AM"],
    taskType: TaskType.count,
    value: 3, // Kilometers
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Yoga',
    category: 'Sport',
    habitEmoji: '🧘',
    iconBgColor: const Color(0xFF9C27B0),
    notificationTime: ["6:00 AM"],
    taskType: TaskType.time,
    value: 30, // Minutes
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Exercise',
    category: 'Sport',
    habitEmoji: '🏋️',
    iconBgColor: const Color(0xFFFFC107),
    notificationTime: ["7:30 AM"],
    taskType: TaskType.count,
    value: 15, // Sets
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Swim',
    category: 'Sport',
    habitEmoji: '🏊',
    iconBgColor: const Color(0xFF3F51B5),
    notificationTime: ["5:30 PM"],
    taskType: TaskType.count,
    value: 20, // Laps
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Cycling',
    category: 'Sport',
    habitEmoji: '🚴',
    iconBgColor: const Color(0xFF8BC34A),
    notificationTime: ["6:00 AM"],
    taskType: TaskType.count,
    value: 10, // Kilometers
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),



  /// Health related
  ///
  Habit(
    id: uuid.v4(),
    title: 'Drink Water',
    category: 'Health',
    habitEmoji: '🥛',
    iconBgColor: const Color(0xFF2196F3),
    notificationTime: ["8:00 AM", "12:00 PM", "6:00 PM"],
    taskType: TaskType.count,
    value: 8, // Glasses per day
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),

  Habit(
    id: uuid.v4(),
    title: 'No Sugar',
    category: 'Health',
    habitEmoji: '🚫🍬',
    iconBgColor: const Color(0xFFFF5722),
    notificationTime: ["9:00 AM"],
    taskType: TaskType.task,
    value: 1, // 1 means no sugar for the day
    habitType: HabitType.quit,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Sleep Early',
    category: 'Health',
    habitEmoji: '🌙',
    iconBgColor: const Color(0xFF673AB7),
    notificationTime: ["10:00 PM"],
    taskType: TaskType.time,
    value: 8, // Hours
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Take Medicine',
    category: 'Health',
    habitEmoji: '💊',
    iconBgColor: const Color(0xFF009688),
    notificationTime: ["8:00 AM", "8:00 PM"],
    taskType: TaskType.count,
    value: 1, // Times per day
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'No Alcohol',
    category: 'Health',
    habitEmoji: '🚫🍺',
    iconBgColor: const Color(0xFFE91E63),
    notificationTime: ["6:00 PM"],
    taskType: TaskType.time,
    value: 1, // 1 means no alcohol for the day
    habitType: HabitType.quit,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: "Don't Smoke",
    category: 'Health',
    habitEmoji: '🚭',
    iconBgColor: const Color(0xFF795548),
    notificationTime: ["9:00 AM"],
    taskType: TaskType.task,
    value: 1, // 1 means no smoking for the day
    habitType: HabitType.quit,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),

  /// Spiritual habits list
  Habit(
    id: uuid.v4(),
    title: 'Meditation',
    category: 'Spiritual',
    habitEmoji: '🧘',
    iconBgColor: const Color(0xFF673AB7),
    notificationTime: ["6:00 AM"],
    taskType: TaskType.time,
    value: 10, // Minutes per session
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Gratitude Journaling',
    category: 'Spiritual',
    habitEmoji: '📖',
    iconBgColor: const Color(0xFFFF9800),
    notificationTime: ["9:00 PM"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Affirmations',
    category: 'Spiritual',
    habitEmoji: '🔮',
    iconBgColor: const Color(0xFF4CAF50),
    notificationTime: ["7:00 AM"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Deep Breathing',
    category: 'Spiritual',
    habitEmoji: '🌬️',
    iconBgColor: const Color(0xFF2196F3),
    notificationTime: ["12:00 PM", "8:00 PM"],
    taskType: TaskType.task,
    value: 5, // Minutes per session
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),

  Habit(
    id: uuid.v4(),
    title: 'Acts of Kindness',
    category: 'Spiritual',
    habitEmoji: '🤝',
    iconBgColor: const Color(0xFFFFC107),
    notificationTime: ["10:00 AM"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),

  Habit(
    id: uuid.v4(),
    title: 'Save Money Daily',
    category: 'Finance',
    habitEmoji: '💰',
    iconBgColor: const Color(0xFF4CAF50),
    notificationTime: ["8:00 AM"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Track Expenses',
    category: 'Finance',
    habitEmoji: '📊',
    iconBgColor: const Color(0xFF2196F3),
    notificationTime: ["7:00 PM"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Invest Monthly',
    category: 'Finance',
    habitEmoji: '📈',
    iconBgColor: const Color(0xFFFF5722),
    notificationTime: ["1st of every month"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.monthly,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),
  Habit(
    id: uuid.v4(),
    title: 'Reduce Unnecessary Spending',
    category: 'Finance',
    habitEmoji: '✂️',
    iconBgColor: const Color(0xFF9C27B0),
    notificationTime: ["5:00 PM"],
    taskType: TaskType.task,
    value: 1, // Mark as done
    habitType: HabitType.build,
    repeatType: RepeatType.selectDays,
    progressJson: {},
    startDate: setSelectedDate(DateTime.now()),
  ),


];
