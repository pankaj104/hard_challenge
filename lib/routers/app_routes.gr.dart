// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../features/mainScreen/main_screen.dart' as _i1;
import '../features/statistics/statistics_category_wise.dart' as _i4;
import '../features/statistics/statistics_habit_wise_screen.dart' as _i3;
import '../model/habit_model.dart' as _i7;
import '../pages/add_habit_screen.dart' as _i2;

class AppRoute extends _i5.RootStackRouter {
  AppRoute([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    MainScreen.name: (routeData) {
      return _i5.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i1.MainScreen(),
      );
    },
    AddHabitScreen.name: (routeData) {
      return _i5.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const _i2.AddHabitScreen(),
      );
    },
    StatisticsHabitWiseScreen.name: (routeData) {
      final args = routeData.argsAs<StatisticsHabitWiseScreenArgs>();
      return _i5.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i3.StatisticsHabitWiseScreen(
          habit: args.habit,
          selectedDateforSkip: args.selectedDateforSkip,
        ),
      );
    },
    StatisticsCategoryWise.name: (routeData) {
      final args = routeData.argsAs<StatisticsCategoryWiseArgs>();
      return _i5.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i4.StatisticsCategoryWise(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          MainScreen.name,
          path: '/',
        ),
        _i5.RouteConfig(
          AddHabitScreen.name,
          path: '/add-habit-screen',
        ),
        _i5.RouteConfig(
          StatisticsHabitWiseScreen.name,
          path: '/statistics-habit-wise-screen',
        ),
        _i5.RouteConfig(
          StatisticsCategoryWise.name,
          path: '/statistics-category-wise',
        ),
      ];
}

/// generated route for
/// [_i1.MainScreen]
class MainScreen extends _i5.PageRouteInfo<void> {
  const MainScreen()
      : super(
          MainScreen.name,
          path: '/',
        );

  static const String name = 'MainScreen';
}

/// generated route for
/// [_i2.AddHabitScreen]
class AddHabitScreen extends _i5.PageRouteInfo<void> {
  const AddHabitScreen()
      : super(
          AddHabitScreen.name,
          path: '/add-habit-screen',
        );

  static const String name = 'AddHabitScreen';
}

/// generated route for
/// [_i3.StatisticsHabitWiseScreen]
class StatisticsHabitWiseScreen
    extends _i5.PageRouteInfo<StatisticsHabitWiseScreenArgs> {
  StatisticsHabitWiseScreen({
    required _i7.Habit habit,
    required DateTime selectedDateforSkip,
  }) : super(
          StatisticsHabitWiseScreen.name,
          path: '/statistics-habit-wise-screen',
          args: StatisticsHabitWiseScreenArgs(
            habit: habit,
            selectedDateforSkip: selectedDateforSkip,
          ),
        );

  static const String name = 'StatisticsHabitWiseScreen';
}

class StatisticsHabitWiseScreenArgs {
  const StatisticsHabitWiseScreenArgs({
    required this.habit,
    required this.selectedDateforSkip,
  });

  final _i7.Habit habit;

  final DateTime selectedDateforSkip;

  @override
  String toString() {
    return 'StatisticsHabitWiseScreenArgs{habit: $habit, selectedDateforSkip: $selectedDateforSkip}';
  }
}

/// generated route for
/// [_i4.StatisticsCategoryWise]
class StatisticsCategoryWise
    extends _i5.PageRouteInfo<StatisticsCategoryWiseArgs> {
  StatisticsCategoryWise({
    _i6.Key? key,
    required List<_i7.Habit> habit,
  }) : super(
          StatisticsCategoryWise.name,
          path: '/statistics-category-wise',
          args: StatisticsCategoryWiseArgs(
            key: key,
            habit: habit,
          ),
        );

  static const String name = 'StatisticsCategoryWise';
}

class StatisticsCategoryWiseArgs {
  const StatisticsCategoryWiseArgs({
    this.key,
    required this.habit,
  });

  final _i6.Key? key;

  final List<_i7.Habit> habit;

  @override
  String toString() {
    return 'StatisticsCategoryWiseArgs{key: $key, habit: $habit}';
  }
}
