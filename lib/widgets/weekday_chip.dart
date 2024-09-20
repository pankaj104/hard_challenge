import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeekdayChip extends StatelessWidget {
  final String day;
  final int dayValue;
  final bool isSelected;
  final Function(bool) onSelected;

  const WeekdayChip({
    Key? key,
    required this.day,
    required this.dayValue,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.1),
      //       blurRadius: 30.0,
      //       spreadRadius: 1.0,
      //       offset: const Offset(0, 1),
      //     ),
      //   ],
      // ),
      child: ChoiceChip(
        labelPadding: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        label: SizedBox(
            height: 38,
            width: 38,
            child: Center(child: Text(day))),
        selected: isSelected,
        selectedColor: Colors.blue,
        showCheckmark: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.black12.withOpacity(0.05),
          ),
        ),
        labelStyle: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        onSelected: onSelected,
      ),
    );
  }
}
