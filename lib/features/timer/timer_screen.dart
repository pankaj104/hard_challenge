import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hard_challenge/widgets/custom_time_duration_picker.dart';
import 'package:provider/provider.dart';
import '../../model/habit_model.dart';
import '../../../provider/habit_provider.dart';
import 'package:hard_challenge/features/timer/dotted_circle_painter.dart';

class TimerScreen extends StatefulWidget {
  final Habit habit;
  final DateTime selectedDate;

  const TimerScreen({Key? key, required this.habit, required this.selectedDate}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Duration elapsedDuration;
  late Duration _targetDuration;
  Timer? _timer;
  bool _isRunning = false;
  late String _dailyQuote;

  // List of motivational quotes
  final List<String> _quotes = [
    "Keep pushing forward!",
    "Believe in yourself.",
    "Every step counts!",
    "Stay strong and focused.",
    "Success is built on consistency.",
    "You are capable of great things.",
    "Don't stop until you're proud."
  ];

  @override
  void initState() {
    super.initState();
    _targetDuration = widget.habit.timer!;
    elapsedDuration = widget.habit.progressJson[widget.selectedDate]?.duration ?? Duration.zero;
    if (widget.habit.progressJson[widget.selectedDate]?.status == TaskStatus.done) {
      _isRunning = false;
    }
    _dailyQuote = _getDailyQuote();
  }

  String _getDailyQuote() {
    int index = DateTime.now().day % _quotes.length;
    return _quotes[index];
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (elapsedDuration < _targetDuration) {
          elapsedDuration += const Duration(seconds: 1);
          _updateProgress();
        } else {
          _completeTimer();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() => _isRunning = false);
    _timer?.cancel();
    _updateProgress();
  }

  void _completeTimer() {
    setState(() {
      _isRunning = false;
      elapsedDuration = _targetDuration;
      _updateProgress(complete: true);
      widget.habit.progressJson[widget.selectedDate]?.status = TaskStatus.done;
    });
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      elapsedDuration = Duration.zero;
    });
    _timer?.cancel();
    _updateProgress();
  }

  void _updateProgress({bool complete = false}) {
    final progress = elapsedDuration.inSeconds / _targetDuration.inSeconds;
    widget.habit.progressJson[widget.selectedDate]?.duration = elapsedDuration;
    widget.habit.progressJson[widget.selectedDate]?.progress = progress;
    Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(
      widget.habit,
      widget.selectedDate,
      progress,
      complete ? TaskStatus.done : TaskStatus.goingOn,
      elapsedDuration,
    );
  }


  String _formattedDuration = '00:02:00'; // Default formatted duration

  void _changeDuration(BuildContext context) {
    CustomTimeDurationPickerBottomSheet.showTimePicker(
      context,
      elapsedDuration, /// display timer on click
          (String formattedDuration, Duration newDuration) {
        setState(() {
          _formattedDuration = formattedDuration;
          elapsedDuration = newDuration; ///  to reflect
          // _targetDuration = newDuration; // update the target duration accordingly
          _updateProgress();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _updateProgress();
    super.dispose();
  }

  Widget _buildTimerDesign() {
    double progress = elapsedDuration.inSeconds / _targetDuration.inSeconds;
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(200, 200),
              painter: DottedCirclePainter(),
            ),
            // Transform.rotate(
            //   angle: value * 2 * pi,
            //   child: Align(
            //     alignment: const Alignment(0.0, -0.27),
            //     child: Container(
            //       width: 12,
            //       height: 12,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Colors.red.shade700,
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.red.withOpacity(0.6),
            //             blurRadius: 8,
            //             spreadRadius: 3,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _changeDuration(context),
                  child: Text(
                    _formatDuration(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  _isRunning ? "Keep Going!" : "Paused",
                  style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDuration() {
    int minutes = elapsedDuration.inMinutes % 60;
    int seconds = elapsedDuration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox( height: MediaQuery.of(context).size.height * 0.18,),
          Container(
              child: _buildTimerDesign()),
          SizedBox(height: 60,),
          Text(
            _dailyQuote,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
          ),
          SizedBox(height: 100,),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause_circle : Icons.play_circle, size: 50, color: Colors.green),
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                ),
                IconButton(
                  icon: const Icon(Icons.restart_alt, size: 50, color: Colors.orange),
                  onPressed: _resetTimer,
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle, size: 50, color: Colors.blue),
                  onPressed: _completeTimer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
