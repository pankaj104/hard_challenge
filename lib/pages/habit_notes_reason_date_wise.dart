import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hard_challenge/model/habit_model.dart';
import 'package:hard_challenge/utils/helpers.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/habit_provider.dart';

class HabitNotesReasonDateWise extends StatefulWidget {
  final Habit habit;

  const HabitNotesReasonDateWise({Key? key, required this.habit}) : super(key: key);

  @override
  _HabitNotesReasonDateWiseState createState() => _HabitNotesReasonDateWiseState();
}

class _HabitNotesReasonDateWiseState extends State<HabitNotesReasonDateWise> {
  late List<MapEntry<DateTime, String>> sortedEntries;
  TaskStatus selectedStatus = TaskStatus.none;

  final Map<TaskStatus, IconData> statusIcons = {
    TaskStatus.none: Icons.list,
    TaskStatus.done: Icons.check_circle,
    TaskStatus.missed: Icons.close,
    TaskStatus.skipped: Icons.remove_circle_outline,
    TaskStatus.reOpen: Icons.refresh,
    TaskStatus.goingOn: Icons.loop,
  };

  @override
  void initState() {
    super.initState();
    _loadSortedNotes();
  }

  void _loadSortedNotes() {
    sortedEntries = [];

    if (widget.habit.notesForReason != null) {
      sortedEntries.addAll(widget.habit.notesForReason!.entries);
    }

    sortedEntries.sort((a, b) => a.key.compareTo(b.key));
  }

  TaskStatus _getStatusForDate(DateTime date) {
    return widget.habit.progressJson[date]?.status as TaskStatus? ?? TaskStatus.none;
  }

  void _filterByStatus(TaskStatus status) {
    setState(() {
      selectedStatus = status;
    });
  }

  List<MapEntry<DateTime, String>> _getFilteredNotes() {
    if (selectedStatus == TaskStatus.none) {
      return sortedEntries;
    }
    return sortedEntries.where((entry) {
      return _getStatusForDate(entry.key) == selectedStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<DateTime, String>> filteredNotes = _getFilteredNotes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes & Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<TaskStatus>(
                  value: selectedStatus,
                  onChanged: (TaskStatus? newValue) {
                    if (newValue != null) {
                      _filterByStatus(newValue);
                    }
                  },
                  items: TaskStatus.values.map((TaskStatus status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Icon(statusIcons[status], color: _getStatusColor(status)),
                          const SizedBox(width: 8),
                          Text(status.name),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredNotes.isEmpty
                  ? const Center(child: Text('No notes available'))
                  : ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final entry = filteredNotes[index];
                  String formattedDate = DateFormat('yyyy-MM-dd').format(entry.key);
                  TaskStatus status = _getStatusForDate(entry.key);

                  log('test status $status');

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      leading: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(status).withOpacity(0.2),
                        ),
                        child: Icon(statusIcons[status], color: _getStatusColor(status)),
                      ),
                      title: Text(
                        formattedDate,
                        style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                      subtitle: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 16, color: Colors.black87,fontWeight: FontWeight.bold,),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            widget.habit.notesForReason?.remove(entry.key);
                            DateTime date = entry.key;

                            Provider.of<HabitProvider>(context, listen: false).deleteFeedbackFromHabit(widget.habit.id, date);

                            _loadSortedNotes();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.missed:
        return Colors.red;
      case TaskStatus.skipped:
        return Colors.orange;
      case TaskStatus.goingOn:
        return Colors.blue;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.reOpen:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}