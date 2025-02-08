// main.dart
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

import 'features/mainScreen/main_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
// Register the adapters
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
  await NotificationService().init(); // Initialize the notification service
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRoute();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: ScreenUtilInit(
        // designSize: const Size(375, 812),
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
          routeInformationParser: _appRouter.defaultRouteParser(),        ),
      ),
    );
  }
}
