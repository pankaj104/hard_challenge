import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hard_challenge/widgets/number_picker.dart';

class CounterWidget extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onValueChanged;

  const CounterWidget({
    Key? key,
    required this.initialValue,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _currentValue++;
    });
    widget.onValueChanged(_currentValue);
  }

  void _decrement() {
    if (_currentValue > 0) {
      setState(() {
        _currentValue--;
      });
      widget.onValueChanged(_currentValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const SizedBox(width: 20,),

        GestureDetector(
          onTap: _decrement,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.grey.shade200, // Background color for the icon
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.black,
              size: 22.0,
            ),
          ),
        ),

        const SizedBox(width: 10,),
        GestureDetector(
          onTap: () {
            CustomNumberPickerBottomSheet.showNumberPicker(
              context,
              _currentValue,
                  999999,
              'Set Count',
                  (int selectedNumber) {
                setState(() {
                  _currentValue = selectedNumber; // Update the current value
                  log('_currentValue $_currentValue selectedNumber $selectedNumber');
                });
              },
            );
          },
          child: Container(
            width: 80,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                _currentValue.toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10,),

        GestureDetector(
          onTap: _increment,
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
              size: 22.0,
            ),
          ),
        ),
      ],
    );
  }
}
