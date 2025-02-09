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
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

import '../features/addChallenge/add_challenge_screen.dart' as _i5;
import '../features/mainScreen/main_screen.dart' as _i1;
import '../features/statistics/statistics_category_wise.dart' as _i4;
import '../features/statistics/statistics_habit_wise_screen.dart' as _i3;
import '../model/habit_model.dart' as _i9;
import '../pages/add_habit_screen.dart' as _i2;
import '../pages/habit_notes_reason_date_wise.dart' as _i6;

class AppRoute extends _i7.RootStackRouter {
  AppRoute([_i8.GlobalKey<_i8.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    MainScreen.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i1.MainScreen(),
      );
    },
    AddHabitScreen.name: (routeData) {
      return _i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const _i2.AddHabitScreen(),
      );
    },
    StatisticsHabitWiseScreen.name: (routeData) {
      final args = routeData.argsAs<StatisticsHabitWiseScreenArgs>();
      return _i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i3.StatisticsHabitWiseScreen(
          habit: args.habit,
          selectedDateforSkip: args.selectedDateforSkip,
        ),
      );
    },
    StatisticsCategoryWise.name: (routeData) {
      final args = routeData.argsAs<StatisticsCategoryWiseArgs>();
      return _i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i4.StatisticsCategoryWise(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
    AddChallengeScreen.name: (routeData) {
      final args = routeData.argsAs<AddChallengeScreenArgs>();
      return _i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i5.AddChallengeScreen(
          key: args.key,
          habit: args.habit,
          isFromEdit: args.isFromEdit,
          isFromFilledHabbit: args.isFromFilledHabbit,
        ),
      );
    },
    HabitNotesReasonDateWise.name: (routeData) {
      final args = routeData.argsAs<HabitNotesReasonDateWiseArgs>();
      return _i7.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i6.HabitNotesReasonDateWise(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          MainScreen.name,
          path: '/',
        ),
        _i7.RouteConfig(
          AddHabitScreen.name,
          path: '/add-habit-screen',
        ),
        _i7.RouteConfig(
          StatisticsHabitWiseScreen.name,
          path: '/statistics-habit-wise-screen',
        ),
        _i7.RouteConfig(
          StatisticsCategoryWise.name,
          path: '/statistics-category-wise',
        ),
        _i7.RouteConfig(
          AddChallengeScreen.name,
          path: '/add-challenge-screen',
        ),
        _i7.RouteConfig(
          HabitNotesReasonDateWise.name,
          path: '/habit-notes-reason-date-wise',
        ),
      ];
}

/// generated route for
/// [_i1.MainScreen]
class MainScreen extends _i7.PageRouteInfo<void> {
  const MainScreen()
      : super(
          MainScreen.name,
          path: '/',
        );

  static const String name = 'MainScreen';
}

/// generated route for
/// [_i2.AddHabitScreen]
class AddHabitScreen extends _i7.PageRouteInfo<void> {
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
    extends _i7.PageRouteInfo<StatisticsHabitWiseScreenArgs> {
  StatisticsHabitWiseScreen({
    required _i9.Habit habit,
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

  final _i9.Habit habit;

  final DateTime selectedDateforSkip;

  @override
  String toString() {
    return 'StatisticsHabitWiseScreenArgs{habit: $habit, selectedDateforSkip: $selectedDateforSkip}';
  }
}

/// generated route for
/// [_i4.StatisticsCategoryWise]
class StatisticsCategoryWise
    extends _i7.PageRouteInfo<StatisticsCategoryWiseArgs> {
  StatisticsCategoryWise({
    _i8.Key? key,
    required List<_i9.Habit> habit,
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

  final _i8.Key? key;

  final List<_i9.Habit> habit;

  @override
  String toString() {
    return 'StatisticsCategoryWiseArgs{key: $key, habit: $habit}';
  }
}

/// generated route for
/// [_i5.AddChallengeScreen]
class AddChallengeScreen extends _i7.PageRouteInfo<AddChallengeScreenArgs> {
  AddChallengeScreen({
    _i8.Key? key,
    _i9.Habit? habit,
    required bool isFromEdit,
    required bool isFromFilledHabbit,
  }) : super(
          AddChallengeScreen.name,
          path: '/add-challenge-screen',
          args: AddChallengeScreenArgs(
            key: key,
            habit: habit,
            isFromEdit: isFromEdit,
            isFromFilledHabbit: isFromFilledHabbit,
          ),
        );

  static const String name = 'AddChallengeScreen';
}

class AddChallengeScreenArgs {
  const AddChallengeScreenArgs({
    this.key,
    this.habit,
    required this.isFromEdit,
    required this.isFromFilledHabbit,
  });

  final _i8.Key? key;

  final _i9.Habit? habit;

  final bool isFromEdit;

  final bool isFromFilledHabbit;

  @override
  String toString() {
    return 'AddChallengeScreenArgs{key: $key, habit: $habit, isFromEdit: $isFromEdit, isFromFilledHabbit: $isFromFilledHabbit}';
  }
}

/// generated route for
/// [_i6.HabitNotesReasonDateWise]
class HabitNotesReasonDateWise
    extends _i7.PageRouteInfo<HabitNotesReasonDateWiseArgs> {
  HabitNotesReasonDateWise({
    _i8.Key? key,
    required _i9.Habit habit,
  }) : super(
          HabitNotesReasonDateWise.name,
          path: '/habit-notes-reason-date-wise',
          args: HabitNotesReasonDateWiseArgs(
            key: key,
            habit: habit,
          ),
        );

  static const String name = 'HabitNotesReasonDateWise';
}

class HabitNotesReasonDateWiseArgs {
  const HabitNotesReasonDateWiseArgs({
    this.key,
    required this.habit,
  });

  final _i8.Key? key;

  final _i9.Habit habit;

  @override
  String toString() {
    return 'HabitNotesReasonDateWiseArgs{key: $key, habit: $habit}';
  }
}
