// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/service/notification_service.dart';
import 'package:provider/provider.dart';

import 'features/mainScreen/main_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // Initialize the notification service
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: ScreenUtilInit(
        // designSize: const Size(375, 812),
        child: MaterialApp(
          title: 'Custom Challenge App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MainScreen(),
        ),
      ),
    );
  }
}
