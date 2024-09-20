import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddReminderButton extends StatelessWidget {
  final VoidCallback onAdd;

  const AddReminderButton({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: onAdd,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
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
          child:  Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, // Background color for the icon
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 30.0),
               Text(
                'Add reminder',
                style: GoogleFonts.poppins(
                  color: Colors.black,
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
