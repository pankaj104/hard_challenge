import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingH1Widget extends StatelessWidget {
  String headingtitle;
   HeadingH1Widget(this.headingtitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      headingtitle,
      style: GoogleFonts.poppins(fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w600,),
    );
  }
}
