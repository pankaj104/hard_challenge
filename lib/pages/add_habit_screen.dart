import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/routers/app_routes.gr.dart';
import 'package:hard_challenge/utils/constant.dart';
import 'package:hard_challenge/widgets/headingH2_widget.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {

  @override
  Widget build(BuildContext context) {
    Map<String, List<Habit>> categorizedHabits = {};
    for (var habit in preRecorededHabitList) {
      categorizedHabits.putIfAbsent(habit.category, () => []).add(habit);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.router.push(
                    const PageRouteInfo<dynamic>(
                      'AddChallengeScreen',
                      path: '/add-challenge-screen',
                      args: AddChallengeScreenArgs(
                        isFromEdit: false,
                        isFromFilledHabbit: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 35,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:  Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text( 'Custom Habit',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,),
                  ),
                      SizedBox(width: 10,),

                      Text(
                         '🖋️',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
                ),
              ),
              Expanded(
                child: categorizedHabits.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  padding: const EdgeInsets.only(top: 1),
                  children: categorizedHabits.entries.map((entry) {
                    log('test ${entry.key}');
                    return ExpansionTile(
                      initiallyExpanded: true,
                      // entry.key == 'Sport' ? true : false,
                      tilePadding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide.none,
                      ),
                      collapsedShape: const RoundedRectangleBorder(
                        side: BorderSide.none,
                      ),
                      title: Text(
                        entry.key,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      children: entry.value.map((habit) => Container(
                          color: Colors.white,
                          child: _buildListTile(habit))).toList(),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(Habit habit) {
    return
      Container(
        // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 5,
          //     spreadRadius: 2,
          //     offset: const Offset(0, 2),
          //   ),
          // ],
        ),
        child: InkWell(
          onTap: () {
            context.router.push(
              PageRouteInfo<dynamic>(
                'AddChallengeScreen',
                path: '/add-challenge-screen',
                args: AddChallengeScreenArgs(
                  isFromEdit: false,
                  isFromFilledHabbit: true,
                  habit: habit,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      habit.habitEmoji ?? '❓',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        habit.title ?? 'Unknown Habit',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.2), // Change color as needed
                    thickness: 1, // Adjust thickness
                    indent: 10, // Optional: Adds space from left
                    endIndent: 10, // Optional: Adds space from right
                  ),
                ),

              ],
            ),
          ),
        ),
      );

  }
}
