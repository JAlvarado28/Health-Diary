import 'package:assignmentproject/Widgets/HeartRate.dart';
import 'package:assignmentproject/Widgets/calorieIntake.dart';
import 'package:assignmentproject/Widgets/dates.dart';
import 'package:assignmentproject/Widgets/exercise.dart';
import 'package:assignmentproject/Widgets/goals.dart';
// import 'package:assignmentproject/Widgets/sleepPatterns.dart';
import 'package:assignmentproject/Widgets/waterIntake.dart';
import 'package:assignmentproject/Widgets/weight.dart';
import 'package:assignmentproject/components/bottomNav.dart';
import 'package:assignmentproject/components/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  String currentDate;
  final bool fitbitconnected;
  Home({super.key, required this.currentDate, required this.fitbitconnected});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  int currentIndex = 0;

  void _onDateChanged(String newDate) {
    setState(() {
      widget.currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppHeader(),
            Dates(dates: widget.currentDate, onDateChanged: _onDateChanged),
            Weight(dates: widget.currentDate),
            Exercise(dates: widget.currentDate),
            CalorieIntake(dates: widget.currentDate),
            WaterIntake(dates: widget.currentDate),
            Goals(dates: widget.currentDate),
            if (widget.fitbitconnected) HeartRate(),
            // if (widget.fitbitconnected) SleepPatterns(dates: widget.currentDate),
            if (!widget.fitbitconnected) _Disabled("Heart Rate"),
            // if (!widget.fitbitconnected) _Disabled("Sleep Patterns")
          ],
        ),
      ),
    );
  }

  Widget _Disabled(String Title) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "$Title is disabled. Please connect fitbit",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
