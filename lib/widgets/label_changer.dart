import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabelChanger extends StatefulWidget {
  final String initialLabel;
  final ValueChanged<String> onLabelChanged;

  const LabelChanger({
    Key? key,
    required this.initialLabel,
    required this.onLabelChanged,
  }) : super(key: key);

  @override
  _LabelChangerState createState() => _LabelChangerState();
}

class _LabelChangerState extends State<LabelChanger> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialLabel);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 180,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      child: Column(
        children: [
          // Header with close and tick icons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context), // Close button action
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                const Text(
                  'Set Label',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onLabelChanged(_controller.text);
                    Navigator.pop(context); // Save and close
                  },
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // TextField to input label
          Container(
            decoration: BoxDecoration(
              color: Colors.white,  // Background color of the container
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              maxLength: 20,
              autofocus: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // Padding inside TextField
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white12,  // Background color for TextField input area
                counter: SizedBox.shrink(),  // Removes the character counter
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
              textAlign: TextAlign.center,  // Centers the text inside the TextField
            ),

          ),

        ],
      ),
    );
  }
}

