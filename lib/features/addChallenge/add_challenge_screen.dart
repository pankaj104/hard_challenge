import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/features/mainScreen/main_screen.dart';
import 'package:hard_challenge/utils/app_utils.dart';
import 'package:hard_challenge/utils/colors.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/widgets/custom_time_duration_picker.dart';
import 'package:hard_challenge/widgets/habit_type.dart';
import 'package:hard_challenge/widgets/headingH1_widget.dart';
import 'package:hard_challenge/widgets/headingH2_widget.dart';
import 'package:hard_challenge/widgets/label_changer.dart';
import 'package:hard_challenge/widgets/number_picker.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../../service/notification_helper.dart';
import '../../widgets/counter_widget.dart';
import '../../widgets/custom_category_list.dart';
import '../../widgets/date_picker_bottom_sheet.dart';
import '../../widgets/habit_custom_button.dart';
import '../../widgets/icon_button_widget.dart';
import '../../widgets/notification/add_reminder_button.dart';
import '../../widgets/notification/notification_item.dart';
import '../../widgets/notification/time_picker_bottom_sheet.dart';
import '../../widgets/task_type_tabbar.dart';
import '../../widgets/weekday_chip.dart';

class AddChallengeScreen extends StatefulWidget {
  const AddChallengeScreen({super.key});

  @override
  _AddChallengeScreenState createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {

  final _formKey = GlobalKey<FormState>();
  DateTime today = DateTime.now();
  String _selectedCategory = 'General';
  String _title = 'Test';
  TaskType _taskType = TaskType.task;
  HabitType _habitType = HabitType.build;
  final RepeatType _repeatType = RepeatType.selectDays;
  int _taskValue = 5; // default value 5
  RepeatType _repeatSelectedItem = RepeatType.selectDays;

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime? _endDate ;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Color selectedColor = Colors.orange;
  int selectedTimesPerWeek = 1;
  int selectedTimesPerMonth = 1;

  List<String> repeatItems = [
    RepeatType.selectDays.toString(),
    RepeatType.weekly.toString(),
    RepeatType.monthly.toString(),
    RepeatType.selectedDate.toString(),
  ];

  TextEditingController notecontroller = TextEditingController();
  String? habitNote ;

  List<String> selectedTime = [];
  final daysOfWeek = [
    {'S': 7},
    {'M': 1},
    {'T': 2},
    {'W': 3},
    {'T': 4},
    {'F': 5},
    {'S': 6},
  ];


  void _addReminder(String time) {
    setState(() {
      selectedTime.add(time);
      _scheduleNotification(time);
    });
  }

  void _removeReminder(int index) {
    setState(() {
      selectedTime.removeAt(index);
    });
  }

  void _editReminder(int index, String newTime) {
    setState(() {
      selectedTime[index] = newTime;
    });
  }
  // Format the selected date to display
  String _formatSelectedDate(DateTime date) {
    return DateFormat('d MMM y').format(date);
  }

// Function to open the date picker bottom sheet and update selected date
  void _pickStartDate() {
    CustomDatePickerBottomSheet.showDatePicker(
      context,
      _startDate ?? DateTime.now(), // Use current date if _startDate is null
          (String formattedDate, DateTime newDate) {
        setState(() {
          _startDate = DateTime(newDate.year, newDate.month, newDate.day);
          print('start date $_startDate');
        });
      },
    );
  }

  // Function to open the date picker bottom sheet and update selected date
  void _pickEndDate() {
    CustomDatePickerBottomSheet.showDatePicker(
      context,
      _endDate ?? DateTime.now(), // Pass the currently selected date or current date if null
          (String formattedDate, DateTime newDate) {
        if (newDate.isBefore(_startDate)) {

          WidgetsBinding.instance.addPostFrameCallback((_) {
            showFlushBarHelper(
              context,
              message: "End date cannot be before the start date.",
            );
          });

        } else {
          setState(() {
            _endDate = DateTime(newDate.year, newDate.month, newDate.day);
          });
        }
      },
    );
  }

// Function to parse the time string and schedule a notification
  void _scheduleNotification(String timeString) {
    try {
      // Trim the string to avoid any leading/trailing whitespace issues
      timeString = timeString.trim();

      DateFormat format = DateFormat('h:mm a');
      DateTime parsedTime = format.parse(timeString);

      // Assuming you're scheduling a notification for this time today
      DateTime scheduledTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        parsedTime.hour,
        parsedTime.minute,
      );

      // Schedule the notification (replace with your logic)
      NotificationHelper.scheduleNotification(0, 'Reminder', 'It\'s time!', scheduledTime);
    } catch (e) {
      print("Error parsing time: $e");
    }
  }

