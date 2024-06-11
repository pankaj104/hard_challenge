import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'model/habit_model.dart';
import 'provider/habit_provider.dart';

class AddChallengeScreen extends StatefulWidget {
  @override
  _AddChallengeScreenState createState() => _AddChallengeScreenState();
}

class _AddChallengeScreenState extends State<AddChallengeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'General';
  String _title = '';
  TimeOfDay _selectedTime = TimeOfDay.now();
  TaskType _taskType = TaskType.normal;
  RepeatType _repeatType = RepeatType.daily;
  Duration _timerDuration = const Duration(minutes: 1); // default 00:01:00
  int _taskValue = 5; // default value 5
  final List<String> _categories = ['General', 'Work', 'Health', 'Other'];
  final List<int> _selectedDays = [];
  final List<DateTime> _selectedDates = [];
  DateTime? _startDate;
  DateTime? _endDate;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories
                          .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addNewCategory(context),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Habit Title'),
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
              const Text('Task Type'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: TaskType.values.map((type) {
                  return ChoiceChip(
                    label: Text(type.toString().split('.').last),
                    selected: _taskType == type,
                    onSelected: (selected) {
                      setState(() {
                        _taskType = type;
                      });
                    },
                  );
                }).toList(),
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
              const Text('Repeat Type'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: RepeatType.values.map((type) {
                  return ChoiceChip(
                    label: Text(type.toString().split('.').last),
                    selected: _repeatType == type,
                    onSelected: (selected) {
                      setState(() {
                        _repeatType = type;
                        if (type == RepeatType.selectDays) {
                          _selectedDays.clear();
                        }
                        if (type == RepeatType.selectedDate) {
                          _selectedDates.clear();
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (_repeatType == RepeatType.selectDays)
                Wrap(
                  children: [
                    {'Mon': 1},
                    {'Tue': 2},
                    {'Wed': 3},
                    {'Thu': 4},
                    {'Fri': 5},
                    {'Sat': 6},
                    {'Sun': 7}
                  ].map((dayMap) {
                    String day = dayMap.keys.first;
                    int dayValue = dayMap.values.first;
                    return ChoiceChip(
                      label: Text(day),
                      selected: _selectedDays.contains(dayValue),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(dayValue);
                          } else {
                            _selectedDays.remove(dayValue);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              if (_repeatType == RepeatType.selectedDate)
                Column(
                  children: [
                    TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2030),
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) => _selectedDates.contains(day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          if (_selectedDates.contains(selectedDay)) {
                            _selectedDates.remove(selectedDay);
                          } else {
                            _selectedDates.add(selectedDay);
                          }
                        });
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                    ),
                    Wrap(
                      children: _selectedDates.map((date) {
                        return Chip(
                          label: Text(date.toLocal().toString().split(' ')[0]),
                          onDeleted: () {
                            setState(() {
                              _selectedDates.remove(date);
                            });
                          },
                        );
                      }).toList(),
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
                      !_categories.contains(newCategory)) {
                    _categories.add(newCategory);
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
        progress: {},
        days: _repeatType == RepeatType.selectDays ? _selectedDays : null,
        startDate: _startDate,
        endDate: _endDate,
        selectedDates:
        _repeatType == RepeatType.selectedDate ? _selectedDates : null,
      );
      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);
      Navigator.of(context).pop();
    }
  }
}
