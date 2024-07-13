import 'dart:developer';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/utils/app_utils.dart';
import 'package:hard_challenge/utils/colors.dart';
import 'package:hard_challenge/utils/image_resource.dart';
import 'package:hard_challenge/widgets/container_label.dart';
import 'package:hard_challenge/widgets/headingH1_widget.dart';
import 'package:hard_challenge/widgets/headingH2_widget.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../model/habit_model.dart';
import '../../provider/habit_provider.dart';
import '../../widgets/icon_button_widget.dart';

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
  TimeOfDay _selectedTime = TimeOfDay.now();
  TaskType _taskType = TaskType.normal;
  RepeatType _repeatType = RepeatType.selectDays;
  Duration _timerDuration = const Duration(minutes: 1); // default 00:01:00
  int _taskValue = 5; // default value 5

  DateTime? _startDate;
  DateTime? _endDate ;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Color selectedColor = Colors.orange;

  int selectedTimesPerWeek = 2;
  int selectedTimesPerMonth = 1;


  IconData icon_selected = FontAwesomeIcons.glassMartiniAlt;
  void _openColorPicker() async {
    Color? pickedColor = await showDialog(
      context: context,
      builder: (context) {
        Color tempSelectedColor = selectedColor;
        IconData selectedIcon = icon_selected;

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
                          icon_selected = newIcon;
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
        padding:  EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child:
          SingleChildScrollView(
            child: Column(
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
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:  EdgeInsets.only(top: 14, bottom: 2),
                        child: Container(
                          height: 26,
                          width: double.infinity,
                          child: HeadingH1Widget("Category"),
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only( top: 4, bottom: 2,),
                      child: Container(
                        height: 70,
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
                              Container(
                                height:58,
                                width: 249,
                                child: DropdownButtonFormField<String>(
                                  itemHeight: 80,
                                  padding: EdgeInsets.zero,
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
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: ColorStrings.whiteColor,width: 2),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:  BorderSide(color: ColorStrings.whiteColor,width: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40),
                              child: Container(
                                height: 58.h,
                                width: 53.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(width: 2,color: ColorStrings.whiteColor)
                                ),
                                child: IconButton(
                                  icon:  Icon(Icons.add,color: ColorStrings.whiteColor,),
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
                SizedBox(height: 8,),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding:  EdgeInsets.only(top: 14, bottom: 2),
                        child: Container(
                          height: 26,
                          width: double.infinity,
                          child: HeadingH1Widget("Habit Name"),
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only( top: 4, bottom: 6,),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        // margin:EdgeInsets.only(left: 10, right: 10)
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: ColorStrings.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(2.0, 6.0),
                                color: Colors.grey,
                                blurRadius: 6.0,
                                spreadRadius: 0.0
                              ),],
                        ),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              height: 40.h,
                              width: 40.w,
                              child: Center(child: Text("💧")),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: ColorStrings.havelockBlue
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(left: 8),
                                child: ContainerLabelWidget("Water"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8,),
                //Goal Column is commented
                // Column(
                //   children: [
                //     Align(
                //       alignment: Alignment.centerLeft,
                //       child: Padding(
                //         padding:  EdgeInsets.only(top: 14,bottom:4),
                //         child: Container(
                //           height: 26,
                //           width: 41,
                //           child: HeadingH1Widget("Goal"),
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding:  EdgeInsets.only( bottom: 6,),
                //       child: Container(
                //         height: 60,
                //         width: 400,
                //         // margin:EdgeInsets.only(left: 10, right: 10)
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(16),
                //           color: ColorStrings.headingBlue,
                //         ),
                //         child:
                //         Row(
                //           children: [
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //               children: TaskType.values.map((type) {
                //                 return ChoiceChip(
                //                   label: Text(type.toString().split('.').last),
                //                   selected: _taskType == type,
                //                   onSelected: (selected) {
                //                     setState(() {
                //                       _taskType = type;
                //                     });
                //                   },
                //                 );
                //               }).toList(),
                //             ),
                //             if (_taskType == TaskType.timer)
                //               TextFormField(
                //                 readOnly: true,
                //                 decoration: const InputDecoration(
                //                     labelText: 'Timer Duration'),
                //                 onTap: () async {
                //                   Duration? picked = await showDurationPicker(
                //                     context: context,
                //                     initialDuration: _timerDuration,
                //                   );
                //                   if (picked != null) {
                //                     setState(() {
                //                       _timerDuration = picked;
                //                     });
                //                   }
                //                 },
                //                 controller: TextEditingController(
                //                   text: _timerDuration
                //                       .toString()
                //                       .split('.')
                //                       .first
                //                       .padLeft(8, '0'),
                //                 ),
                //               ),
                //             if (_taskType == TaskType.value)
                //               TextFormField(
                //                 decoration: const InputDecoration(labelText: 'Task Value'),
                //                 keyboardType: TextInputType.number,
                //                 initialValue: _taskValue.toString(),
                //                 onSaved: (value) {
                //                   _taskValue = int.parse(value!);
                //                 },
                //               ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                
                //Pankaj's code
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _openColorPicker,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selectedColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                            child: Icon(icon_selected, color: Colors.black),
                          ),
                        ),

                        SizedBox(width: 10,),


                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            decoration:  InputDecoration(
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

                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Notification Time'),
                  onTap: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _selectedTime.format(context),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top: 14, bottom: 4),
                      child: ContainerLabelWidget("Goal"),
                    )),
                Container(
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
                      padding:  EdgeInsets.only(top: 14, bottom: 4),
                      child: ContainerLabelWidget("Repeat Type"),
                    )),
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: ColorStrings.headingBlue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: RepeatType.values.map((type) {
                      return ChoiceChip(
                        backgroundColor: ColorStrings.whiteColor,
                        selectedColor: ColorStrings.headingBlue,
                        label: Text(type.toString().split('.').last,
                          selectionColor: ColorStrings.whiteColor,),
                        selected: _repeatType == type,
                        onSelected: (selected) {
                          setState(() {
                            _repeatType = type;
                            if (type == RepeatType.selectedDate) {
                              selectedDates.clear();
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (_repeatType == RepeatType.selectDays)
                  Wrap(
                    children: [
                      {'M': 1},
                      {'T': 2},
                      {'W': 3},
                      {'T': 4},
                      {'F': 5},
                      {'S': 6},
                      {'S': 7}
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

                if (_repeatType == RepeatType.weekly)
                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: _showWeeklyTimesPicker,
                        child:  Text('$selectedTimesPerWeek times'),
                      ),
                      ElevatedButton(
                        onPressed: _showWeeklyTimesPicker,
                        child:  Text('Change'),
                      ),

                    ],
                  ),

                if (_repeatType == RepeatType.monthly)
                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: _showMontlyimesPicker,
                        child:  Text('$selectedTimesPerMonth times'),
                      ),

                      ElevatedButton(
                        onPressed: _showMontlyimesPicker,
                        child:  Text('Change'),
                      ),

                    ],
                  ),

                if (_repeatType == RepeatType.selectedDate)
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
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Start Date'),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _startDate != null
                        ? _startDate!.toLocal().toString().split(' ')[0]
                        : '',
                  ),
                ),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'End Date'),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() {
                        _endDate = picked;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _endDate != null
                        ? _endDate!.toLocal().toString().split(' ')[0]
                        : '',
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Add Habit'),
                ),
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
        final TextEditingController _newCategoryController =
        TextEditingController();
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
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
                  String newCategory = _newCategoryController.text;
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
        notificationTime: _selectedTime,
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

       pickerTitle: Center(child: Text('Select Times per week')),
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

      pickerTitle: Center(child: Text('Select Times per Month')),
      selectedItemIndex: selectedTimesPerMonth-1,
    ).show(context);
  }
}
