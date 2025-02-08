import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hard_challenge/utils/colors.dart';

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
        label: Container(
          height: 25, // Adjust the size as needed
          width: 25,  // Adjust the size as needed
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? ColorStrings.headingBlue : Colors.white,
          ),
          child: Center(
            child: Text(
              day,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        selected: isSelected,
        selectedColor: ColorStrings.headingBlue,
        showCheckmark: false,
        backgroundColor: Colors.transparent,
        shape: const CircleBorder(), // Ensures the chip itself is circular
        onSelected: onSelected,
      ),

    );
  }
}
