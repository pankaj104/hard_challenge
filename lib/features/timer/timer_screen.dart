import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hard_challenge/features/timer/dotted_circle_painter.dart';
import 'package:hard_challenge/utils/constant.dart';
import 'package:provider/provider.dart';
import '../../model/habit_model.dart';
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
  int _selectedDesign = 0;  // To switch between different designs
  String _currentQuote = 'A goal without a plan is just a wish.';  // Store the current quote

  @override
  void initState() {
    super.initState();
    _initialDuration = widget.habit.timer!;
    final savedElapsedDuration = widget.habit.progressJson[widget.selectedDate]?.duration ?? Duration.zero;
    _duration = _initialDuration - savedElapsedDuration;
    if (_duration.isNegative) {
      _duration = Duration.zero;
    }
    // Select and store a random quote only once when the screen is first loaded
    _currentQuote = ConstantData().getRandomQuote();
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
      _duration = Duration.zero;
      _updateProgress(complete: true);
      widget.habit.progressJson[widget.selectedDate]?.status = TaskStatus.done;
    });
    Navigator.of(context).pop();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _duration = _initialDuration;
    });
    _updateProgress();
  }

  void _updateProgress({bool complete = false}) {
    final totalSeconds = _initialDuration.inSeconds;
    final elapsedSeconds = complete ? totalSeconds : totalSeconds - _duration.inSeconds;
    final progress = elapsedSeconds / totalSeconds;
    widget.habit.progressJson[widget.selectedDate]?.duration = _initialDuration - _duration;
    widget.habit.progressJson[widget.selectedDate]?.progress = progress;

    Provider.of<HabitProvider>(context, listen: false).updateHabitProgress(
      widget.habit,
      widget.selectedDate,
      progress,
      complete ? TaskStatus.done : TaskStatus.goingOn,
      Duration(seconds: elapsedSeconds),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (!_isRunning) {
      _updateProgress();
    }
    super.dispose();
  }

  Widget _buildSelectedTimerDesign() {
    switch (_selectedDesign) {
      case 0:
        return _design1();
      case 1:
        return _design2();
      case 2:
        return _design3();
        case 3:
        return _design4();
      default:
        return _design1();
    }
  }

  Widget _design1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _duration.inSeconds / _initialDuration.inSeconds,
              strokeWidth: 8,
              color: Colors.purple,
              backgroundColor: Colors.purple.shade100,
            ),
            // Icon(Icons.book, size: 60, color: Colors.purple),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _duration.inMinutes == 0 && _duration.inSeconds == 0 ?
          '' : 'Time left',
          style: TextStyle(fontSize: 24, color: Colors.purple.shade700),
        ),
        Text(
          _duration.inMinutes == 0 && _duration.inSeconds == 0
              ? 'Completed Good work!'
              :     _formatDuration(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
        ),

      ],
    );
  }

  Widget _design2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: _duration.inSeconds / _initialDuration.inSeconds,
          minHeight: 10,
        ),
        const SizedBox(height: 20),
        Text(
          _duration.inMinutes == 0 && _duration.inSeconds == 0
              ? 'Completed Good work!'
              :     _formatDuration(),
          style: const  TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _design3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _isRunning ? 1 : 0.5,
          duration: const Duration(milliseconds: 500),
          child: const Icon(
            Icons.hourglass_bottom,
            size: 80,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 20),
        Text(
    _duration.inMinutes == 0 && _duration.inSeconds == 0
    ? 'Completed Good work!' :
    _formatDuration(),
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _design4() {
    double progress = 1 - (_duration.inSeconds / _initialDuration.inSeconds);
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(150, 150),
                painter: DottedCirclePainter(),
              ),
              Transform.rotate(
                angle: value * 2 * pi,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Text(
        _duration.inMinutes == 0 && _duration.inSeconds == 0 ? 'Done':
        _formatDuration(),
                style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration() {
    int hours = _duration.inHours;
    int minutes = _duration.inMinutes % 60;
    int seconds = _duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.habit.title}'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return IconButton(
                icon: Icon(
                  index == _selectedDesign ? Icons.circle : Icons.circle_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _selectedDesign = index;
                  });
                },
              );
            }),
          ),
          Expanded(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildSelectedTimerDesign(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow , size: 40,),
                onPressed: _isRunning ? _pauseTimer : _startTimer,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.check,size: 40,),
                onPressed: _completeTimer,
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.restart_alt,size: 40,),
                onPressed: _resetTimer,
              ),
            ],
          ),
          const SizedBox(height: 50,),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              child: Text(
                _currentQuote,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const SizedBox(height: 150,)
        ],
      ),
    );
  }
}