  DateTime selectedDate = DateTime.now();


  void _onTabSelected(TaskType type) {
    setState(() {
      _taskType = type;
    });
  }

  void _onHabitTypeSelected(HabitType type) {
    setState(() {
      _habitType = type;
    });
  }

  IconData iconSelected = FontAwesomeIcons.iceCream;
  void _openColorPicker() async {
    Color? pickedColor = await showDialog(
      context: context,
      builder: (context) {
        Color tempSelectedColor = selectedColor;
        IconData selectedIcon = iconSelected;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pick a color and icon'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      IconData? newIcon = await showIconPicker(
                          context,
                          iconPackModes: [IconPack.fontAwesomeIcons]
                      );

                      if (newIcon != null) {
                        setState(() {
                          selectedIcon = newIcon;
                          iconSelected = newIcon;
                        });
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: tempSelectedColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: Icon(selectedIcon, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: predefinedColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            tempSelectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: tempSelectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          tempSelectedColor = color;
                        });
                      },
                      showLabel: false,
                      enableAlpha: false,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Select'),
                  onPressed: () {
                    Navigator.of(context).pop(tempSelectedColor);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        selectedColor = pickedColor;
      });
    }
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  IconButton(icon: Icon(Icons.close), onPressed: (){
                    Navigator.pop(context);
                  },),

                  const SizedBox(width: 30,),

                  Center(
                    child: Text(
                      'Select Habit Category',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                      Navigator.pop(context);
                    },
                    child: CustomCategoryList(
                      categoryText: category,
                      isSelected: _selectedCategory == category, // Check if it's selected
                    ),
                  );
                }).toList(),
              ),

            ],
          ),
        );
      },
    );
  }

  void _showRepeatType() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  IconButton(icon: Icon(Icons.close), onPressed: (){
                    Navigator.pop(context);
                  },),

                  const SizedBox(width: 30,),

                  Center(
                    child: Text(
                      'Select Repeat Type',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: RepeatType.values.map((RepeatType item) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _repeatSelectedItem = item;
                      });
                      Navigator.pop(context);
                    },
                    child: CustomCategoryList(
                      categoryText: item.name.toString(),
                      isSelected: _repeatSelectedItem == item, // Check if it's selected
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _label = 'Times';
  List<int> daysInMonth = List.generate(31, (index) => index + 1); // Days from 1 to 31

  final List<DateTime> selectedDates = [];

  void toggleDateSelection(int day) {
    DateTime selectedDay = DateTime(today.year, today.month, day);

    if (selectedDates.contains(selectedDay)) {
      setState(() {
        selectedDates.remove(selectedDay);
      });
    } else {
      setState(() {
        selectedDates.add(selectedDay);
      });
    }
  }

  void _changeLabel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (_) => LabelChanger(
        initialLabel: _label,
        onLabelChanged: (newLabel) {
          setState(() {
            _label = newLabel;
          });
        },
      ),
    );
  }

  String _formattedDuration = '00:01:00'; // Default formatted duration
  Duration _timerDuration = const Duration(minutes: 1); // default 00:01:00
  FocusNode? focusNode;

  // Function to handle changing the duration
  void _changeDuration(BuildContext context) {
    CustomTimeDurationPickerBottomSheet.showTimePicker(
      context,
      _timerDuration,
          (String formattedDuration, Duration newDuration) {
        setState(() {
          _formattedDuration = formattedDuration;
          _timerDuration = newDuration;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // title: const Text('Add Challenge'),
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
        child: Form(
          key: _formKey,
          child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: HeadingH2Widget("New Habit"),
                ),
            //     Row(
            //       children: [
            // //         IconButtonWidget(icon: ImageResource.closeIcon,
            // //             onPressed: (){
            // //           // Navigator.pop(context);
            // //               Navigator.push(
            // //                   context,
            // //                   MaterialPageRoute(builder: (context) => MainScreen())
            // //               );
            // // } ),
            //
            //         Expanded(
            //           child: Center(
            //             child: HeadingH2Widget("New Habit"),
            //           ),
            //         ),
            //         SizedBox(
            //           width: 42.w,
            //         ),
            //       ],
            //     ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// category add area
                    HeadingH1Widget("Category"),

          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 2, right: 5, left: 5),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showCategorySelector, // Open bottom sheet on tap
                  child: Container(
                    height: 45,
                    width: .70.sw,
                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, top: 7, bottom: 5),
                      child: SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedCategory,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded, size: 25),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                GestureDetector(
                  onTap: () => _addNewCategory(context),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200, // Background color for the icon
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ],
                ),
                HeadingH1Widget("Habit Name"),

                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 3),
                  child: Container(
                    // width: 328.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                          offset: const Offset(2, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: _openColorPicker,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                color: selectedColor, // Background color for the icon
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8)
                            ),

                            child: Icon(iconSelected, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,  // Aligns text to the left
                            width: 250,
                            child: TextFormField(
                              focusNode: focusNode,
                              decoration:   InputDecoration(
                                hintText: 'Habit Name',
                                border: InputBorder.none,  // Removes the default underline
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    showFlushBarHelper(
                                      context,
                                      message: "Please Enter Habit name",
                                    );

                                    FocusScope.of(context).requestFocus(focusNode);
                                  });
                                  return 'Please Enter Habit name';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _title = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                HeadingH1Widget("Reminder"),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...selectedTime.map((time) {
                      int index = selectedTime.indexOf(time);
                      return GestureDetector(
                        onTap: () {
                          // Open the time picker with the currently selected time for editing
                          CustomTimePickerBottomSheet.showTimePicker(context, (newTime) {
                            _editReminder(index, newTime);
                          });
                        },
                        child: NotificationItem(
                          time: time,
                          onRemove: () => _removeReminder(index),
                        ),
                      );
                    }).toList(),
                    AddReminderButton(
                      onAdd: () {
                        CustomTimePickerBottomSheet.showTimePicker(context, (selectedTime) {
                          _addReminder(selectedTime);
                        });
                      },
                    ),
                  ],
                ),

                HeadingH1Widget("Goal"),

                TaskTypeTabBar(
                  onTabSelected: _onTabSelected,
                  selectedTaskType: _taskType,
                ),
                if (_taskType == TaskType.time)
        Padding(
          padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display Duration Button
            GestureDetector(
            onTap: () => _changeDuration(context), // On tap, open the duration picker
              child: Container(
                width: 120.w,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF1A3D89), // Blue color to match the design
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _formattedDuration,
                    style: GoogleFonts.poppins(fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16), // Space between the two buttons

            // Change Button
            GestureDetector(
              onTap: () => _changeDuration(context), // On tap, open the duration picker
              child: Container(
                width: 120.w,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF1A3D89), // Blue color to match the design
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Change',
                    style: GoogleFonts.poppins(fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,),
                  ),
                ),
              ),
            ),
          ],
                ),
        ),


                if (_taskType == TaskType.count)

                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 10),
                    child: Row(
                      children: [
                        CounterWidget(
                          initialValue: _taskValue,
                          onValueChanged: (newValue) {
                            setState(() {
                              _taskValue = newValue;
                              log('task value  $_taskValue');
                            });
                          },
                        ),
                        SizedBox(width: 45),
                        GestureDetector(
                          onTap: _changeLabel,
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              color: ColorStrings.headingBlue,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  spreadRadius: 1,
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                                child: Text(
                                  _label,
                                  style: GoogleFonts.poppins(fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                HeadingH1Widget("Repeat Type"),

                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2, right: 5, left: 5),
                  child: GestureDetector(
                    onTap: _showRepeatType, // Open bottom sheet on tap
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7, top: 7, bottom: 5),
                        child: SizedBox(
                          height: 50.h,
                          width: double.infinity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _repeatSelectedItem.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded, size: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 20,),
                if (_repeatSelectedItem == RepeatType.selectDays)
                  Wrap(
                    spacing: 6.0,
                    children: daysOfWeek.map((dayMap) {
                      String day = dayMap.keys.first;
                      int dayValue = dayMap.values.first;

                      return WeekdayChip(
                        day: day,
                        dayValue: dayValue,
                        isSelected: selectedDays.contains(dayValue),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedDays.add(dayValue);
                            } else {
                              selectedDays.remove(dayValue);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                if (_repeatSelectedItem == RepeatType.weekly)

                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display Duration Button
                        GestureDetector(
                          onTap: () {

                            CustomNumberPickerBottomSheet.showNumberPicker(
                              context,
                              selectedTimesPerWeek,
                              6,
                              'Set Times per Week',
                                  (int selectedNumber) {
                                setState(() {
                                  selectedTimesPerWeek = selectedNumber; // Update the current value
                                });
                              },
                            );
                          },
                          child: Container(
                            width: 120.w,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A3D89), // Blue color to match the design
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                            '$selectedTimesPerWeek Times',
                                style: GoogleFonts.poppins(fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Space between the two buttons

                        // Change Button
                        GestureDetector(
                          // onTap: () => _showWeeklyTimesPicker, // On tap, open the duration picker
                          onTap: () {

                            CustomNumberPickerBottomSheet.showNumberPicker(
                              context,
                              selectedTimesPerWeek,
                              6,
                              'Set Times per Week',
                                  (int selectedNumber) {
                                setState(() {
                                  selectedTimesPerWeek = selectedNumber; // Update the current value
                                });
                              },
                            );
                          },
                          child: Container(
                            width: 120.w,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A3D89), // Blue color to match the design
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Change',
                                style: GoogleFonts.poppins(fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_repeatSelectedItem == RepeatType.monthly)
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display Duration Button
                        GestureDetector(
                          onTap: () {
                            CustomNumberPickerBottomSheet.showNumberPicker(
                              context,
                              selectedTimesPerMonth,
                              28,
                              'Set Times per Month',
                                  (int selectedNumber) {
                                setState(() {
                                  selectedTimesPerMonth = selectedNumber; // Update the current value
                                });
                              },
                            );
                          },
                          child: Container(
                            width: 120.w,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A3D89), // Blue color to match the design
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '$selectedTimesPerMonth Times',
                                style: GoogleFonts.poppins(fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Space between the two buttons

                        // Change Button
                        GestureDetector(
                          onTap: () {
                            CustomNumberPickerBottomSheet.showNumberPicker(
                              context,
                              selectedTimesPerMonth,
                              28,
                              'Set Times per Month',
                                  (int selectedNumber) {
                                setState(() {
                                  selectedTimesPerMonth = selectedNumber; // Update the current value
                                });
                              },
                            );
                          },
                          child: Container(
                            width: 120.w,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF1A3D89), // Blue color to match the design
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Change',
                                style: GoogleFonts.poppins(fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_repeatSelectedItem == RepeatType.selectedDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: 280,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7, // 7 days in a week
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: daysInMonth.length,
                        itemBuilder: (context, index) {
                          int day = daysInMonth[index];
                          DateTime date = DateTime(today.year, today.month, day);
                          bool isSelected = selectedDates.contains(date);

                          return GestureDetector(
                            onTap: () => toggleDateSelection(day),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: isSelected? BoxDecoration(
                                color: Color(0xff079455),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow:  [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],

                              ):
                              BoxDecoration(
                                color:  Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow:  [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8.0,
                                    spreadRadius: 2.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  child: Text(
                                    day.toString(),
                                    style: GoogleFonts.poppins(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                HeadingH1Widget("Habit Type"),

                HabitTypeTabBar(onHabitTypeSelected: _onHabitTypeSelected,selectedHabitType : _habitType,),

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 26,
                          width: double.infinity,
                          child: HeadingH1Widget("Schedule"),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            HeadingH1Widget("Start"),
                            GestureDetector(
                              onTap: _pickStartDate,
                              child: Container(
                                width: 140,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: ColorStrings.headingBlue
                                ),
                                child: Center(
                                  child: Text(_startDate != null ? _formatSelectedDate(_startDate!)
                                      : _formatSelectedDate(DateTime.now())
                                    ,   style: GoogleFonts.poppins(fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,),),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding:  const EdgeInsets.only(top: 16),
                            child: SizedBox(
                              width: 32,
                              child: SvgPicture.asset(ImageResource.shuffleIcon),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            HeadingH1Widget("End"),
                            GestureDetector(
                              onTap: _pickEndDate,
                              child: Container(
                                width: 140,
                                height: 52,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: ColorStrings.headingBlue
                                ),
                                child: Center(
                                  child: Text(_endDate != null ? _formatSelectedDate(_endDate!)
                                      : 'Select'
                                    ,style: GoogleFonts.poppins(fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                HeadingH1Widget("Notes"),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6.0,
                          spreadRadius: 0.0,
                          offset: const Offset(2, 6),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: notecontroller,
                      minLines: 1,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: 'Add helpful note',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.cyan,
                        ),
                        // border: const OutlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color:Colors.black12,
                        //   ),
                        //   borderRadius: BorderRadius.all(
                        //     Radius.circular(8),
                        //   ),
                        // ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                      ),

                      onChanged: (value){
                        setState(() {
                          habitNote  = value.toString();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40,),
                Center(
                  child: HabitCustomButton(buttonText: 'Add Habit', onTap: _submitForm, color: ColorStrings.headingBlue, widthOfButton: double.infinity, buttonTextColor: Colors.white,)
                ),
                const SizedBox(height: 90,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController newCategoryController =
        TextEditingController();
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text(
                    'Habit New Category',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                    textScaler: TextScaler.noScaling
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: newCategoryController,
                  decoration: InputDecoration(
                    hintText: 'Enter new category',
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.black26.withOpacity(0.2),
                        width: .4,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HabitCustomButton(buttonText: 'Cancel', onTap: () {
                      Navigator.of(context).pop();
                    }, color: Colors.white, widthOfButton: 100, buttonTextColor: Colors.black,),
                    HabitCustomButton(buttonText: 'Add', onTap: () {
                      setState(() {
                        String newCategory = newCategoryController.text;
                        if (newCategory.isNotEmpty &&
                            !categories.contains(newCategory)) {
                          categories.add(newCategory);
                          _selectedCategory = newCategory;
                        }
                      });
                      Navigator.of(context).pop();
                    }, color: const Color(0xff7e94e5), widthOfButton: 100, buttonTextColor:  Colors.black,),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );

      },
    );
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newHabit = Habit(
        title: _title,
        category: _selectedCategory,
        habitIcon: iconSelected,
        iconBgColor: selectedColor,
        notificationTime: selectedTime,
        taskType: _taskType,
        repeatType: _repeatType,
        habitType: _habitType,
        timer: _taskType == TaskType.time ? _timerDuration : null,
        value: _taskType == TaskType.count ? _taskValue : null,
        progressJson: {},
        days: _repeatType == RepeatType.selectDays ? selectedDays : null,
        startDate: _startDate,
        endDate: _endDate,
        selectedDates: _repeatType == RepeatType.selectedDate ? selectedDates : null,
        selectedTimesPerWeek: _repeatType == RepeatType.weekly ? selectedTimesPerWeek : null,
        selectedTimesPerMonth: _repeatType == RepeatType.monthly ? selectedTimesPerMonth : null,
        notes: habitNote
      );
      log('New habbit added Data $newHabit');
      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      // saveHabit(newHabit);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen())
      );
    }
  }


  // void saveHabit(Habit habit) async {
  //   var box = await Hive.openBox<Habit>('habitBox');
  //   await box.add(habit);
  //   await getHabit(1);
  // }
  //
  // Future<Habit?> getHabit(int index) async {
  //   var box = await Hive.openBox<Habit>('habitBox');
  //   Habit? habit = box.get(index);
  //
  //   // If habit is not null, print its details
  //   if (habit != null) {
  //     log('test hii');
  //     print('Habit Title: ${habit.title}');
  //     print('Habit Category: ${habit.category}');
  //     print('Habit Type: ${habit.habitType}');
  //     print('Task Type: ${habit.taskType}');
  //     print('Repeat Type: ${habit.repeatType}');
  //     print('Start Date: ${habit.startDate}');
  //     print('End Date: ${habit.endDate ?? 'N/A'}');
  //     print('Progress: ${habit.progressJson}');
  //     print('Notification Times: ${habit.notificationTime}');
  //     print('Notes: ${habit.notes ?? 'N/A'}');
  //   } else {
  //     print('No Habit found at index: $index');
  //   }
  //
  //   return habit;
  // }

}
