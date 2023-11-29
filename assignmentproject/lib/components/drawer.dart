import 'package:assignmentproject/components/header.dart';
import 'package:assignmentproject/home.dart';
import 'package:assignmentproject/settings.dart';
import 'package:flutter/material.dart';

Widget getDrawer(context) {
  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        const AppHeader(),
        ListTile(
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        ListTile(
          title: const Text('Settings'),
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Settings(
                      title: 'Settings',
                    )));
          },
        ),
      ],
    ),
  );
}
