import 'package:assignmentproject/components/bottomNav.dart';
import 'package:assignmentproject/components/drawer.dart';
import 'package:assignmentproject/components/header.dart';
import 'package:assignmentproject/firstPage.dart';
import 'package:assignmentproject/settings.dart';
import 'package:flutter/material.dart';
import 'package:assignmentproject/Widgets/dates.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // List<DateTime> dateList = List.generate(7, (index) {
    //   DateTime today = DateTime.now();
    //   return DateTime(today.year, today.month, today.day + index);
    // });
    return const Scaffold(
      body: Column(
        children: [
          AppHeader(),
//          Drawer(),
//          Dates(dateList: dateList),
//          BottomNav(),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(),
      ),
    );
  }
}
