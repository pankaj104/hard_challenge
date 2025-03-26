// main.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hard_challenge/l10n/messages.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/pages/settings/controller/language_controller.dart';
import 'package:hard_challenge/provider/habit_provider.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/service/notification_service.dart';
import 'package:hard_challenge/themes/theme_provider.dart';
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
  Get.put(LanguageController());
  await NotificationService().init(); // Initialize the notification service
  await Hive.openBox('settingsBox');
  await Hive.openBox<String>('categoriesBox'); // Open a box for categories
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRoute();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HabitProvider()), // Keeping HabitProvider
        ChangeNotifierProvider(create: (context) => ThemeProvider()), // Adding ThemeProvider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            builder: (context, child) => GetMaterialApp.router(
              scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(), // To show snackbars/toasts
              title: 'Custom Challenge App',
              translations: Messages(), // GetX localization
              locale: LanguageController().getSavedLocale(),
              fallbackLocale: const Locale('en'),
              supportedLocales: const [
                Locale('en'), // ✅ English
                Locale('es'), // ✅ Spanish (without 'ES')
                Locale('fr'), // ✅ French (without 'FR')
                Locale('de'), // ✅ German (without 'DE')
                Locale('ja'), // ✅ Japanese (without 'JP')
                Locale('ar'), // ✅ Arabic (without 'SA')
              ],

              // ✅ Flutter's Built-in Localization Support
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate, // Material Widgets Localization
                GlobalWidgetsLocalizations.delegate, // Basic Widgets Localization
                GlobalCupertinoLocalizations.delegate, // Cupertino (iOS) Localization
              ],
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              // highContrastTheme: themeProvider.lightTheme,
              // highContrastDarkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode, // User's selected theme mode
              // themeAnimationDuration: const Duration(milliseconds: 300), // Smooth transition
              // themeAnimationCurve: Curves.easeInOut,
              debugShowCheckedModeBanner: false, // Hide debug banner
              routerDelegate: _appRouter.delegate(
                navigatorObservers: () => [AutoRouteObserver()],
                initialRoutes: [
                  const PageRouteInfo<dynamic>('MainScreen', path: '/'),
                ],
              ),
              routeInformationParser: _appRouter.defaultRouteParser(),
              routeInformationProvider: _appRouter.routeInfoProvider(),
              backButtonDispatcher: RootBackButtonDispatcher(), // Handle back button navigation
              builder: (context, child) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode()); // Hide keyboard on tap
                  },
                  child: child!,
                );
              },
            ),
          );
        },
      ),
    );

  }
}
