import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';

class IconButtonWidget extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
   IconButtonWidget({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          height: 42.h,
          width: 48.w,
          decoration: BoxDecoration(
            color: ColorStrings.lightSkyBlue,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding:  EdgeInsets.all(14.h),
            child: SvgPicture.asset(
              icon,
              color: ColorStrings.blackColor,
              width: 8.w,
              height: 8.h,
            ),
          )
      ),
    );
  }
}

