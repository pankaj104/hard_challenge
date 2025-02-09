import 'dart:developer';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
import 'package:uuid/uuid.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../../service/notification_helper.dart';
import '../../widgets/counter_widget.dart';
import '../../widgets/custom_category_list.dart';
import '../../widgets/date_picker_bottom_sheet.dart';
import '../../widgets/habit_custom_button.dart';
import '../../widgets/notification/add_reminder_button.dart';
import '../../widgets/notification/notification_item.dart';
import '../../widgets/notification/time_picker_bottom_sheet.dart';
import '../../widgets/task_type_tabbar.dart';
import '../../widgets/weekday_chip.dart';

class AddChallengeScreen extends StatefulWidget {
  final Habit? habit;
   bool isFromEdit = false;
   bool isFromFilledHabbit = false;
   AddChallengeScreen({super.key, this.habit, required this.isFromEdit , required this.isFromFilledHabbit});

  @override
  _AddChallengeScreenState createState() => _AddChallengeScreenState();
}
class _AddChallengeScreenState extends State<AddChallengeScreen> {

  final _formKey = GlobalKey<FormState>();
  DateTime today = DateTime.now();
  String _selectedCategory = defaultCategories[0];
  String _title = 'Test';
  TaskType _taskType = TaskType.task;
  HabitType _habitType = HabitType.build;
  final RepeatType _repeatType = RepeatType.selectDays;
  int _taskValue = 5; // default value 5
  RepeatType _repeatSelectedItem = RepeatType.selectDays;
  TextEditingController emojiController = TextEditingController();

  DateTime _startDate = setSelectedDate(DateTime.now());
  DateTime? _endDate ;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Color selectedColor = Colors.orange;
  int selectedTimesPerWeek = 1;
  int selectedTimesPerMonth = 1;
  final uuid = Uuid();
  String habitId = '';
  String emojiSelected = '💻';

  List<String> repeatItems = [
    RepeatType.selectDays.toString(),
    RepeatType.weekly.toString(),
    RepeatType.monthly.toString(),
    RepeatType.selectedDate.toString(),
  ];

  TextEditingController notecontroller = TextEditingController();
  final TextEditingController habitNameController = TextEditingController();

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

  List<String> categories = AppUtils.categories;


