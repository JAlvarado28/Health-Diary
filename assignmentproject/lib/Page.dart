import 'package:assignmentproject/Widgets/HeartRate.dart';
import 'package:assignmentproject/Widgets/calorieIntake.dart';
import 'package:assignmentproject/Widgets/exercise.dart';
import 'package:assignmentproject/Widgets/goals.dart';
import 'package:assignmentproject/Widgets/sleepPatterns.dart';
import 'package:assignmentproject/Widgets/waterIntake.dart';
import 'package:assignmentproject/Widgets/weight.dart';
import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        Goals(),
        Weight(),
        Exercise(),
        CalorieIntake(),
        HeartRate(),
        SleepPatterns(),
        WaterIntake(),
      ],
    ));
  }
}
