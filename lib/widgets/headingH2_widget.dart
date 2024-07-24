import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingH2Widget extends StatelessWidget {
  String headingTitle;

   HeadingH2Widget(this.headingTitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text( headingTitle,
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(fontSize: 21,
        color: Colors.black,
        fontWeight: FontWeight.w600,),
    );
  }
}
