import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNumberPickerBottomSheet {
  static void showNumberPicker(
      BuildContext context, int initialNumber, int numberLimit, String setTitleText, Function(int) onNumberSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        int selectedNumber = initialNumber;

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
                     Text(
                      setTitleText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        onNumberSelected(selectedNumber); // Pass the selected number back
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              // Cupertino Number Picker
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40, // Height of each item
                  scrollController: FixedExtentScrollController(initialItem: initialNumber - 1),
                  onSelectedItemChanged: (int newValue) {
                    selectedNumber = newValue + 1; // Add 1 to start from 1
                  },
                  children: List<Widget>.generate(numberLimit, (int index) {
                    return Center(
                      child: Text(
                        (index + 1).toString(), // Display numbers starting from 1
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
