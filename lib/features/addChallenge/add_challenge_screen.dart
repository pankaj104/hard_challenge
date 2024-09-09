import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/utils/app_utils.dart';
import 'package:hard_challenge/utils/colors.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/widgets/headingH1_widget.dart';
import 'package:hard_challenge/widgets/headingH2_widget.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../../service/notification_helper.dart';
import '../../widgets/date_picker_bottom_sheet.dart';
import '../../widgets/icon_button_widget.dart';
import 'package:bottom_picker/bottom_picker.dart';
import '../../widgets/notification/add_reminder_button.dart';
import '../../widgets/notification/notification_item.dart';
import '../../widgets/notification/time_picker_bottom_sheet.dart';


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
  TaskType _taskType = TaskType.normal;
  final RepeatType _repeatType = RepeatType.selectDays;
  Duration _timerDuration = const Duration(minutes: 1); // default 00:01:00
  int _taskValue = 5; // default value 5
  RepeatType _repeatSelectedItem = RepeatType.selectDays;

  DateTime? _startDate;
  DateTime? _endDate ;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Color selectedColor = Colors.orange;
  int selectedTimesPerWeek = 2;
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
      _startDate ?? DateTime.now(), // Pass the currently selected date or current date if null
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
        setState(() {
          _endDate = DateTime(newDate.year, newDate.month, newDate.day);
        });
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // title: const Text('Add Challenge'),
      ),
      body: Padding(
        padding:  const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButtonWidget(icon: ImageResource.closeIcon,
                        onPressed: (){
                      Navigator.pop(context);
            } ),

                    Expanded(
                      child: Center(
                        child: HeadingH2Widget("New Habit"),
                      ),
                    ),
                    SizedBox(
                      width: 42.w,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingH1Widget("Category"),
                    Padding(
                      padding:  const EdgeInsets.only( top: 4, bottom: 2,),
                      child: Container(
                        height: 65,
                        width: double.infinity,
                        // margin:EdgeInsets.only(left: 10, right: 10)
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: ColorStrings.headingBlue,
                          border: Border.all(width: 2,)
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                              Padding(
                                padding: const EdgeInsets.only(left: 7,top: 7,bottom: 5),
                                child: SizedBox(
                                  height:60.h,
                                  width: double.infinity,
                                  child: DropdownButtonFormField<String>(
                                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                    iconSize: 25,
                                    iconEnabledColor: ColorStrings.whiteColor,
                                    itemHeight: 50,
                                    dropdownColor: ColorStrings.headingBlue,
                                    value: _selectedCategory,
                                    items: categories
                                        .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category,style: const TextStyle(color: ColorStrings.whiteColor,
                                          fontSize: 15, fontWeight: FontWeight.w600), ),
                                    ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value!;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: ColorStrings.whiteColor,width: 2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:  const BorderSide(color: ColorStrings.whiteColor,width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 22, right: 8, top: 5, bottom: 5),
                              child: Container(
                                height: 40.h,
                                width: 43.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(width: 2,color: ColorStrings.whiteColor)
                                ),
                                child: IconButton(
                                  icon:  const Icon(Icons.add,color: ColorStrings.whiteColor,),
                                  onPressed: () => _addNewCategory(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                HeadingH1Widget("Habit Name"),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: ColorStrings.whiteColor,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(2.0, 6.0),
                              color: Colors.grey,
                              blurRadius: 6.0,
                              spreadRadius: 0.0
                          ),],
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _openColorPicker,
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: selectedColor
                              ),
                              child: Icon(iconSelected, color: Colors.black),
                            ),
                          ),

                          const SizedBox(width: 10,),


                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              decoration:  const InputDecoration(
                                  labelText: 'Habit Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a title';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _title = value!;
                              },
                            ),
                          ),
                        ],
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
                Align(
                  alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  const EdgeInsets.only(top: 14, bottom: 8),
                      child: HeadingH1Widget("Goal"),
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ColorStrings.headingBlue
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: TaskType.values.map((type) {
                        return Expanded(
                          child: SizedBox(
                            width: 300,
                            child: ChoiceChip(
                              backgroundColor: ColorStrings.whiteColor,
                              selectedColor: ColorStrings.headingBlue,
                              label: Text(type.toString().split('.').last,
                                selectionColor: ColorStrings.whiteColor,),
                              selected: _taskType == type,
                              onSelected: (selected) {
                                setState(() {
                                  _taskType = type;
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_taskType == TaskType.timer)
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(labelText: 'Timer Duration'),
                    onTap: () async {
                      Duration? picked = await showDurationPicker(
                        context: context,
                        initialDuration: _timerDuration,
                      );
                      if (picked != null) {
                        setState(() {
                          _timerDuration = picked;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: _timerDuration
                          .toString()
                          .split('.')
                          .first
                          .padLeft(8, '0'),
                    ),
                  ),
                if (_taskType == TaskType.value)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Task Value'),
                    keyboardType: TextInputType.number,
                    initialValue: _taskValue.toString(),
                    onSaved: (value) {
                      _taskValue = int.parse(value!);
                    },
                  ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  const EdgeInsets.only(top: 14, bottom: 8),
                      child: HeadingH1Widget("Repeat Type"),
                    )),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: ColorStrings.headingBlue,
                      border: Border.all(width: 2,),
                  ),
                  child: Padding(
                    padding:  const EdgeInsets.only(top: 3,left: 2, right: 2),
                    child: DropdownButtonFormField<RepeatType>(
                      value: _repeatSelectedItem,
                      dropdownColor: ColorStrings.headingBlue,
                      icon:  const Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 25,
                      iconEnabledColor: ColorStrings.whiteColor,
                      itemHeight: 50,
                      items: RepeatType.values.map((RepeatType item) {
                        return DropdownMenuItem<RepeatType>(
                          value: item,
                          child: Text(
                            item.toString().split('.').last,
                            style: const TextStyle(
                              color: ColorStrings.whiteColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (RepeatType? value) {
                        setState(() {
                          _repeatSelectedItem = value! ;
                          print(_repeatSelectedItem);
                        });
                      },
                      decoration: const InputDecoration(border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
                    ),),
                  ),),
                if (_repeatSelectedItem == RepeatType.selectDays)
                  Wrap(
                    children: [
                      {'M': 1},
                      {'Tu': 2},
                      {'W': 3},
                      {'Th': 4},
                      {'F': 5},
                      {'Sa': 6},
                      {'Su': 7}
                    ].map((dayMap) {
                      String day = dayMap.keys.first;
                      int dayValue = dayMap.values.first;
                      return ChoiceChip(
                        label: Text(day),
                        selected: selectedDays.contains(dayValue),
                        showCheckmark: false,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedDays.add(dayValue);
                              log('selectedDays value $selectedDays');
                            } else {
                              selectedDays.remove(dayValue);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                // if (_repeatSelectedItem == RepeatType.selectedDate)

                if (_repeatSelectedItem == RepeatType.weekly)
                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: _showWeeklyTimesPicker,
                        child:  Text('$selectedTimesPerWeek times'),
                      ),
                      ElevatedButton(
                        onPressed: _showWeeklyTimesPicker,
                        child:  const Text('Change'),
                      ),

                    ],
                  ),

                if (_repeatSelectedItem == RepeatType.monthly)
                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: _showMontlyimesPicker,
                        child:  Text('$selectedTimesPerMonth times'),
                      ),

                      ElevatedButton(
                        onPressed: _showMontlyimesPicker,
                        child:  const Text('Change'),
                      ),

                    ],
                  ),

                if (_repeatSelectedItem == RepeatType.selectedDate)
                  Column(
                    children: [
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) => selectedDates.contains(day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            if (selectedDates.contains(selectedDay)) {
                              selectedDates.remove(selectedDay);
                            } else {
                              selectedDates.add(selectedDay);
                            }
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                      ),
                    ],
                  ),
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

                                    ,   style: GoogleFonts.poppins(fontSize: 17,
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
                TextFormField(
                  controller: notecontroller,
                  decoration: const InputDecoration(
                    labelText: 'Enter your text here',
                    hintText: 'Type something...',
                  ),
                  onChanged: (value){
                    setState(() {
                      habitNote  = value.toString();
                    });
                  },
                ),
                SizedBox(height: 10,),

                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text('Add Habit'),
                    ),
                  ),
                ),
                SizedBox(height: 90,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Duration?> showDurationPicker(
      {required BuildContext context, required Duration initialDuration}) async {
    return showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        Duration tempDuration = initialDuration;
        return AlertDialog(
          title: const Text('Pick Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NumberPicker(
                minValue: 0,
                maxValue: 23,
                value: tempDuration.inHours,
                onChanged: (value) {
                  setState(() {
                    tempDuration =
                        Duration(hours: value, minutes: tempDuration.inMinutes % 60);
                  });
                },
              ),
              NumberPicker(
                minValue: 0,
                maxValue: 59,
                value: tempDuration.inMinutes % 60,
                onChanged: (value) {
                  setState(() {
                    tempDuration =
                        Duration(hours: tempDuration.inHours, minutes: value);
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(tempDuration);
              },
            ),
          ],
        );
      },
    );
  }

  void _addNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController newCategoryController =
        TextEditingController();
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: newCategoryController,
            decoration:
            const InputDecoration(hintText: 'Enter new category'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newCategory = newCategoryController.text;
                  if (newCategory.isNotEmpty &&
                      !categories.contains(newCategory)) {
                    categories.add(newCategory);
                    _selectedCategory = newCategory;
                  }
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),

            ),
          ],
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
        timer: _taskType == TaskType.timer ? _timerDuration : null,
        value: _taskType == TaskType.value ? _taskValue : null,
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
      Navigator.of(context).pop();
    }
  }

  void _showWeeklyTimesPicker() {
    BottomPicker(
      items: List.generate(6, (index) => Text((index + 1).toString())),
      // title: 'Select a number',
      onChange: (index) {
        setState(() {
          selectedTimesPerWeek = index + 1;
        });
      },

       pickerTitle: const Center(child: Text('Select Times per week')),
      selectedItemIndex: selectedTimesPerWeek-1,
    ).show(context);
  }

  void _showMontlyimesPicker() {
    BottomPicker(
      items: List.generate(28, (index) => Text((index + 1).toString())),
      // title: 'Select a number',
      onChange: (index) {
        setState(() {
          selectedTimesPerMonth = index + 1;
        });
      },

      pickerTitle: const Center(child: Text('Select Times per Month')),
      selectedItemIndex: selectedTimesPerMonth-1,
    ).show(context);
  }
}
