import 'package:flutter/material.dart';

class CustomTooltip extends StatefulWidget {
  const CustomTooltip({super.key});

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '100%',
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
                child: Center(
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black
                      ),
                      child: Center(
                        child: Text("100%",style: TextStyle(
                            fontSize: 9, color: Colors.blueAccent
                        ),),
                      )),
                ),
              ),
            ],
          ),
          ClipPath(
            clipper: HorizontalFlippedTriangleClipper(),
            child: Container(
              height: 12,
              width: 11,  // Adjust width to make the triangle more visible
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalFlippedTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, 0); // Start at top-right corner
    path.lineTo(size.width / 2, size.height); // Line to bottom center
    path.lineTo(0, 0); // Line to top-left corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}



