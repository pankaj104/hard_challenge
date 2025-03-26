import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final void Function()? onTap;

  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap : null,
      child:  subtitle != null ?

      Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 16, top: 10, bottom: 8),
          child: Icon(icon, size: 20, color: Color(0xff4B5563),),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.only(right: 12,  top: 10, bottom: 8),
          child: Text(title, style:  GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400)),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 8,  top: 12, bottom: 10),
          child: Text(subtitle!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 30),
          child: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff9CA3AF)),
        ),
      ],
      ) :

      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 16, top: 10, bottom: 8),
            child: Icon(icon, size: 20, color: Color(0xff4B5563),),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(right: 12,  top: 10, bottom: 8),
            child: Text(title, style:  GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400)),
          )),
          const Padding(
            padding: EdgeInsets.only(right: 30),
            child: Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xff9CA3AF)),
          ),
        ],
      )


    );
  }
}