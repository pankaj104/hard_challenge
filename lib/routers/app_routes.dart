import 'package:auto_route/auto_route.dart';
import 'package:auto_route/annotations.dart';
import 'package:hard_challenge/features/addChallenge/add_challenge_screen.dart';
import 'package:hard_challenge/features/mainScreen/main_screen.dart';
import 'package:hard_challenge/features/statistics/statistics_category_wise.dart';
import 'package:hard_challenge/features/statistics/statistics_habit_wise_screen.dart';
import 'package:hard_challenge/pages/add_habit_screen.dart';
import 'package:hard_challenge/pages/habit_notes_reason_date_wise.dart';
import 'package:hard_challenge/pages/settings/language_selection_screen.dart';
import 'package:hard_challenge/pages/settings/settings_screen.dart';


@CupertinoAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute<dynamic>(page: MainScreen, initial: true),
    AutoRoute<dynamic>(page: AddHabitScreen),
    AutoRoute<dynamic>(page: StatisticsHabitWiseScreen),
    AutoRoute<dynamic>(page: StatisticsCategoryWise),
    AutoRoute<dynamic>(page: AddChallengeScreen),
    AutoRoute<dynamic>(page: HabitNotesReasonDateWise),
    AutoRoute<dynamic>(page: SettingsScreen),
    AutoRoute<dynamic>(page: LanguageSelectionScreen),

  ],
)

/// appRoute class
class $AppRoute {}
