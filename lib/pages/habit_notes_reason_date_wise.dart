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
    if (date.isAfter(setSelectedDate(DateTime.now())) || date.isAtSameMomentAs(setSelectedDate(DateTime.now()))) {
      return widget.habit.progressJson[date]?.status ?? TaskStatus.none;
    }
    if (widget.habit.progressJson[date] == null) {
      return TaskStatus.missed;
    }
    return widget.habit.progressJson[date]?.status ?? TaskStatus.none;
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
    return sortedEntries.where((entry) => _getStatusForDate(setSelectedDate(entry.key)) == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<DateTime, String>> filteredNotes = _getFilteredNotes();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Notes observation'),
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.withOpacity(0.1),
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
                            Text(status == TaskStatus.none ? 'All' : status.name),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
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
                  String formattedDate = DateFormat('dd-MM-yyyy').format(setSelectedDate(entry.key));
                  TaskStatus status = _getStatusForDate(setSelectedDate(entry.key));

                  log('test status $status');

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getStatusColor(status).withOpacity(0.2),
                            ),
                            child: Icon(statusIcons[status], color: _getStatusColor(status)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  entry.value,
                                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                widget.habit.notesForReason?.remove(entry.key);
                                Provider.of<HabitProvider>(context, listen: false).deleteFeedbackFromHabit(widget.habit.id, entry.key);
                                _loadSortedNotes();
                              });
                            },
                          ),
                        ],
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
