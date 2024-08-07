import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ContainerLabelWidget extends StatelessWidget {
  String labelTitle;
   ContainerLabelWidget(this.labelTitle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(labelTitle,
    style: GoogleFonts.poppins(fontSize: 15,
      color: Colors.black,
      fontWeight: FontWeight.w600,),
    );
  }
}
