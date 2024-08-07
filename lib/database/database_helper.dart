// import 'dart:async';
// import 'dart:developer';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import '../model/habit_model.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   static Database? _database;
//
//   factory DatabaseHelper() {
//     return _instance;
//   }
//
//   DatabaseHelper._internal();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'habit_432.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//     CREATE TABLE habits (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//      title TEXT,
//       category TEXT,
//       habitIcon INTEGER,
//       iconBgColor INTEGER,
//       notificationTime TEXT,
//       taskType INTEGER,
//       repeatType INTEGER,
//       timer INTEGER,
//       value INTEGER,
//       progressJson TEXT,
//       days TEXT,
//       selectedDates TEXT,
//       selectedTimesPerWeek INTEGER,
//       selectedTimesPerMonth INTEGER,
//       startDate TEXT,
//       endDate TEXT,
//       notes TEXT
//     )
//     ''');
//   }
//
//   Future<void> insertHabit(Habit habit) async {
//     final db = await database;
//     await db.insert('habits', habit.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   Future<List<Habit>> habits() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('habits');
//     return List.generate(maps.length, (i) {
//       return Habit.fromJson(maps[i]);
//     });
//   }
//
//   Future<void> updateHabit(Habit habit) async {
//     final db = await database;
//     await db.update(
//       'habits',
//       habit.toJson(),
//       where: 'id = ?',
//       whereArgs: [habit.id],
//     );
//   }
//
//   Future<void> deleteHabit(int id) async {
//     final db = await database;
//     await db.delete(
//       'habits',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
