import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/habit_model.dart';
import '../../../provider/habit_provider.dart';

class TimerScreen extends StatefulWidget {
  final Habit habit;
  final DateTime selectedDate;

  const TimerScreen({Key? key, required this.habit, required this.selectedDate}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Duration _duration;
  late Duration _initialDuration;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _initialDuration = widget.habit.timer!;
    _duration = _initialDuration;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration = Duration(seconds: _duration.inSeconds - 1);
          _updateProgress();
        } else {
          _timer?.cancel();
          _isRunning = false;
          _completeTimer();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _completeTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _duration = _initialDuration;
      _updateProgress(complete: true);
      widget.habit.progressJson[widget.selectedDate]?.status = TaskStatus.done;

    });
    Navigator.of(context).pop();
  }

  void _updateProgress({bool complete = false}) {
    final totalSeconds = _initialDuration.inSeconds;
    final elapsedSeconds = complete ? totalSeconds : totalSeconds - _duration.inSeconds;
    final progress = elapsedSeconds / totalSeconds;

    widget.habit.progressJson[widget.selectedDate]?.progress = progress;
    Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(widget.habit, widget.selectedDate, progress, TaskStatus.done);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer: ${widget.habit.title}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isRunning
                    ? ElevatedButton(
                  onPressed: _pauseTimer,
                  child: const Text('Pause'),
                )
                    : ElevatedButton(
                  onPressed: _startTimer,
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _completeTimer,
                  child: const Text('Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
