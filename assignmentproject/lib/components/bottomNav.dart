import 'package:assignmentproject/storage.dart';
import 'package:flutter/material.dart';
import 'package:assignmentproject/about.dart';
import 'package:assignmentproject/home.dart';
import 'package:assignmentproject/dailyProgress.dart';
import 'package:assignmentproject/settings.dart';
import 'package:intl/intl.dart';

class NavigationBarApp extends StatefulWidget {
  bool trigger;
  NavigationBarApp({super.key, required this.trigger});

  @override
  State<NavigationBarApp> createState() => _NavigationBarApp();
}

class _NavigationBarApp extends State<NavigationBarApp> {
  int currentPageIndex = 0;
  String currentDate = DateFormat('MM-dd-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  List<Widget> getPages(bool fitbitConnected) {
    return [
      Home(currentDate: currentDate, fitbitconnected: widget.trigger),
      Settings(),
      About(),
      Progress(currentDate: currentDate),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPages(widget.trigger)[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            label: 'About',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Daily Progress',
          ),
        ],
      ),
    );
  }
}
