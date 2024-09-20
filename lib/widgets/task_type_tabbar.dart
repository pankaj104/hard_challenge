import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/colors.dart';

class TaskTypeTabBar extends StatefulWidget {
  final Function(TaskType) onTabSelected;
  final TaskType selectedTaskType;

  const TaskTypeTabBar({
    Key? key,
    required this.onTabSelected,
    required this.selectedTaskType,
  }) : super(key: key);

  @override
  _TaskTypeTabBarState createState() => _TaskTypeTabBarState();
}

class _TaskTypeTabBarState extends State<TaskTypeTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: TaskType.values.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabSelected(TaskType.values[_tabController.index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TabBar(
          labelStyle:  GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
          unselectedLabelStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          indicator: BoxDecoration(
            color: ColorStrings.headingBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                spreadRadius: 1,
                offset: Offset(1, 1),
                blurRadius: 1,
                color: Colors.black12,
              ),
            ],
          ),
          labelColor: ColorStrings.whiteColor,
          unselectedLabelColor: ColorStrings.blackColor,
          controller: _tabController,
          indicatorColor: ColorStrings.whiteColor,
          tabs: TaskType.values.map((type) {
            String result = type.toString().split('.').last;
            String capitalized = result[0].toUpperCase() + result.substring(1);
            return Tab(
              text: capitalized
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