  @override
  void initState() {
    print('Habit ID 43: ${uuid.v4()}'); // Debugging the generated ID
    super.initState();
    habitId = uuid.v4();
    categories = AppUtils.categories;

    log('tttt categories $categories');

    if (widget.habit != null) {
      log('i am here');
       _selectedCategory = widget.habit?.category ?? 'General';
      habitNameController.text = widget.habit?.title ?? '';
      notecontroller.text = widget.habit?.notes ?? '';
      _taskType = widget.habit?.taskType ?? TaskType.count;
       _habitType= widget.habit?.habitType ?? HabitType.build;
       // _repeatType= widget.habit?.repeatType ?? RepeatType.selectDays;
       _repeatSelectedItem= widget.habit?.repeatType ?? RepeatType.selectDays;
       _taskValue= widget.habit?.value ?? 5;
       _startDate= widget.habit?.startDate ?? setSelectedDate(DateTime.now());
       _endDate= widget.habit?.endDate;
       selectedTimesPerMonth= widget.habit?.selectedTimesPerMonth ?? 1;
       selectedTimesPerWeek= widget.habit?.selectedTimesPerWeek ?? 1;
       selectedColor= widget.habit?.iconBgColor ?? Colors.orange;
       habitNote= widget.habit?.notes ?? '';
       _timerDuration= widget.habit?.timer ?? const Duration(minutes: 1);
       _formattedDuration= _formatDuration(widget.habit?.timer ?? const Duration(minutes: 1)) ;
       habitId = widget.habit?.id ?? habitId;
      emojiSelected = widget.habit?.habitEmoji ?? '😁';
    }
    focusNode = FocusNode();
  }

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
  // String selectedEmoji = '😀';
  void openPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateBottomSheet) {
            return SizedBox(
              height: 650,
              child: DefaultTabController(
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Row with Close Icon and Emoji Preview
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          ),
                          if (emojiSelected != null)
                            Text(
                              emojiSelected!,
                              style: TextStyle(fontSize: 28),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // TabBar with smaller width
                      SizedBox(
                        width: 200, // Limit TabBar width
                        child: TabBar(
                          labelColor: Colors.black,
                          indicatorColor: Theme.of(context).primaryColor,
                          tabs: [
                            Tab(text: 'Pick an Emoji'),
                            Tab(text: 'Pick a Color'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Pick an Emoji Tab
                            SizedBox(
                              height: 300, // Set a fixed height for the emoji picker
                              child: EmojiPicker(
                                textEditingController: emojiController,
                                onEmojiSelected: (category, emoji) {
                                  setState(() {
                                    emojiController.text += emoji.emoji;
                                    emojiSelected = emoji.emoji;
                                  });
                                },
                              ),
                            ),
                            // Pick a Color Tab
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: ColorPicker(
                                    pickerColor: selectedColor,
                                    onColorChanged: (Color color) {
                                      setState(() {
                                        selectedColor = color;
                                      });
                                    },
                                    showLabel: true,
                                    pickerAreaHeightPercent: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEmojiKeyboard(BuildContext context) {
    TextEditingController emojiController = TextEditingController();
    FocusScope.of(context).requestFocus(FocusNode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                // Emoji picker
                EmojiPicker(
                  textEditingController: emojiController,
                  onEmojiSelected: (category, emoji) {
                    emojiController.text += emoji.emoji;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
          child: SingleChildScrollView(
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
  void dispose() {
    focusNode?.dispose();
    notecontroller.dispose();
    habitNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 0,
        title: widget.isFromEdit ? HeadingH2Widget("Edit"): HeadingH2Widget("New Habit") ,
      ),
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Center(
                //   child: widget.isFromEdit ? HeadingH2Widget("Edit"): HeadingH2Widget("New Habit") ,
                // ),
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
                                _selectedCategory!,
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
                          onTap: (){
                            openPickerBottomSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: selectedColor, // Background color for the icon
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8)
                            ),

                            child: Center(child: Text(emojiSelected, style: TextStyle(fontSize: 18),)),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,  // Aligns text to the left
                            width: 250,
                            child: TextFormField(
                              focusNode: focusNode,
                              controller: habitNameController,
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
                //
                // HeadingH1Widget("Reminder"),
                //
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     ...selectedTime.map((time) {
                //       int index = selectedTime.indexOf(time);
                //       return GestureDetector(
                //         onTap: () {
                //           // Open the time picker with the currently selected time for editing
                //           CustomTimePickerBottomSheet.showTimePicker(context, (newTime) {
                //             _editReminder(index, newTime);
                //           });
                //         },
                //         child: NotificationItem(
                //           time: time,
                //           onRemove: () => _removeReminder(index),
                //         ),
                //       );
                //     }).toList(),
                //     AddReminderButton(
                //       onAdd: () {
                //         CustomTimePickerBottomSheet.showTimePicker(context, (selectedTime) {
                //           _addReminder(selectedTime);
                //         });
                //       },
                //     ),
                //   ],
                // ),

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
                    padding: const EdgeInsets.only(right: 2, left: 2, top: 10),
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

                HeadingH1Widget("Frequency"),

                /// to be later
                // Padding(
                //   padding: const EdgeInsets.only(top: 4, bottom: 2, right: 5, left: 5),
                //   child: GestureDetector(
                //     onTap: _showRepeatType, // Open bottom sheet on tap
                //     child: Container(
                //       height: 45,
                //       padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(15.0),
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.1),
                //             blurRadius: 8.0,
                //             spreadRadius: 2.0,
                //             offset: const Offset(0, 4),
                //           ),
                //         ],
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 7, top: 7, bottom: 5),
                //         child: SizedBox(
                //           height: 50.h,
                //           width: double.infinity,
                //           child: Container(
                //             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Text(
                //                   _repeatSelectedItem.name,
                //                   style: GoogleFonts.poppins(
                //                     fontSize: 16.0,
                //                     fontWeight: FontWeight.w400,
                //                   ),
                //                 ),
                //                 const Icon(Icons.keyboard_arrow_down_rounded, size: 25),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),


                // SizedBox(height: 10,),
                if (_repeatSelectedItem == RepeatType.selectDays)
                  Center(
                    child: Wrap(
                      spacing: 0.0,
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
                              height: 25,
                              width: 25,
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
                                      fontSize: 12,
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
                      padding: const EdgeInsets.only(top: 1, bottom: 1),
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
                  child: HabitCustomButton(buttonText: widget.isFromEdit == true ? 'Update Habit' : 'Add Habit', onTap: _submitForm, color: ColorStrings.headingBlue, widthOfButton: 180, buttonTextColor: Colors.white,)
                ),
                const SizedBox(height: 30),
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
                          // Save categories in Hive
                          // var box = Hive.box<String>('categoriesBox');
                          // box.put(newCategory, newCategory); // Use key-value pairs
                          AppUtils.addCategory(newCategory); // Save to Hive
                          log('category with added list $newCategory');

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
      if (_endDate == null) {
        showFlushBarHelper(
          context,
          message: "Please add end date",
        );
        return;  // Exit the method early
      }
      final newHabit = Habit(
        id: habitId!,
        title: _title!,
        category: _selectedCategory!,
        habitEmoji: emojiSelected,
        iconBgColor: selectedColor,
        notificationTime: selectedTime,
        taskType: _taskType,
        repeatType: _repeatSelectedItem,
        habitType: _habitType,
        timer: _taskType == TaskType.time ? _timerDuration : null,
        value: _taskType == TaskType.count ? _taskValue : null,
        progressJson: {},
        days: _repeatSelectedItem == RepeatType.selectDays ? selectedDays : null,
        startDate: _startDate,
        endDate: _endDate,
        selectedDates: _repeatSelectedItem == RepeatType.selectedDate ? selectedDates : null,
        selectedTimesPerWeek: _repeatSelectedItem == RepeatType.weekly ? selectedTimesPerWeek : null,
        selectedTimesPerMonth: _repeatSelectedItem == RepeatType.monthly ? selectedTimesPerMonth : null,
        notes: habitNote,
      );

      log('${widget.habit != null ? "Updated" : "New"} habit added: $newHabit');

      // Use addHabit for new habits, updateHabit for existing habits
      if (widget.isFromEdit == true) {
        Provider.of<HabitProvider>(context, listen: false).updateHabit(newHabit);
      }
      else if (widget.isFromFilledHabbit == true) {
        Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      }
      else {
        Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  static String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
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
