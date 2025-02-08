import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/app_utils.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/widgets/auto_fill_habit_popup.dart';
import 'package:path/path.dart';
import '../addChallenge/add_challenge_screen.dart';
import '../home_screen.dart';
import '../statistics/statistics_category_wise.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
   List<Widget> screens = [
    HomeScreen(),
     AutoFillHabitPopup(),
    StatisticsCategoryWise(habit: [],),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1), // x: 0, y: -1
              blurRadius: 10, // Blur
              spreadRadius: 0, // Spread// Shadow position (above the bottom nav bar)
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          child: BottomNavigationBar(
            // backgroundColor: Color(0xFFF9F9F9F0),
              elevation: 5,
              currentIndex: currentIndex,
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AutoFillHabitPopup()), // Navigate to new page
                  );
                } else {
                  setState(() {
                    currentIndex = index; // Update index for other tabs
                  });
                }
              },

              showSelectedLabels: false, // Hides the label for the selected item
              showUnselectedLabels: false,// Hides the label for the unselected item
              items:[
                BottomNavigationBarItem(icon:
                currentIndex == 0 ? SvgPicture.asset(ImageResource.clickedHomeIcon)
                    : SvgPicture.asset(ImageResource.unclickedHomeIcon),
                    label: ''),

                BottomNavigationBarItem(icon:
                currentIndex == 1 ? SvgPicture.asset(ImageResource.clickedAddIcon)
                    : SvgPicture.asset(ImageResource.unclickedAddIcon),
                    label: ''),

                BottomNavigationBarItem(icon:
                currentIndex == 2 ? SvgPicture.asset(ImageResource.clickedAnalyticsIcon)
                    : SvgPicture.asset(ImageResource.unclickedAnalyticsIcon),
                    label: ''),
              ]
          ),
        ),
      ),
    );
  }
}
