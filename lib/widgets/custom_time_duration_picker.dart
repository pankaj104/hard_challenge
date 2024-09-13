import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimeDurationPickerBottomSheet {
  static void showTimePicker(
      BuildContext context, Duration initialDuration, Function(String, Duration) onDurationSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        Duration selectedDuration = initialDuration;

        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              // Custom AppBar with Close and Check Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      'Select Duration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        String formattedDuration = _formatDuration(selectedDuration);
                        onDurationSelected(formattedDuration, selectedDuration); // Pass the selected duration back
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Cupertino Timer Picker in Duration Mode
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: selectedDuration, // Use the previously selected duration as initial duration
                  onTimerDurationChanged: (Duration newDuration) {
                    selectedDuration = newDuration;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
