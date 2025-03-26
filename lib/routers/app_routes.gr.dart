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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;

import '../features/addChallenge/add_challenge_screen.dart' as _i5;
import '../features/mainScreen/main_screen.dart' as _i1;
import '../features/statistics/statistics_category_wise.dart' as _i4;
import '../features/statistics/statistics_habit_wise_screen.dart' as _i3;
import '../model/habit_model.dart' as _i11;
import '../pages/add_habit_screen.dart' as _i2;
import '../pages/habit_notes_reason_date_wise.dart' as _i6;
import '../pages/settings/language_selection_screen.dart' as _i8;
import '../pages/settings/settings_screen.dart' as _i7;

class AppRoute extends _i9.RootStackRouter {
  AppRoute([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    MainScreen.name: (routeData) {
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i1.MainScreen(),
      );
    },
    AddHabitScreen.name: (routeData) {
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const _i2.AddHabitScreen(),
      );
    },
    StatisticsHabitWiseScreen.name: (routeData) {
      final args = routeData.argsAs<StatisticsHabitWiseScreenArgs>();
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i3.StatisticsHabitWiseScreen(
          habit: args.habit,
          selectedDateforSkip: args.selectedDateforSkip,
        ),
      );
    },
    StatisticsCategoryWise.name: (routeData) {
      final args = routeData.argsAs<StatisticsCategoryWiseArgs>();
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i4.StatisticsCategoryWise(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
    AddChallengeScreen.name: (routeData) {
      final args = routeData.argsAs<AddChallengeScreenArgs>();
      return _i9.CupertinoPageX<dynamic>(
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
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: _i6.HabitNotesReasonDateWise(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
    SettingsScreen.name: (routeData) {
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const _i7.SettingsScreen(),
      );
    },
    LanguageSelectionScreen.name: (routeData) {
      return _i9.CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const _i8.LanguageSelectionScreen(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          MainScreen.name,
          path: '/',
        ),
        _i9.RouteConfig(
          AddHabitScreen.name,
          path: '/add-habit-screen',
        ),
        _i9.RouteConfig(
          StatisticsHabitWiseScreen.name,
          path: '/statistics-habit-wise-screen',
        ),
        _i9.RouteConfig(
          StatisticsCategoryWise.name,
          path: '/statistics-category-wise',
        ),
        _i9.RouteConfig(
          AddChallengeScreen.name,
          path: '/add-challenge-screen',
        ),
        _i9.RouteConfig(
          HabitNotesReasonDateWise.name,
          path: '/habit-notes-reason-date-wise',
        ),
        _i9.RouteConfig(
          SettingsScreen.name,
          path: '/settings-screen',
        ),
        _i9.RouteConfig(
          LanguageSelectionScreen.name,
          path: '/language-selection-screen',
        ),
      ];
}

/// generated route for
/// [_i1.MainScreen]
class MainScreen extends _i9.PageRouteInfo<void> {
  const MainScreen()
      : super(
          MainScreen.name,
          path: '/',
        );

  static const String name = 'MainScreen';
}

/// generated route for
/// [_i2.AddHabitScreen]
class AddHabitScreen extends _i9.PageRouteInfo<void> {
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
    extends _i9.PageRouteInfo<StatisticsHabitWiseScreenArgs> {
  StatisticsHabitWiseScreen({
    required _i11.Habit habit,
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

  final _i11.Habit habit;

  final DateTime selectedDateforSkip;

  @override
  String toString() {
    return 'StatisticsHabitWiseScreenArgs{habit: $habit, selectedDateforSkip: $selectedDateforSkip}';
  }
}

/// generated route for
/// [_i4.StatisticsCategoryWise]
class StatisticsCategoryWise
    extends _i9.PageRouteInfo<StatisticsCategoryWiseArgs> {
  StatisticsCategoryWise({
    _i10.Key? key,
    required List<_i11.Habit> habit,
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

  final _i10.Key? key;

  final List<_i11.Habit> habit;

  @override
  String toString() {
    return 'StatisticsCategoryWiseArgs{key: $key, habit: $habit}';
  }
}

/// generated route for
/// [_i5.AddChallengeScreen]
class AddChallengeScreen extends _i9.PageRouteInfo<AddChallengeScreenArgs> {
  AddChallengeScreen({
    _i10.Key? key,
    _i11.Habit? habit,
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

  final _i10.Key? key;

  final _i11.Habit? habit;

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
    extends _i9.PageRouteInfo<HabitNotesReasonDateWiseArgs> {
  HabitNotesReasonDateWise({
    _i10.Key? key,
    required _i11.Habit habit,
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

  final _i10.Key? key;

  final _i11.Habit habit;

  @override
  String toString() {
    return 'HabitNotesReasonDateWiseArgs{key: $key, habit: $habit}';
  }
}

/// generated route for
/// [_i7.SettingsScreen]
class SettingsScreen extends _i9.PageRouteInfo<void> {
  const SettingsScreen()
      : super(
          SettingsScreen.name,
          path: '/settings-screen',
        );

  static const String name = 'SettingsScreen';
}

/// generated route for
/// [_i8.LanguageSelectionScreen]
class LanguageSelectionScreen extends _i9.PageRouteInfo<void> {
  const LanguageSelectionScreen()
      : super(
          LanguageSelectionScreen.name,
          path: '/language-selection-screen',
        );

  static const String name = 'LanguageSelectionScreen';
}
