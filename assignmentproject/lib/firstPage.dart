import 'package:assignmentproject/Widgets/HeartRate.dart';
import 'package:assignmentproject/Widgets/calorieIntake.dart';
import 'package:assignmentproject/Widgets/dates.dart';
import 'package:assignmentproject/Widgets/exercise.dart';
import 'package:assignmentproject/Widgets/goals.dart';
import 'package:assignmentproject/Widgets/sleepPatterns.dart';
import 'package:assignmentproject/Widgets/waterIntake.dart';
import 'package:assignmentproject/Widgets/weight.dart';
import 'package:assignmentproject/components/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class firstPage extends StatefulWidget {
  String currentDate;
  firstPage({super.key, required this.currentDate});

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<firstPage> {
  void _onDateChanged(String newDate) {
    setState(() {
      widget.currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        AppHeader(),
        Dates(dates: widget.currentDate, onDateChanged: _onDateChanged),
        //  Goals(dates: currentDate),
        Weight(dates: widget.currentDate),
        // Exercise(),
        CalorieIntake(dates: widget.currentDate),
        // HeartRate(),
        // SleepPatterns(),
        WaterIntake(dates: widget.currentDate),
      ],
    ));
  }
}
