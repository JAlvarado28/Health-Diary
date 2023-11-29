import 'package:assignmentproject/components/bottomNav.dart';
import 'package:assignmentproject/components/drawer.dart';
import 'package:assignmentproject/components/header.dart';
import 'package:assignmentproject/settings.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        AppHeader(),
        BottomNav(),
      ],
    ));
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
