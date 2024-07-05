import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/habit_model.dart';
import '../../utils/image_resource.dart';
import '../../widgets/headingH2_widget.dart';
import '../../widgets/icon_button_widget.dart';

class StatisticsScreen extends StatelessWidget {
  final Habit habit;

  StatisticsScreen({required this.habit});

  @override
  Widget build(BuildContext context) {
    double completionPercentage = habit.getCompletionPercentage();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButtonWidget(icon: ImageResource.backIcon,
                      onPressed: (){
                        Navigator.pop(context);
                      } ),

                  Expanded(
                    child: Center(
                      child: HeadingH2Widget("Statistcs"),
                    ),
                  ),
                  SizedBox(
                    width: 42.w,
                  ),
                ],
              ),


              Text('Habit: ${habit.title}', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 16),
              Text('Category: ${habit.category}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              Text('Completion: ${completionPercentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: completionPercentage / 100),
            ],
          ),
        ),
      ),
    );
  }
}
