import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCategoryList extends StatelessWidget {
  final String categoryText;
  final bool isSelected;

  const CustomCategoryList({
    super.key,
    required this.categoryText,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10.0),
              Text(
                categoryText,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
