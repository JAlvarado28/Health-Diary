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

class firstPage extends StatelessWidget {
  String currentDate;
  firstPage({super.key, required this.currentDate});

  Future<String> getStoredDate() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('dates')
        .doc(currentDate)
        .get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    return userData?['currentDate'] as String? ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 16,
            ),
          ),
        ),
        body: Column(
          children: [
            AppHeader(),
            Dates(dates: currentDate),
            //  Goals(dates: currentDate),
            // Weight(),
            // Exercise(),
            CalorieIntake(dates: currentDate),
            // HeartRate(),
            // SleepPatterns(),
            waterIntake(dates: currentDate),
          ],
        ));
  }
}
