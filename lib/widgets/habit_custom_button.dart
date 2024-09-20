import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HabitCustomButton extends StatelessWidget {
  final String buttonText;
  final Color color;
  final Color buttonTextColor;
  final VoidCallback onTap;
  final double widthOfButton;

  const HabitCustomButton({super.key, required this.buttonText, required this.onTap, required this.color, required this.widthOfButton, required this.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          height: 40,
          width: widthOfButton,
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8.0,
                spreadRadius: 2.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: Text(buttonText, style:
          GoogleFonts.poppins(fontSize: 15,
            color: buttonTextColor,
            fontWeight: FontWeight.w400,)
            ,))
        ),
      ),
    );
  }
}
