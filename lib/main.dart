import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/service/notification_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'features/mainScreen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request Notification Permission
  await _requestNotificationPermission();
  await requestExactAlarmPermission();

  // Initialize Notifications
  await NotificationService().initNotifications();

  // Initialize Hive
  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(ProgressWithStatusAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(IconDataAdapter());
  Hive.registerAdapter(MaterialColorAdapter());
  Hive.registerAdapter(TaskTypeAdapter());
  Hive.registerAdapter(RepeatTypeAdapter());
  Hive.registerAdapter(HabitTypeAdapter());
  Hive.registerAdapter(TaskStatusAdapter());
  Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(ColorAdapter());

  // Open Hive Boxes
  await Hive.openBox<String>('categoriesBox');

  runApp(MyApp());
}

Future<void> _requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
Future<void> requestExactAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}


class MyApp extends StatelessWidget {
  final _appRouter = AppRoute();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: ScreenUtilInit(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Custom Challenge App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerDelegate: _appRouter.delegate(
            navigatorObservers: () => [AutoRouteObserver()],
            initialRoutes: [
              const PageRouteInfo<dynamic>('MainScreen', path: '/'),
            ],
          ),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
