// import 'dart:developer';
// import 'package:bottom_picker/resources/arrays.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// // import 'package:flutter_iconpicker/flutter_iconpicker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hard_challenge/utils/app_utils.dart';
// import 'package:hard_challenge/utils/colors.dart';
// import 'package:hard_challenge/utils/image_resource.dart';
// import 'package:hard_challenge/widgets/headingH1_widget.dart';
// import 'package:hard_challenge/widgets/headingH2_widget.dart';
// import 'package:numberpicker/numberpicker.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import '../../model/habit_model.dart';
// import '../../provider/habit_provider.dart';
// import '../../widgets/icon_button_widget.dart';
// import 'package:bottom_picker/bottom_picker.dart';
//
//
// class AddChallengeScreen extends StatefulWidget {
//   AddChallengeScreen({super.key});
//
//   @override
//   _AddChallengeScreenState createState() => _AddChallengeScreenState();
// }
//
// class _AddChallengeScreenState extends State<AddChallengeScreen> {
//
//   List<bool> isSelected = [true, false, false];
//   final _formKey = GlobalKey<FormState>();
//   DateTime today = DateTime.now();
//   String _selectedCategory = 'General';
//   String _title = 'Test';
//   late DateTime _selectedTime =  today;
//   // late String _formattedTime;
//   // String _selectedTime = DateFormat('HH:mm').format(DateTime.now());
//   TaskType _taskType = TaskType.task;
//   final RepeatType _repeatType = RepeatType.selectDays;
//   Duration _timerDuration =  Duration(minutes: 1); // default 00:01:00
//   int _taskValue = 5; // default value 5
//   RepeatType _repeatSelectedItem = RepeatType.selectDays;
//
//   DateTime? _startDate;
//   DateTime? _endDate ;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   Color selectedColor = Colors.orange;
//   int selectedTimesPerWeek = 2;
//   int selectedTimesPerMonth = 1;
//
//   List<String> repeatItems = [
//     RepeatType.selectDays.toString(),
//     RepeatType.weekly.toString(),
//     RepeatType.monthly.toString(),
//     RepeatType.selectedDate.toString(),
//   ];
//
//   TextEditingController notecontroller = TextEditingController();
//   String? habitNote ;
//
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   _selectedTime = DateTime.now();
//   //   _formattedTime = DateFormat('HH:mm').format(_selectedTime);
//   // }
//
//   IconData iconSelected = FontAwesomeIcons.iceCream;
//   void _openColorPicker() async {
//     Color? pickedColor = await showDialog(
//       context: context,
//       builder: (context) {
//         Color tempSelectedColor = selectedColor;
//         IconData selectedIcon = iconSelected;
//
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title:  Text('Pick a color and icon'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   GestureDetector(
//                     onTap: () async {
//                       // IconData? newIcon = await showIconPicker(
//                       //     context,
//                       //     iconPackModes: [IconPack.fontAwesomeIcons]
//                       // );
//                       //
//                       // if (newIcon != null) {
//                       //   setState(() {
//                       //     selectedIcon = newIcon;
//                       //     iconSelected = newIcon;
//                       //   });
//                       // }
//                     },
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         color: tempSelectedColor,
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(color: Colors.grey, width: 2),
//                       ),
//                       child: Icon(selectedIcon, color: Colors.black),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: predefinedColors.map((color) {
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             tempSelectedColor = color;
//                           });
//                         },
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: BoxDecoration(
//                             color: color,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                   SizedBox(height: 20),
//
//                   SingleChildScrollView(
//                     child: ColorPicker(
//                       pickerColor: tempSelectedColor,
//                       onColorChanged: (color) {
//                         setState(() {
//                           tempSelectedColor = color;
//                         });
//                       },
//                       showLabel: false,
//                       enableAlpha: false,
//                       pickerAreaHeightPercent: 0.8,
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   child:  Text('Select'),
//                   onPressed: () {
//                     Navigator.of(context).pop(tempSelectedColor);
//                   },
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//
//     if (pickedColor != null) {
//       setState(() {
//         selectedColor = pickedColor;
//       });
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 0,
//         // title:  Text('Add Challenge'),
//       ),
//       body: Padding(
//         padding:  EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child:
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     IconButtonWidget(icon: ImageResource.closeIcon,
//                         onPressed: (){
//                           Navigator.pop(context);
//                         } ),
//
//                     Expanded(
//                       child: Center(
//                         child: HeadingH2Widget("New Habit"),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 42.w,
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding:   EdgeInsets.only(top: 22, bottom: 6),
//                         child: SizedBox(
//                           height: 26,
//                           width: double.infinity,
//                           child: HeadingH1Widget("Category"),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding:   EdgeInsets.only( top: 2, bottom: 2,),
//                       child: Container(
//                         height: 62,
//                         width: double.infinity,
//                         // margin:EdgeInsets.only(left: 10, right: 10)
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: ColorStrings.headingBlue,
//                           // border: Border.all(width: 2,)
//                         ),
//                         child:
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child:
//                               Padding(
//                                 padding:  EdgeInsets.only(left: 7,top: 7,bottom: 5),
//                                 child: SizedBox(
//                                   height:60.h,
//                                   width: double.infinity,
//                                   child: DropdownButtonFormField<String>(
//                                     borderRadius: BorderRadius.circular(16.0),
//                                     icon:  Icon(Icons.keyboard_arrow_down_rounded),
//                                     iconSize: 25,
//                                     iconEnabledColor: ColorStrings.whiteColor,
//                                     itemHeight: 50,
//                                     dropdownColor: ColorStrings.headingBlue,
//                                     value: _selectedCategory,
//                                     items: categories
//                                         .map((category) => DropdownMenuItem<String>(
//                                       value: category,
//                                       child: Text(category,style:  TextStyle(color: ColorStrings.whiteColor,
//                                           fontSize: 15, fontWeight: FontWeight.w600), ),
//                                     ))
//                                         .toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedCategory = value!;
//                                       });
//                                     },
//                                     decoration: InputDecoration(
//                                       contentPadding:  EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
//                                       enabledBorder:  OutlineInputBorder(
//                                         borderSide: BorderSide(color: ColorStrings.whiteColor,width: 2),
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(8.0),),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                         borderSide:   BorderSide(color: ColorStrings.whiteColor,width: 2),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding:  EdgeInsets.only(left: 22, right: 8, top: 5, bottom: 5),
//                               child: Container(
//                                 height: 40.h,
//                                 width: 43.w,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     border: Border.all(width: 2,color: ColorStrings.whiteColor)
//                                 ),
//                                 child: IconButton(
//                                   icon:   Icon(Icons.add,color: ColorStrings.whiteColor,),
//                                   onPressed: () => _addNewCategory(context),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8,),
//                 Column(
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding:   EdgeInsets.only(top: 14, bottom: 6),
//                         child: SizedBox(
//                           height: 26,
//                           width: double.infinity,
//                           child: HeadingH1Widget("Habit Name"),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8,),
//
//                 Container(
//                   width: 328.w,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     color: ColorStrings.whiteColor,
//                     boxShadow:  [
//                       BoxShadow(
//                         offset: Offset(2.0, 2.0),
//                         color: Colors.grey,
//                         blurRadius: 2.0,
//                       ),],
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: _openColorPicker,
//                         child: Container(
//                           margin: EdgeInsets.fromLTRB(10, 5, 0, 5) ,
//                           height: 38.h,
//                           width: 44.w,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               color: selectedColor
//                           ),
//                           child: Icon(iconSelected, color: Colors.black),
//                         ),
//                       ),
//                       SizedBox(width: 10,),
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.centerLeft,  // Aligns text to the left
//                           width: 250,
//                           child: TextFormField(
//                             decoration:   InputDecoration(
//                               labelText: 'Habit Title',
//                               border: InputBorder.none,  // Removes the default underline
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Please enter a title';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _title = value!;
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 TextFormField(
//                   readOnly: true,
//                   decoration:  InputDecoration(labelText: 'Notification Time'),
//                   onTap: () async {
//                     _openTimePicker(context);
//                     // TimeOfDay? picked = await showTimePicker(
//                     //   context: context,
//                     //   initialTime: TimeOfDay.now(),
//                     // );
//                     // if (picked != null) {
//                     //   setState(() {
//                     //     _selectedTime = picked;
//                     //   });
//                     // }
//                   },
//                   controller: TextEditingController(
//                     text: getFormattedTime(_selectedTime),
//                   ),
//                 ),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding:   EdgeInsets.only(top: 14, bottom: 8),
//                       child: HeadingH1Widget("Goal"),
//                     )),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8),
//                   child: ToggleButtonRow(),
//                 ),
//                 if (_taskType == TaskType.time)
//                   TextFormField(
//                     readOnly: true,
//                     decoration:  InputDecoration(labelText: 'Timer Duration'),
//                     onTap: () async {
//                       Duration? picked = await showDurationPicker(
//                         context: context,
//                         initialDuration: _timerDuration,
//                       );
//                       if (picked != null) {
//                         setState(() {
//                           _timerDuration = picked;
//                         });
//                       }
//                     },
//                     controller: TextEditingController(
//                       text: _timerDuration
//                           .toString()
//                           .split('.')
//                           .first
//                           .padLeft(8, '0'),
//                     ),
//                   ),
//                 if (_taskType == TaskType.count)
//                   TextFormField(
//                     decoration:  InputDecoration(labelText: 'Task Value'),
//                     keyboardType: TextInputType.number,
//                     initialValue: _taskValue.toString(),
//                     onSaved: (value) {
//                       _taskValue = int.parse(value!);
//                     },
//                   ),
//                 Align(
//                     alignment: Alignment.centerLeft,
//                     child: Padding(
//                       padding:   EdgeInsets.only(top: 14, bottom: 8),
//                       child: HeadingH1Widget("Repeat Type"),
//                     )),
//                 Container(
//                   width: double.infinity,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     color: ColorStrings.headingBlue,
//                     // border: Border.all(width: 2,),
//                   ),
//                   child: Padding(
//                     padding:   EdgeInsets.only(top: 3,left: 2, right: 2),
//                     child: DropdownButtonFormField<RepeatType>(
//                       value: _repeatSelectedItem,
//                       dropdownColor: ColorStrings.headingBlue,
//                       icon:   Icon(Icons.keyboard_arrow_down_rounded),
//                       iconSize: 25,
//                       iconEnabledColor: ColorStrings.whiteColor,
//                       itemHeight: 50,
//                       items: RepeatType.values.map((RepeatType item) {
//                         return DropdownMenuItem<RepeatType>(
//                           value: item,
//                           child: Text(
//                             item.toString().split('.').last,
//                             style:  TextStyle(
//                               color: ColorStrings.whiteColor,
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                       onChanged: (RepeatType? value) {
//                         setState(() {
//                           _repeatSelectedItem = value! ;
//                           print(_repeatSelectedItem);
//                         });
//                       },
//                       decoration:  InputDecoration(border: InputBorder.none,
//                         contentPadding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
//                       ),),
//                   ),),
//                 if (_repeatSelectedItem == RepeatType.selectDays)
//                   Wrap(
//                     children: [
//                       {'M': 1},
//                       {'Tu': 2},
//                       {'W': 3},
//                       {'Th': 4},
//                       {'F': 5},
//                       {'Sa': 6},
//                       {'Su': 7}
//                     ].map((dayMap) {
//                       String day = dayMap.keys.first;
//                       int dayValue = dayMap.values.first;
//                       return ChoiceChip(
//                         label: Text(day),
//                         selected: selectedDays.contains(dayValue),
//                         // showCheckmark: false,
//                         onSelected: (selected) {
//                           setState(() {
//                             if (selected) {
//                               selectedDays.add(dayValue);
//                               log('selectedDays value $selectedDays');
//                             } else {
//                               selectedDays.remove(dayValue);
//                             }
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 // if (_repeatSelectedItem == RepeatType.selectedDate)
//
//                 if (_repeatSelectedItem == RepeatType.weekly)
//                   Row(
//                     children: [
//
//                       ElevatedButton(
//                         onPressed: _showWeeklyTimesPicker,
//                         child:  Text('$selectedTimesPerWeek times'),
//                       ),
//                       ElevatedButton(
//                         onPressed: _showWeeklyTimesPicker,
//                         child:   Text('Change'),
//                       ),
//
//                     ],
//                   ),
//
//                 if (_repeatSelectedItem == RepeatType.monthly)
//                   Row(
//                     children: [
//
//                       ElevatedButton(
//                         onPressed: _showMontlyimesPicker,
//                         child:  Text('$selectedTimesPerMonth times'),
//                       ),
//
//                       ElevatedButton(
//                         onPressed: _showMontlyimesPicker,
//                         child:   Text('Change'),
//                       ),
//
//                     ],
//                   ),
//
//                 if (_repeatSelectedItem == RepeatType.selectedDate)
//                   Column(
//                     children: [
//                       TableCalendar(
//                         focusedDay: DateTime.now(),
//                         firstDay: DateTime(2020),
//                         lastDay: DateTime(2030),
//                         calendarFormat: _calendarFormat,
//                         selectedDayPredicate: (day) => selectedDates.contains(day),
//                         onDaySelected: (selectedDay, focusedDay) {
//                           setState(() {
//                             if (selectedDates.contains(selectedDay)) {
//                               selectedDates.remove(selectedDay);
//                             } else {
//                               selectedDates.add(selectedDay);
//                             }
//                           });
//                         },
//                         onFormatChanged: (format) {
//                           setState(() {
//                             _calendarFormat = format;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 Column(
//                   children: [
//                     Padding(
//                       padding:  EdgeInsets.only(top: 16, bottom: 12),
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: SizedBox(
//                           height: 26,
//                           width: double.infinity,
//                           child: HeadingH1Widget("Schedule"),
//                         ),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Column(
//                           children: [
//                             Padding(
//                               padding:   EdgeInsets.only(bottom: 8),
//                               child: HeadingH1Widget("Start"),
//                             ),
//                             Container(
//                               width: 140,
//                               height: 52,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   color: ColorStrings.headingBlue
//                               ),
//                               child: Padding(
//                                 padding:  EdgeInsets.all(15.0),
//                                 child: TextFormField(
//                                   style: GoogleFonts.poppins(fontSize: 15,color: ColorStrings.whiteColor, fontWeight: FontWeight.w600,),
//                                   readOnly: true,
//                                   decoration:   InputDecoration(
//                                       border: InputBorder.none),
//                                   onTap: () async {
//                                     DateTime? picked = await showDatePicker(
//                                       context: context,
//                                       initialDate: DateTime.now(),
//                                       firstDate: DateTime(2020),
//                                       lastDate: DateTime(2030),
//                                     );
//                                     if (picked != null) {
//                                       setState(() {
//                                         _startDate = picked;
//                                       });
//                                     }
//                                   },
//                                   controller: TextEditingController(
//                                     text: _startDate != null
//                                         ? _startDate!.toLocal().toString().split(' ')[0]
//                                         : '',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding:   EdgeInsets.only(top: 16),
//                             child: SizedBox(
//                               width: 32,
//                               child: SvgPicture.asset(ImageResource.shuffleIcon),
//                             ),
//                           ),
//                         ),
//                         Column(
//                           children: [
//                             Padding(
//                               padding:   EdgeInsets.only(bottom: 6),
//                               child: HeadingH1Widget("End"),
//                             ),
//                             Container(
//                               width: 140,
//                               height: 52,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   color: ColorStrings.headingBlue
//                               ),
//                               child: Padding(
//                                 padding:  EdgeInsets.all(15.0),
//                                 child: TextFormField(
//                                   style: GoogleFonts.poppins(fontSize: 15,color: ColorStrings.whiteColor, fontWeight: FontWeight.w600,),
//                                   readOnly: true,
//                                   decoration:  InputDecoration(border: InputBorder.none),
//                                   onTap: () async {
//                                     DateTime? picked = await showDatePicker(
//                                       context: context,
//                                       initialDate: DateTime.now(),
//                                       firstDate: DateTime(2020),
//                                       lastDate: DateTime(2030),
//                                     );
//                                     if (picked != null) {
//                                       setState(() {
//                                         _endDate = picked;
//                                       });
//                                     }
//                                   },
//                                   controller: TextEditingController(
//                                     text: _endDate != null
//                                         ? _endDate!.toLocal().toString().split(' ')[0]
//                                         : '',
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 TextFormField(
//                   controller: notecontroller,
//                   decoration:  InputDecoration(
//                     labelText: 'Enter your text here',
//                     hintText: 'Type something...',
//                   ),
//                   onChanged: (value){
//                     setState(() {
//                       habitNote  = value.toString();
//                     });
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   child:  Text('Add Habit'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<Duration?> showDurationPicker(
//       {required BuildContext context, required Duration initialDuration}) async {
//     return showDialog<Duration>(
//       context: context,
//       builder: (BuildContext context) {
//         Duration tempDuration = initialDuration;
//         return AlertDialog(
//           title:  Text('Pick Duration'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               NumberPicker(
//                 minValue: 0,
//                 maxValue: 23,
//                 value: tempDuration.inHours,
//                 onChanged: (value) {
//                   setState(() {
//                     tempDuration =
//                         Duration(hours: value, minutes: tempDuration.inMinutes % 60);
//                   });
//                 },
//               ),
//               NumberPicker(
//                 minValue: 0,
//                 maxValue: 59,
//                 value: tempDuration.inMinutes % 60,
//                 onChanged: (value) {
//                   setState(() {
//                     tempDuration =
//                         Duration(hours: tempDuration.inHours, minutes: value);
//                   });
//                 },
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child:  Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child:  Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop(tempDuration);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _addNewCategory(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final TextEditingController newCategoryController =
//         TextEditingController();
//         return AlertDialog(
//           title:  Text('Add New Category'),
//           content: TextField(
//             controller: newCategoryController,
//             decoration:
//             InputDecoration(hintText: 'Enter new category'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child:  Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   String newCategory = newCategoryController.text;
//                   if (newCategory.isNotEmpty &&
//                       !categories.contains(newCategory)) {
//                     categories.add(newCategory);
//                     _selectedCategory = newCategory;
//                   }
//                 });
//                 Navigator.of(context).pop();
//               },
//               child:  Text('Add'),
//
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       final newHabit = Habit(
//           title: _title,
//           category: _selectedCategory,
//           habitIcon: iconSelected,
//           iconBgColor: selectedColor,
//           notificationTime: _selectedTime,
//           taskType: _taskType,
//           repeatType: _repeatType,
//           timer: _taskType == TaskType.time ? _timerDuration : null,
//           value: _taskType == TaskType.count ? _taskValue : null,
//           progressJson: {},
//           days: _repeatType == RepeatType.selectDays ? selectedDays : null,
//           startDate: _startDate,
//           endDate: _endDate,
//           selectedDates: _repeatType == RepeatType.selectedDate ? selectedDates : null,
//           selectedTimesPerWeek: _repeatType == RepeatType.weekly ? selectedTimesPerWeek : null,
//           selectedTimesPerMonth: _repeatType == RepeatType.monthly ? selectedTimesPerMonth : null,
//           notes: habitNote
//       );
//       log('New habbit added Data $newHabit');
//       Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
//       Navigator.of(context).pop();
//     }
//   }
//
//   void _showWeeklyTimesPicker() {
//     BottomPicker(
//       items: List.generate(6, (index) => Text((index + 1).toString())),
//       // title: 'Select a number',
//       onChange: (index) {
//         setState(() {
//           selectedTimesPerWeek = index + 1;
//         });
//       },
//
//       pickerTitle:  Center(child: Text('Select Times per week')),
//       selectedItemIndex: selectedTimesPerWeek-1,
//     ).show(context);
//   }
//
//   void _showMontlyimesPicker() {
//     BottomPicker(
//       items: List.generate(28, (index) => Text((index + 1).toString())),
//       // title: 'Select a number',
//       onChange: (index) {
//         setState(() {
//           selectedTimesPerMonth = index + 1;
//         });
//       },
//
//       pickerTitle:  Center(child: Text('Select Times per Month')),
//       selectedItemIndex: selectedTimesPerMonth-1,
//     ).show(context);
//   }
//
//   void _openTimePicker(BuildContext context) {
//     BottomPicker.time(
//       pickerTitle: Text(
//         'Set your next meeting time',
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 15,
//           color: ColorStrings.headingBlue,
//         ),
//       ),
//       onSubmit: (index) {
//         print('index1: $index');
//         setState(() {
//           _selectedTime = index;
//         });
//         print('index2: $index');
//       },
//       onClose: () {
//         print('Picker closed');
//       },
//       bottomPickerTheme: BottomPickerTheme.blue,
//       use24hFormat: true,
//       initialTime: Time(
//         minutes: 23,
//       ),
//       maxTime: Time(
//         hours: 17,
//       ),
//     ).show(context);
//   }
// }
//
// // getFormattedTime(DateTime selectedTime) {
// // }
// String getFormattedTime(DateTime selectedTime) {
//   // Extract the hour and minute from the DateTime object
//   String formattedTime = '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
//
//   return formattedTime;
// }
//
// class ToggleButtonRow extends StatefulWidget {
//   @override
//   _ToggleButtonRowState createState() => _ToggleButtonRowState();
// }
//
// class _ToggleButtonRowState extends State<ToggleButtonRow> {
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 336.w,
//       height: 52.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildToggleButton('Task', 0),
//           _buildToggleButton('Count', 1),
//           _buildToggleButton('Time', 2),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleButton(String text, int index) {
//     bool isSelected = selectedIndex == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       child: Container(
//         width: 108.w,
//         height: 48.h,
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? ColorStrings.headingBlue : Colors.transparent,
//           borderRadius: BorderRadius.circular(18.0),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.black,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 15
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }