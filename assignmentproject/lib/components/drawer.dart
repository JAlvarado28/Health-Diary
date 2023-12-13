import 'package:assignmentproject/components/header.dart';
import 'package:assignmentproject/home.dart';
import 'package:assignmentproject/settings.dart';
import 'package:assignmentproject/about.dart';
import 'package:assignmentproject/dailyProgress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget getDrawer(context) {
  String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    Home(currentDate: currentDate, fitbitconnected: false)));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Settings()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const About()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.bar_chart),
          title: const Text('Daily Progress'),
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Progress(
                      currentDate: currentDate,
                    )));
          },
        ),
      ],
    ),
  );
}
